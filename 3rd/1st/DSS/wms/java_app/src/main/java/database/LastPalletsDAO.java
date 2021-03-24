package database;

import java.sql.*;
import java.util.*;

public class LastPalletsDAO {

  public int size() {
    int res = 0;
    try {
      Connection conn =
          DriverManager.getConnection(Config.URL + Config.DATABASE + Config.CREDENTIALS);
      Statement stm = conn.createStatement();
      String sql = "SELECT count(*) FROM LastPallets;";
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

  public boolean add(List<String> strings) {
    boolean res = false;
    try {
      Connection conn =
          DriverManager.getConnection(Config.URL + Config.DATABASE + Config.CREDENTIALS);
      Statement stm = conn.createStatement();
      stm.executeUpdate(
          "INSERT into LastPallets VALUES "
              + "('"
              + strings.get(0)
              + "', '"
              + strings.get(1)
              + "', '"
              + strings.get(2)
              + "', '"
              + strings.get(3)
              + "', '"
              + strings.get(4)
              + "') ");
      conn.close();
      res = true;
    } catch (SQLException e) {
      e.printStackTrace();
      throw new NullPointerException(e.getMessage());
    }
    return res;
  }

  public boolean remove() {
    boolean res = false;
    try {
      Connection conn =
          DriverManager.getConnection(Config.URL + Config.DATABASE + Config.CREDENTIALS);
      Statement stm = conn.createStatement();
      String sql = "DELETE FROM LastPallets LIMIT 1";
      stm.executeUpdate(sql);
      res = true;
    } catch (SQLException throwables) {
      throwables.printStackTrace();
    }
    return res;
  }

  public List<List<String>> getAll() {
    List res = new ArrayList();
    try {
      Connection conn =
          DriverManager.getConnection(Config.URL + Config.DATABASE + Config.CREDENTIALS);
      Statement stm = conn.createStatement();
      String sql = "SELECT * FROM LastPallets";
      ResultSet rs = stm.executeQuery(sql);
      while (rs.next()) {
        res.add(
            Arrays.asList(
                rs.getString(1),
                rs.getString(2),
                rs.getString(3),
                rs.getString(4),
                rs.getString(5)));
      }
      conn.close();
    } catch (SQLException e) {
      e.printStackTrace();
      throw new NullPointerException(e.getMessage());
    }
    return res;
  }
}
