package database;


import java.lang.reflect.*;
import java.sql.*;
import java.util.*;

public class StandardizedDAO<K, C> implements Map<K, C> {
    private static StandardizedDAO singleton = null;
    private static String table;
    private static List<String> columns;
    private C clazz;
    /*  private static final String USERNAME = "POO"; //
            private static final String PASSWORD = "g21"; //T
            private static final String CREDENTIALS = "?user="+USERNAME+"&password="+PASSWORD;
            private static final String DATABASE = "localhost:3306/WMS_DB";
    */
    public StandardizedDAO(String table, C clazz, List<String> columns) {
        try (Connection conn =
                        DriverManager.getConnection(
                                "jdbc:mariadb://" + Config.DATABASE + Config.CREDENTIALS);
                Statement stm = conn.createStatement()) {
            String sql =
                    "CREATE TABLE IF NOT EXISTS `Teste` ("
                            + "`id` VARCHAR(45) NOT NULL,"
                            + "`nomeCliente` VARCHAR(45) NOT NULL,"
                            + "PRIMARY KEY (`id`));";
            stm.executeUpdate(sql);
            this.table = table;
            this.clazz = clazz;
            this.columns = columns;
        } catch (SQLException e) {
            // Erro a criar tabela...
            e.printStackTrace();
            throw new NullPointerException(e.getMessage());
        }
    }

    public StandardizedDAO getInstance(String table, C clazz, List<String> columns) {
        if (StandardizedDAO.singleton == null) {
            StandardizedDAO.singleton = new StandardizedDAO(table, clazz, columns);
        }
        return StandardizedDAO.singleton;
    }

    @Override
    public int size() {
        int res = 0;
        try {
            Connection conn =
                    DriverManager.getConnection(
                            "jdbc:mariadb://" + Config.DATABASE + Config.CREDENTIALS);
            Statement stm = conn.createStatement();
            String sql = "SELECT count(*) FROM " + this.table + ";";
            ResultSet rs = stm.executeQuery(sql);
            {
                if (rs.next()) {
                    res = rs.getInt(1);
                }
            }
        } catch (SQLException e) {
            // Erro a criar tabela...
            e.printStackTrace();
            throw new NullPointerException(e.getMessage());
        }
        return res;
    }

    @Override
    public boolean isEmpty() {
        return this.size() == 0;
    }

    @Override
    public boolean containsKey(Object o) {
        K a = (K) o;
        boolean res = false;
        try {
            Connection conn =
                    DriverManager.getConnection(
                            "jdbc:mariadb://" + Config.DATABASE + Config.CREDENTIALS);
            Statement stm = conn.createStatement();
            String sql =
                    "SELECT * FROM "
                            + this.table
                            + " WHERE "
                            + this.columns.get(0)
                            + "= "
                            + a.toString()
                            + ";";
            ResultSet rs = stm.executeQuery(sql);
            res = (rs.next());
        } catch (SQLException e) {
            // Erro a criar tabela...
            e.printStackTrace();
            throw new NullPointerException(e.getMessage());
        }
        return res;
    }

    @Override
    public boolean containsValue(Object o) {
        return false;
    }

