package database;

import javafx.util.Pair;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class StationDAO {

  public Pair<Integer, Integer> getCoords(String idStation) {
    int x = 0, y = 0;
    try {
      Connection conn =
          DriverManager.getConnection(Config.URL + Config.DATABASE + Config.CREDENTIALS);
      Statement stm = conn.createStatement();
      ResultSet rs =
          stm.executeQuery("SELECT * FROM Station WHERE IDStation = " + idStation + " LIMIT 1 ");
      if (rs.next()) {
        String id = rs.getString(1);
        x = rs.getInt(2);
        y = rs.getInt(3);
      }
      conn.close();
    } catch (Exception e) {
      e.printStackTrace();
      throw new NullPointerException(e.getMessage());
    }
    return new Pair<>(x, y);
  }

  public int getWarehouseCapacity() {
    int res = 0;
    try {
      Connection conn =
          DriverManager.getConnection(Config.URL + Config.DATABASE + Config.CREDENTIALS);
      Statement stm = conn.createStatement();
      String sql = "SELECT * FROM Station";
      ResultSet rs = stm.executeQuery(sql);

      while (rs.next()) {
        res += rs.getInt(4);
      }

      conn.close();
    } catch (SQLException e) {
      e.printStackTrace();
      throw new NullPointerException(e.getMessage());
    }
    return res;
  }

  public List<String> getShelfs() {
    List<String> res = new ArrayList<>();
    try {
      Connection conn =
          DriverManager.getConnection(Config.URL + Config.DATABASE + Config.CREDENTIALS);
      Statement stm = conn.createStatement();
      String sql = "SELECT IDStation FROM Station WHERE IDStation > 2";
      ResultSet rs = stm.executeQuery(sql);

      while (rs.next()) {
        res.add(rs.getString(1));
      }

      conn.close();
    } catch (SQLException e) {
      e.printStackTrace();
      throw new NullPointerException(e.getMessage());
    }
    return res;
  }

  public List<Pair<Integer, Integer>> getStations() {
    List<Pair<Integer, Integer>> res = new ArrayList<>();
    try {
      Connection conn =
          DriverManager.getConnection(Config.URL + Config.DATABASE + Config.CREDENTIALS);
      Statement stm = conn.createStatement();
      String sql = "SELECT X, Y FROM Station";
      ResultSet rs = stm.executeQuery(sql);

      while (rs.next()) {
        res.add(new Pair<>(rs.getInt(1), rs.getInt(2)));
      }

      conn.close();
    } catch (SQLException e) {
      e.printStackTrace();
      throw new NullPointerException(e.getMessage());
    }
    return res;
  }
}
