package database;

import javafx.util.Pair;
import model.Pallet;

import java.sql.*;
import java.util.*;

public class PalletDAO {

  Map<String, Pair<List<String>, String>> pallets = new HashMap<>();

  public Pallet get(Object o) {
    Pallet res = null;
    try {
      Connection conn =
          DriverManager.getConnection(Config.URL + Config.DATABASE + Config.CREDENTIALS);
      Statement stm = conn.createStatement();
      String sql = "SELECT * FROM " + "Pallet" + " WHERE " + "IDPallet" + " ='" + o + "';";
      ResultSet rs = stm.executeQuery(sql);
      if (rs.next()) {
        String IDPallet = rs.getString(1);
        Integer quantity = rs.getInt(2);
        String company = rs.getString(3);
        String type = rs.getString(4);
        String product = rs.getString(6);

        res = new Pallet(IDPallet, product, quantity, company, type);
      }
      conn.close();
    } catch (SQLException e) {
      e.printStackTrace();
      throw new NullPointerException(e.getMessage());
    }
    return res;
  }

  public Pallet put(String key, Pallet value, String stationID) {
    Pallet res = null;

    if (this.containsKey(key)) res = get(key);
    try {
      Connection conn =
          DriverManager.getConnection(Config.URL + Config.DATABASE + Config.CREDENTIALS);
      Statement stm = conn.createStatement();

      stm.executeUpdate(
          "INSERT into Pallet VALUES "
              + "('"
              + Integer.valueOf(value.getId())
              + "', '"
              + value.getQuantity()
              + "', '"
              + value.getCompany()
              + "', '"
              + value.getType()
              + "', '"
              + Integer.valueOf(stationID)
              + "', '"
              + value.getProduct()
              + "','UNPROCESSED') "
              + "ON DUPLICATE KEY UPDATE IDPallet=VALUES(IDPallet),"
              + "Quantity=VALUES(Quantity),"
              + "Company=VALUES(Company),"
              + "Station=VALUES(Station),"
              + "Product=Values(Product),"
              + "Status=Values(Status)");

      conn.close();
    } catch (SQLException e) {
      e.printStackTrace();
      throw new NullPointerException(e.getMessage());
    }
    return res;
  }

  public boolean containsKey(Object key) {
    boolean res = false;
    try {
      Connection conn =
          DriverManager.getConnection(Config.URL + Config.DATABASE + Config.CREDENTIALS);
      Statement stm = conn.createStatement();
      String sql =
          "SELECT * FROM " + "Pallet" + " WHERE " + "IDPallet" + "= '" + key.toString() + "';";
      ResultSet rs = stm.executeQuery(sql);
      res = rs.next();
      conn.close();
    } catch (SQLException e) {
      return false;
    }
    return res;
  }

  public void changePalletStation(String id, String station) {
    try {
      Connection conn =
          DriverManager.getConnection(Config.URL + Config.DATABASE + Config.CREDENTIALS);
      conn.createStatement()
          .executeUpdate(
              "UPDATE Pallet\n"
                  + "SET Station = '"
                  + station
                  + "'\n"
                  + "WHERE IDPallet = "
                  + id
                  + ";");
      conn.close();
    } catch (SQLException e) {
      e.printStackTrace();
      throw new NullPointerException(e.getMessage());
    }
  }

  public Map<String, Pair<List<String>, String>> getPalletsLocations() {
    this.pallets = new HashMap<>();
    try {
      Connection conn =
          DriverManager.getConnection(Config.URL + Config.DATABASE + Config.CREDENTIALS);
      Statement stm = conn.createStatement();
      String sql = "SELECT * FROM " + "Pallet";
      ResultSet rs = stm.executeQuery(sql);
      while (rs.next()) {
        String id = rs.getString(1);
        String product = rs.getString(2);
        String quantity = rs.getString(3);
        String company = rs.getString(4);
        String type = rs.getString(5);
        String station = rs.getString(6);
        pallets.put(id, new Pair<>(Arrays.asList(product, quantity, company, type), station));
      }
      conn.close();
    } catch (Exception e) {
      e.printStackTrace();
      throw new NullPointerException(e.getMessage());
    }
    return this.pallets;
  }

  public int size() {
    int res = 0;
    try {
      Connection conn =
          DriverManager.getConnection(Config.URL + Config.DATABASE + Config.CREDENTIALS);
      Statement stm = conn.createStatement();
      String sql = "SELECT count(*) FROM " + "Pallet" + ";";
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

  public Map<String, Pair<Pallet, String>> getPalletsFrom(int location) {
    Map<String, Pair<Pallet, String>> res = new HashMap<>();

    try {
      Connection conn =
          DriverManager.getConnection(Config.URL + Config.DATABASE + Config.CREDENTIALS);
      Statement stm = conn.createStatement();
      String sql = "SELECT * FROM Pallet WHERE Station ='" + location + "';";
      ResultSet rs = stm.executeQuery(sql);

      while (rs.next()) {
        String id = rs.getString(1);
        String quantity = rs.getString(2);
        String company = rs.getString(3);
        String type = rs.getString(4);
        String product = rs.getString(6);
        String status = rs.getString(7);
        res.put(
            id,
            new Pair(new Pallet(id, product, Integer.valueOf(quantity), company, type), status));
      }

      conn.close();
    } catch (SQLException e) {
      e.printStackTrace();
      throw new NullPointerException(e.getMessage());
    }
    return res;
  }

  public void changeStatus(String palletID) {
    try {
      Connection conn =
          DriverManager.getConnection(Config.URL + Config.DATABASE + Config.CREDENTIALS);
      conn.createStatement()
          .executeUpdate(
              "UPDATE Pallet\n"
                  + "SET Status = 'PROCESSED'\n"
                  + "WHERE IDPallet = "
                  + palletID
                  + ";");
      conn.close();
    } catch (SQLException e) {
      e.printStackTrace();
      throw new NullPointerException(e.getMessage());
    }
  }

  public String getStation(String palletID) {
    String res = null;
    try {
      Connection conn =
          DriverManager.getConnection(Config.URL + Config.DATABASE + Config.CREDENTIALS);
      Statement stm = conn.createStatement();
      String sql = "SELECT Station FROM Pallet WHERE IDPallet=" + palletID;
      ResultSet rs = stm.executeQuery(sql);
      if (rs.next()) {
        res = rs.getString(1);
      }
      conn.close();
    } catch (Exception e) {
      e.printStackTrace();
      throw new NullPointerException(e.getMessage());
    }
    return res;
  }

  public Pallet remove(Object key) {

    try {
      Connection conn =
          DriverManager.getConnection(Config.URL + Config.DATABASE + Config.CREDENTIALS);
      Statement stm = conn.createStatement();
      String sql = "DELETE FROM Pallet WHERE IDPallet = '" + key + "'";
      stm.executeUpdate(sql);
    } catch (SQLException throwables) {
      throwables.printStackTrace();
    }
    return null;
  }
}