    @Override
    public C get(Object o) {
        C res = null;
        // isto diz-me o tipo da classe C.
        Class clazz =
                ((Class)
                        ((ParameterizedType) getClass().getGenericSuperclass())
                                .getActualTypeArguments()[1]);

        try {
            Connection conn =
                    DriverManager.getConnection(
                            "jdbc:mariadb://" + Config.DATABASE + Config.CREDENTIALS);
            Statement stm = conn.createStatement();
            String sql =
                    "SELECT * FROM "
                            + this.table
                            + " WHERE "
                            + this.columns.get(0)
                            + " ="
                            + o
                            + ";";
            ResultSet rs = stm.executeQuery(sql);
            if (rs.next()) {
                int num_columns = rs.getMetaData().getColumnCount();
                List<String> fields_string = new ArrayList<String>();
                for (int i = 1; i <= num_columns; i++) {
                    fields_string.add(i - 1, rs.getString(i));
                }
                Class cls[] = new Class[] {String[].class};
                res =
                        (C)
                                clazz.getConstructor(new Class[] {String[].class})
                                        .newInstance((Object) fields_string.toArray(new String[2]));
                // res = (C) Teste.class.getConstructor(new Class[]{String.class,
                // String.class}).newInstance("teste","teste");
                int p = 1 + 2;
                /*List<Class<?>> c = new ArrayList<>();
                Arrays.stream(clazz.getDeclaredFields()).forEach(y -> c.add(y.getType()));
                Constructor constructor = clazz.getConstructor(((Class<?>[]) c.toArray()));*/
                // String[] prod = ;
                // constructor.newInstance(prod);
            }
        } catch (SQLException | NoSuchMethodException e) {
            // Erro a criar tabela...
            e.printStackTrace();
            throw new NullPointerException(e.getMessage());
        } catch (IllegalAccessException e) {
            e.printStackTrace();
        } catch (InstantiationException e) {
            e.printStackTrace();
        } catch (InvocationTargetException e) {
            e.printStackTrace();
        }
        return res;
    }

    @Override
    public C put(K key, C value) {
        C res = null;
        if (this.containsKey(key)) res = get(key);
        // Ir buscar os m+etodos da classe C
        Method[] methods = value.getClass().getMethods();
        // Filtrar os metodos, deixando só os gets;
        Object[] methods2 =
                Arrays.stream(methods)
                        .filter(
                                y ->
                                        y.getName().startsWith("get")
                                                && !y.getName().startsWith("getClass"))
                        .toArray();
        ;
        int i = 0;
        try {
            // values -> Array com os valores das variaveis da classe C
            ArrayList values = new ArrayList<>(methods2.length);
            while (i < methods2.length) {
                Method man = (Method) methods2[i];
                Object elem = man.invoke(value, null);
                values.add(i, elem);
                i++;
            }
            Connection conn =
                    DriverManager.getConnection(
                            "jdbc:mariadb://" + Config.DATABASE + Config.CREDENTIALS);
            Statement stm = conn.createStatement();
            StringBuilder query = new StringBuilder();
            query.append("INSERT into " + this.table + " VALUES ('");
            i = 0;
            while (i < values.size() - 1) {
                query.append(values.get(i).toString() + "', '");
                i++;
            }
            query.append(values.get(i));
            // + (value.id) + "', '" + value.nomeCliente
            query.append("') ");
            query.append("ON DUPLICATE KEY ");
            // nomeCliente = VALUES(nomeCliente)";
            i = 1;
            while (i < this.columns.size() - 1) {
                String col = this.columns.get(i);
                query.append("UPDATE " + col + "=(" + col + "),");
                i++;
            }
            // Sem a virgula
            String col = this.columns.get(i);
            query.append("UPDATE " + col + "=(" + col + ")");

            String sql = query.toString();
            stm.executeUpdate(sql);

            /*INSERT INTO turmas VALUES ('"+t.getId()+"', '"+s.getNumero()+"') " +
            "ON DUPLICATE KEY UPDATE Sala=VALUES(Sala)"*/
        } catch (SQLException | IllegalAccessException | InvocationTargetException e) {
            // Erro a criar tabela...
            e.printStackTrace();
            throw new NullPointerException(e.getMessage());
        }
        return res;
    }

    @Override
    public C remove(Object o) {
        return null;
    }

    @Override
    public void putAll(Map<? extends K, ? extends C> map) {
        ;
    }

    @Override
    public void clear() {}

    @Override
    public Set<K> keySet() {
        return null;
    }

    @Override
    public Collection<C> values() {
        return null;
    }

    @Override
    public Set<Entry<K, C>> entrySet() {
        return null;
    }
}
