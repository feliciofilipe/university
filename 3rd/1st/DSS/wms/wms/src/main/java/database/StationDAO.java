package database;

import javafx.util.Pair;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.Statement;

public class StationDAO {

    public Pair<Integer, Integer> getCoords(String idStation) {
        int x = 0, y = 0;
        try {
            Connection conn =
                    DriverManager.getConnection(Config.URL + Config.DATABASE + Config.CREDENTIALS);
            Statement stm = conn.createStatement();
            ResultSet rs =
                    stm.executeQuery(
                            "SELECT * FROM Station WHERE IDStation = " + idStation + " LIMIT 1 ");
            // SELECT * FROM Station_Pallet INNER JOIN Pallet ON
            // Station_Pallet.Pallet=Pallet.IDPallet
            if (rs.next()) {
                String id = rs.getString(1);
                x = rs.getInt(2);
                y = rs.getInt(3);
            }
            conn.close();
        } catch (Exception e) {
            // Erro a criar tabela...
            e.printStackTrace();
            throw new NullPointerException(e.getMessage());
        }
        return new Pair<>(x, y);
    }
}
