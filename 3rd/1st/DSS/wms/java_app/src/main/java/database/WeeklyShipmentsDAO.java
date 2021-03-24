package database;

import java.sql.*;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

public class WeeklyShipmentsDAO {

  public List<Integer> get() {
    List<Integer> res = new ArrayList<>();
    try {
      Connection conn =
          DriverManager.getConnection(Config.URL + Config.DATABASE + Config.CREDENTIALS);
      Statement stm = conn.createStatement();
      String sql = "SELECT * FROM WeeklyShipments";
      ResultSet rs = stm.executeQuery(sql);
      if (rs.next()) {
        res =
            Arrays.asList(
                rs.getInt(1),
                rs.getInt(2),
                rs.getInt(3),
                rs.getInt(4),
                rs.getInt(5),
                rs.getInt(6),
                rs.getInt(7));
      }
      conn.close();
    } catch (SQLException e) {
      e.printStackTrace();
      throw new NullPointerException(e.getMessage());
    }
    return res;
  }

  public int get(String day) {
    int res = 0;
    try {
      Connection conn =
          DriverManager.getConnection(Config.URL + Config.DATABASE + Config.CREDENTIALS);
      Statement stm = conn.createStatement();
      String sql = "SELECT " + day + " FROM WeeklyShipments";
      ResultSet rs = stm.executeQuery(sql);
      if (rs.next()) {
        res = rs.getInt(1);
      }
      conn.close();
    } catch (SQLException e) {
      e.printStackTrace();
      throw new NullPointerException(e.getMessage());
    }
    return res;
  }

  public void put(int entry, String day) {

    try {
      Connection conn =
          DriverManager.getConnection(Config.URL + Config.DATABASE + Config.CREDENTIALS);
      Statement stm = conn.createStatement();

      stm.executeUpdate("UPDATE WeeklyShipments SET " + day + " = '" + entry + "'");

      conn.close();
    } catch (SQLException e) {
      e.printStackTrace();
      throw new NullPointerException(e.getMessage());
    }
  }
}
