package database;

import javafx.util.Pair;

import java.sql.*;
import java.util.*;

public class JobRobotDAO {

  public Map<String, Pair<String, String>> jobs = new HashMap<>();

  public void createNewJob(String pallet, String station) {
    try {
      Connection conn =
          DriverManager.getConnection(Config.URL + Config.DATABASE + Config.CREDENTIALS);
      conn.createStatement()
          .executeUpdate(
              "INSERT INTO JobRobot (Pallet, Station, Status) VALUES  ("
                  + pallet
                  + ","
                  + station
                  + ","
                  + "'WAITING'"
                  + ")");
      conn.close();
    } catch (SQLException e) {
      e.printStackTrace();
      throw new NullPointerException(e.getMessage());
    }
  }

  public Map<String, Pair<String, String>> generateJobs() {
    this.jobs = new HashMap<>();
    try {
      Connection conn =
          DriverManager.getConnection(Config.URL + Config.DATABASE + Config.CREDENTIALS);
      Statement stm = conn.createStatement();
      ResultSet rs =
          stm.executeQuery(
              "SELECT IDJobRobot, SP.Station, JR.Station FROM "
                  + "JobRobot AS JR INNER JOIN Pallet AS SP ON SP.IDPallet=JR.Pallet "
                  + "WHERE JR.Status='WAITING'");
      while (rs.next()) {
        String Job = rs.getString(1);
        String stationPick = rs.getString(2);
        String stationDrop = rs.getString(3);
        this.jobs.put(Job, new Pair<>(stationPick, stationDrop));
      }
      conn.close();
    } catch (Exception e) {
      e.printStackTrace();
      throw new NullPointerException(e.getMessage());
    }
    return this.jobs;
  }

  public void changeJobStatus(String id, String status) {
    try {
      Connection conn =
          DriverManager.getConnection(Config.URL + Config.DATABASE + Config.CREDENTIALS);
      conn.createStatement()
          .executeUpdate(
              "UPDATE JobRobot\n"
                  + "SET Status = '"
                  + status
                  + "'\n"
                  + "WHERE IDJobRobot = "
                  + id
                  + ";");
      conn.close();
    } catch (SQLException e) {
      e.printStackTrace();
      throw new NullPointerException(e.getMessage());
    }
  }

  public Pair<Integer, Integer> getFirstPosition(String idJob) {
    this.jobs = new HashMap<>();
    int x = 0, y = 0;
    try {
      Connection conn =
          DriverManager.getConnection(Config.URL + Config.DATABASE + Config.CREDENTIALS);
      Statement stm = conn.createStatement();
      ResultSet rs =
          stm.executeQuery(
              "SELECT S.X, S.Y FROM JobRobot AS JR INNER JOIN Pallet AS P ON P.IDPallet=JR.Pallet"
                  + " INNER JOIN Station AS S ON S.IDStation=P.Station\n"
                  + "WHERE IDJobRobot = "
                  + idJob
                  + ";");
      if (rs.next()) {
        x = rs.getInt(1);
        y = rs.getInt(2);
      }
      conn.close();
    } catch (Exception e) {
      e.printStackTrace();
      throw new NullPointerException(e.getMessage());
    }
    return new Pair<>(x, y);
  }

  public Pair<Integer, Integer> getSecondPosition(String idJob) {
    this.jobs = new HashMap<>();
    int x = 0, y = 0;
    try {
      Connection conn =
          DriverManager.getConnection(Config.URL + Config.DATABASE + Config.CREDENTIALS);
      Statement stm = conn.createStatement();
      ResultSet rs =
          stm.executeQuery(
              "SELECT S.X, S.Y FROM JobRobot AS JR INNER JOIN Station AS S ON S.IDStation=JR.Station "
                  + "WHERE IDJobRobot = "
                  + idJob
                  + ";");
      if (rs.next()) {
        x = rs.getInt(1);
        y = rs.getInt(2);
      }
      conn.close();
    } catch (Exception e) {
      e.printStackTrace();
      throw new NullPointerException(e.getMessage());
    }
    return new Pair<>(x, y);
  }

  public String getPallet(String idJob) {
    String idPallet = "";
    try {
      Connection conn =
          DriverManager.getConnection(Config.URL + Config.DATABASE + Config.CREDENTIALS);
      Statement stm = conn.createStatement();
      ResultSet rs =
          stm.executeQuery("SELECT Pallet FROM JobRobot WHERE IDJobRobot= " + idJob + ";");
      if (rs.next()) {
        idPallet = rs.getString(1);
      }
      conn.close();
    } catch (Exception e) {
      e.printStackTrace();
      throw new NullPointerException(e.getMessage());
    }
    return idPallet;
  }

  public String getStation(String idJob) {
    String idStation = "";
    try {
      Connection conn =
          DriverManager.getConnection(Config.URL + Config.DATABASE + Config.CREDENTIALS);
      Statement stm = conn.createStatement();
      ResultSet rs =
          stm.executeQuery("SELECT Station FROM JobRobot WHERE IDJobRobot= " + idJob + ";");
      if (rs.next()) {
        idStation = rs.getString(1);
      }
      conn.close();
    } catch (Exception e) {
      e.printStackTrace();
      throw new NullPointerException(e.getMessage());
    }
    return idStation;
  }
}
