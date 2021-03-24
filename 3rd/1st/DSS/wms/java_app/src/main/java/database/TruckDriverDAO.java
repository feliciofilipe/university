package database;

import model.TruckDriver;

import java.sql.*;
import java.util.*;

public class TruckDriverDAO implements Map<String, TruckDriver> {

  private final String table = "TruckDriver";
  private final List<String> columns =
      Arrays.asList(new String[] {"id", "firstName", "lastName", "salt", "password", "active"});

  public TruckDriverDAO() {}

  @Override
  public int size() {
    int res = 0;
    try {
      Connection conn =
          DriverManager.getConnection(Config.URL + Config.DATABASE + Config.CREDENTIALS);
      Statement stm = conn.createStatement();
      String sql = "SELECT count(*) FROM " + this.table + ";";
      ResultSet rs = stm.executeQuery(sql);
      {
        if (rs.next()) {
          res = rs.getInt(1);
        }
      }
      conn.close();
    } catch (SQLException e) {
      e.printStackTrace();
      throw new NullPointerException(e.getMessage());
    }
    return res;
  }

  @Override
  public boolean isEmpty() {
    return false;
  }

  @Override
  public boolean containsKey(Object key) {
    boolean res = false;
    try {
      Connection conn =
          DriverManager.getConnection(Config.URL + Config.DATABASE + Config.CREDENTIALS);
      Statement stm = conn.createStatement();
      String sql =
          "SELECT * FROM "
              + this.table
              + " WHERE "
              + this.columns.get(0)
              + "= '"
              + key.toString()
              + "';";
      ResultSet rs = stm.executeQuery(sql);
      res = (rs.next());
      conn.close();
    } catch (SQLException e) {
      return false;
    }
    return res;
  }

  @Override
  public boolean containsValue(Object value) {
    return false;
  }

  @Override
  public TruckDriver get(Object o) {
    TruckDriver res = null;
    try {
      Connection conn =
          DriverManager.getConnection(Config.URL + Config.DATABASE + Config.CREDENTIALS);
      Statement stm = conn.createStatement();
      String sql =
          "SELECT * FROM " + this.table + " WHERE " + this.columns.get(0) + " ='" + o + "';";
      ResultSet rs = stm.executeQuery(sql);

      if (rs.next()) {
        String id = rs.getString(1);
        String firstName = rs.getString(2);
        String lastName = rs.getString(3);
        String salt = rs.getString(4);

        String password = rs.getString(5);
        Boolean active = rs.getBoolean(6);

        res = new TruckDriver(id, firstName, lastName, salt, password, active);
      }
      conn.close();
    } catch (SQLException e) {
      // Erro a criar tabela...
      e.printStackTrace();
      throw new NullPointerException(e.getMessage());
    }
    return res;
  }

  @Override
  public TruckDriver put(String key, TruckDriver value) {
    TruckDriver res = null;

    if (this.containsKey(key)) res = get(key);
    try {
      Connection conn =
          DriverManager.getConnection(Config.URL + Config.DATABASE + Config.CREDENTIALS);
      Statement stm = conn.createStatement();

      stm.executeUpdate(
          "INSERT into TruckDriver VALUES "
              + "('"
              + value.getId()
              + "', '"
              + value.getFirstName()
              + "', '"
              + value.getLastName()
              + "', '"
              + value.getSalt()
              + "', '"
              + value.getPassword()
              + "', '"
              + value.getActive()
              + "') "
              + "ON DUPLICATE KEY UPDATE firstName=VALUES(firstName),"
              + "lastName=VALUES(lastName),"
              + "salt=VALUES(salt),"
              + "password=VALUES(password),"
              + "active=Values(active)");

      conn.close();
    } catch (SQLException e) {
      e.printStackTrace();
      throw new NullPointerException(e.getMessage());
    }
    return res;
  }

  public TruckDriver remove(Object key) {
    try {
      Connection conn =
          DriverManager.getConnection(Config.URL + Config.DATABASE + Config.CREDENTIALS);
      Statement stm = conn.createStatement();
      String sql =
          "DELETE FROM " + this.table + " WHERE " + this.columns.get(0) + " = '" + key + "'";
      stm.executeUpdate(sql);
    } catch (SQLException throwables) {
      throwables.printStackTrace();
    }
    return null;
  }

  @Override
  public void putAll(Map<? extends String, ? extends TruckDriver> m) {}

  @Override
  public void clear() {}

  @Override
  public Set<String> keySet() {
    return null;
  }

  public Collection<TruckDriver> values() {
    Collection<TruckDriver> res = new ArrayList<>();
    try {
      Connection conn =
          DriverManager.getConnection(Config.URL + Config.DATABASE + Config.CREDENTIALS);
      Statement stm = conn.createStatement();
      String sql = "SELECT * FROM " + this.table;
      ResultSet rs = stm.executeQuery(sql);
      while (rs.next()) {
        String id = rs.getString(1);
        String firstName = rs.getString(2);
        String lastName = rs.getString(3);
        String salt = rs.getString(4);
        String password = rs.getString(5);
        Boolean active = rs.getBoolean(6);
        res.add(new TruckDriver(id, firstName, lastName, salt, password, active));
      }
      conn.close();
    } catch (SQLException e) {;
    }
    return res;
  }

  @Override
  public Set<Entry<String, TruckDriver>> entrySet() {
    return null;
  }
}
