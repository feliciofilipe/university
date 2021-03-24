package database;

import model.Notification;

import java.sql.*;
import java.util.ArrayList;
import java.util.Collection;
import java.util.Map;
import java.util.Set;
import java.util.function.BiConsumer;
import java.util.function.BiFunction;
import java.util.function.Function;

public class NotificationDAO implements Map<String, Notification> {

  String table = "Notifications";

  @Override
  public int size() {
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
  public Notification get(Object o) {
    return null;
  }

  @Override
  public Notification put(String s, Notification notification) {
    return null;
  }

  @Override
  public Notification remove(Object key) {
    try {
      Connection conn =
          DriverManager.getConnection(Config.URL + Config.DATABASE + Config.CREDENTIALS);
      Statement stm = conn.createStatement();
      String sql = "DELETE FROM " + this.table + " WHERE " + "NotificationID" + " = '" + key + "'";
      stm.executeUpdate(sql);
    } catch (SQLException throwables) {
      throwables.printStackTrace();
    }
    return null;
  }

  @Override
  public void putAll(Map<? extends String, ? extends Notification> map) {}

  @Override
  public void clear() {
    try {
      Connection conn =
          DriverManager.getConnection(Config.URL + Config.DATABASE + Config.CREDENTIALS);
      Statement stm = conn.createStatement();
      String sql = "DELETE FROM " + this.table;
      ResultSet rs = stm.executeQuery(sql);
      conn.close();
    } catch (SQLException e) {
      e.printStackTrace();
      throw new NullPointerException(e.getMessage());
    }
  }

  @Override
  public Set<String> keySet() {
    return null;
  }

  @Override
  public Collection<Notification> values() {
    Collection<Notification> res = new ArrayList<>();
    try {
      Connection conn =
          DriverManager.getConnection(Config.URL + Config.DATABASE + Config.CREDENTIALS);
      Statement stm = conn.createStatement();
      String sql = "SELECT * FROM " + this.table;
      ResultSet rs = stm.executeQuery(sql);
      while (rs.next()) {
        Integer id = rs.getInt(1);
        String text = rs.getString(2);
        res.add(new Notification(id, text));
      }
      conn.close();
    } catch (SQLException e) {;
    }
    return res;
  }

  @Override
  public Set<Entry<String, Notification>> entrySet() {
    return null;
  }

  @Override
  public Notification getOrDefault(Object key, Notification defaultValue) {
    return null;
  }

  @Override
  public void forEach(BiConsumer<? super String, ? super Notification> action) {}

  @Override
  public void replaceAll(
      BiFunction<? super String, ? super Notification, ? extends Notification> function) {}

  @Override
  public Notification putIfAbsent(String key, Notification value) {
    return null;
  }

  @Override
  public boolean remove(Object key, Object value) {
    return false;
  }

  @Override
  public boolean replace(String key, Notification oldValue, Notification newValue) {
    return false;
  }

  @Override
  public Notification replace(String key, Notification value) {
    return null;
  }

  @Override
  public Notification computeIfAbsent(
      String key, Function<? super String, ? extends Notification> mappingFunction) {
    return null;
  }

  @Override
  public Notification computeIfPresent(
      String key,
      BiFunction<? super String, ? super Notification, ? extends Notification> remappingFunction) {
    return null;
  }

  @Override
  public Notification compute(
      String key,
      BiFunction<? super String, ? super Notification, ? extends Notification> remappingFunction) {
    return null;
  }

  @Override
  public Notification merge(
      String key,
      Notification value,
      BiFunction<? super Notification, ? super Notification, ? extends Notification>
          remappingFunction) {
    return null;
  }

  public void putNotification(String notification) {
    try {
      Connection conn =
          DriverManager.getConnection(Config.URL + Config.DATABASE + Config.CREDENTIALS);
      Statement stm = conn.createStatement();

      stm.executeUpdate("INSERT into Notifications VALUES " + "(NULL,'" + notification + "')");
      conn.close();
    } catch (SQLException e) {
      e.printStackTrace();
      throw new NullPointerException(e.getMessage());
    }
  }
}
