package database;

import model.User;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.Collection;
import java.util.Map;
import java.util.Set;
import java.sql.ResultSet;

public class UserDAO implements Map<String, User> {
    private static UserDAO singleton = null;

    private static final String USERNAME = "sql7382084"; // TODO: alterar
    private static final String PASSWORD = "fmH48UEKA1"; // TODO: alterar
    private static final String CREDENTIALS = "?user=" + USERNAME + "&password=" + PASSWORD;
    private static final String DATABASE = "sql7.freemysqlhosting.net:3306/sql7382084";
    private static final String URL = "jdbc:mysql://";

    private UserDAO() {
        try (Connection conn = DriverManager.getConnection(URL + DATABASE + CREDENTIALS);
                Statement stm = conn.createStatement()) {
            String sql = "SELECT IDProduct, Name, Stock FROM Product";
            ResultSet rsa = stm.executeQuery(sql);
            while (rsa.next()) {
                int id = rsa.getInt("id");
                String name = rsa.getString("Name");
                String description = rsa.getString("Stock");
                System.out.println(id + " " + description + " " + name);
            }
            /*try (ResultSet rsa = stm.executeQuery(sql)) {
            if (rsa.next()) {  // Encontrou a sala
                s = new Sala(rs.getString("Sala"),
                             rsa.getString("Edificio"),
                             rsa.getInt("Capacidade"));
            } else {*/

        } catch (SQLException e) {
            // Erro a criar tabela...
            e.printStackTrace();
            throw new NullPointerException(e.getMessage());
        }
    }

    /** @return número de turmas na base de dados */
    public void queryExample() {
        try (Connection conn =
                        DriverManager.getConnection("jdbc:mysql://" + DATABASE + CREDENTIALS);
                Statement stm = conn.createStatement()) {
            String sql = "SELECT IDProduct, Name, Stock FROM Product";
            ResultSet rsa = stm.executeQuery(sql);
            while (rsa.next()) {
                int id = rsa.getInt("IDProduct");
                String name = rsa.getString("Name");
                String description = rsa.getString("Stock");
                System.out.println(id + " " + description + " " + name);
            }
        } catch (SQLException e) {
            // Erro a criar tabela...
            e.printStackTrace();
            throw new NullPointerException(e.getMessage());
        }
    }

    public static UserDAO getInstance() {
        if (UserDAO.singleton == null) {
            UserDAO.singleton = new UserDAO();
        }
        return UserDAO.singleton;
    }

    @Override
    public int size() {
        /*      try(
        Statement stm = conn.createStatement()){
        String sql = "SELECT id, Name, Description FROM Products";
                stm.executeUpdate(sql);
            }
        catch (SQLException e){;
        }*/
        return 0;
    }

    @Override
    public boolean isEmpty() {
        return false;
    }

    @Override
    public boolean containsKey(Object o) {
        return false;
    }

    @Override
    public boolean containsValue(Object o) {
        return false;
    }

    @Override
    public User get(Object o) {
        return null;
    }

    @Override
    public User put(String s, User user) {
        return null;
    }

    @Override
    public User remove(Object o) {
        return null;
    }

    @Override
    public void putAll(Map<? extends String, ? extends User> map) {}

    @Override
    public void clear() {}

    @Override
    public Set<String> keySet() {
        return null;
    }

    @Override
    public Collection<User> values() {
        return null;
    }

    @Override
    public Set<Entry<String, User>> entrySet() {
        return null;
    }
}
