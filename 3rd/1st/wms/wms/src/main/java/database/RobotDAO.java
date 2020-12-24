package database;


import java.sql.*;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class RobotDAO {

    Map<String, List<String>> robots = new HashMap<>();

    public Map<String, List<String>> allRobots() {
        this.robots = new HashMap<>();
        try {
            Connection conn =
                    DriverManager.getConnection(Config.URL + Config.DATABASE + Config.CREDENTIALS);
            Statement stm = conn.createStatement();
            ResultSet rs = stm.executeQuery("SELECT * FROM Robot");
            if (rs.next()) {
                String id = rs.getString(1);
                String x = rs.getString(2);
                String y = rs.getString(3);
                String capacity = rs.getString(4);
                String station = rs.getString(5);
                String status = rs.getString(6);
                this.robots.put(id, Arrays.asList(x, y, capacity, station, status));
            }
            conn.close();
        } catch (Exception e) {
            // Erro a criar tabela...
            e.printStackTrace();
            throw new NullPointerException(e.getMessage());
        }
        return this.robots;
    }

    public void changeRobotStatus(String id, String status) {
        try {
            Connection conn =
                    DriverManager.getConnection(Config.URL + Config.DATABASE + Config.CREDENTIALS);
            conn.createStatement()
                    .executeUpdate(
                            "UPDATE Robot\n"
                                    + "SET Status = '"
                                    + status
                                    + "'\n"
                                    + "WHERE IDRobot = "
                                    + id
                                    + ";");
            conn.close();
        } catch (SQLException e) {
            // Database error!
            e.printStackTrace();
            throw new NullPointerException(e.getMessage());
        }
    }

    public void changeRobotCoords(String id, Integer x, Integer y) {
        try {
            Connection conn =
                    DriverManager.getConnection(Config.URL + Config.DATABASE + Config.CREDENTIALS);
            conn.createStatement()
                    .executeUpdate(
                            "UPDATE Robot\n"
                                    + "SET X = "
                                    + x
                                    + ", Y = "
                                    + y
                                    + "\n"
                                    + "WHERE IDRobot = "
                                    + id
                                    + ";");
            conn.close();
        } catch (SQLException e) {
            // Database error!
            e.printStackTrace();
            throw new NullPointerException(e.getMessage());
        }
    }

    public int size() {
        int res = 0;
        try {
            Connection conn =
                    DriverManager.getConnection(Config.URL + Config.DATABASE + Config.CREDENTIALS);
            Statement stm = conn.createStatement();
            String sql = "SELECT count(*) FROM " + "Robot" + ";";
            ResultSet rs = stm.executeQuery(sql);
            {
                if (rs.next()) {
                    res = rs.getInt(1);
                }
            }
            conn.close();
        } catch (SQLException e) {
            // Erro a criar tabela...
            e.printStackTrace();
            throw new NullPointerException(e.getMessage());
        }
        return res;
    }

}
