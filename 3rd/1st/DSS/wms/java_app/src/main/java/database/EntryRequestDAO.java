package database;

import model.EntryRequest;

import java.sql.*;
import java.util.*;
import java.util.function.BiConsumer;
import java.util.function.BiFunction;
import java.util.function.Function;

public class EntryRequestDAO implements Map<String, EntryRequest> {

  private String table = "EntryRequest";
  private final List<String> columns =
      Arrays.asList("palletID", "product", "quantity", "company", "type", "truckID");

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
          res = rs.getInt(91);
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
  public boolean containsKey(Object o) {
    return false;
  }

  @Override
  public boolean containsValue(Object o) {
    return false;
  }

  @Override
  public EntryRequest get(Object o) {
    EntryRequest res = null;
    try {
      Connection conn =
          DriverManager.getConnection(Config.URL + Config.DATABASE + Config.CREDENTIALS);
      Statement stm = conn.createStatement();
      String sql =
          "SELECT * FROM " + this.table + " WHERE " + this.columns.get(0) + " ='" + o + "';";
      ResultSet rs = stm.executeQuery(sql);
      int k = 0;
      if (rs.next()) {
        String palletID = rs.getString(1);
        String product = rs.getString(2);
        Integer quantity = rs.getInt(3);
        String company = rs.getString(4);
        String type = rs.getString(5);
        String truckID = rs.getString(6);

        res = new EntryRequest(palletID, product, quantity, company, type, truckID);
        conn.close();
      }
    } catch (SQLException e) {
      e.printStackTrace();
      throw new NullPointerException(e.getMessage());
    }
    return res;
  }

  @Override
  public EntryRequest put(String key, EntryRequest value) {
    EntryRequest res = null;

    int i;
    if (this.containsKey(key)) res = get(key);
    try {
      Connection conn =
          DriverManager.getConnection(Config.URL + Config.DATABASE + Config.CREDENTIALS);
      Statement stm = conn.createStatement();

      stm.executeUpdate(
          "INSERT into EntryRequest VALUES "
              + "('"
              + value.getId()
              + "', '"
              + value.getProduct()
              + "', '"
              + value.getQuantity()
              + "', '"
              + value.getCompany()
              + "', '"
              + value.getType()
              + "', '"
              + value.getTruckID()
              + "') "
              + "ON DUPLICATE KEY UPDATE product=VALUES(product),"
              + "quantity=VALUES(quantity),"
              + "company=VALUES(company),"
              + "type=VALUES(type),"
              + "truckID=Values(truckID)");

      conn.close();
    } catch (SQLException e) {
      e.printStackTrace();
      throw new NullPointerException(e.getMessage());
    }
    return res;
  }

  @Override
  public EntryRequest remove(Object truckID) {
    try {
      Connection conn =
          DriverManager.getConnection(Config.URL + Config.DATABASE + Config.CREDENTIALS);
      Statement stm = conn.createStatement();
      String sql = "DELETE FROM " + this.table + " WHERE " + "truckID" + " = '" + truckID + "'";
      stm.executeUpdate(sql);
    } catch (SQLException throwables) {
      throwables.printStackTrace();
    }
    return null;
  }

  @Override
  public void putAll(Map<? extends String, ? extends EntryRequest> map) {}

  @Override
  public void clear() {}

  @Override
  public Set<String> keySet() {
    return null;
  }

  @Override
  public Collection<EntryRequest> values() {
    Collection<EntryRequest> res = new ArrayList<>();
    try {
      Connection conn =
          DriverManager.getConnection(Config.URL + Config.DATABASE + Config.CREDENTIALS);
      Statement stm = conn.createStatement();
      String sql = "SELECT * FROM " + this.table;
      ResultSet rs = stm.executeQuery(sql);
      while (rs.next()) {
        String palletID = rs.getString(1);
        String product = rs.getString(2);
        Integer quantity = rs.getInt(3);
        String company = rs.getString(4);
        String type = rs.getString(5);
        String truckID = rs.getString(6);
        res.add(new EntryRequest(palletID, product, quantity, company, type, truckID));
      }
      conn.close();
    } catch (SQLException e) {;
    }
    return res;
  }

  @Override
  public Set<Entry<String, EntryRequest>> entrySet() {
    return null;
  }

  @Override
  public EntryRequest getOrDefault(Object key, EntryRequest defaultValue) {
    return null;
  }

  @Override
  public void forEach(BiConsumer<? super String, ? super EntryRequest> action) {}

  @Override
  public void replaceAll(
      BiFunction<? super String, ? super EntryRequest, ? extends EntryRequest> function) {}

  @Override
  public EntryRequest putIfAbsent(String key, EntryRequest value) {
    return null;
  }

  @Override
  public boolean remove(Object key, Object value) {
    return false;
  }

  @Override
  public boolean replace(String key, EntryRequest oldValue, EntryRequest newValue) {
    return false;
  }

  @Override
  public EntryRequest replace(String key, EntryRequest value) {
    return null;
  }

  @Override
  public EntryRequest computeIfAbsent(
      String key, Function<? super String, ? extends EntryRequest> mappingFunction) {
    return null;
  }

  @Override
  public EntryRequest computeIfPresent(
      String key,
      BiFunction<? super String, ? super EntryRequest, ? extends EntryRequest> remappingFunction) {
    return null;
  }

  @Override
  public EntryRequest compute(
      String key,
      BiFunction<? super String, ? super EntryRequest, ? extends EntryRequest> remappingFunction) {
    return null;
  }

  @Override
  public EntryRequest merge(
      String key,
      EntryRequest value,
      BiFunction<? super EntryRequest, ? super EntryRequest, ? extends EntryRequest>
          remappingFunction) {
    return null;
  }
}
