package gui_controller;

import javafx.fxml.FXML;
import javafx.fxml.FXMLLoader;

import javafx.scene.control.Label;
import javafx.scene.layout.HBox;
import javafx.scene.layout.VBox;

import java.io.IOException;
import java.util.List;

public class ManageTrucksTablesController {

    @FXML Label nameLabel, emailLabel;

    @FXML VBox vbox;

    public void setData(List<String> truckDriverInfo, List<List<String>> palletsInfo) {

        vbox.setMinHeight((59 * palletsInfo.size()) + 144);
        nameLabel.setText(truckDriverInfo.get(1) + " " + truckDriverInfo.get(2));
        emailLabel.setText(truckDriverInfo.get(0));

        for (List<String> palletInfo : palletsInfo) {

            FXMLLoader fxmlTableRowLoader = new FXMLLoader();
            fxmlTableRowLoader.setLocation(
                    getClass().getResource("../views/manageTrucksTableRow.fxml"));

            try {
                HBox hbox = fxmlTableRowLoader.load();
                ManageTrucksTableRowController mttrc = fxmlTableRowLoader.getController();
                mttrc.setData(palletInfo);
                vbox.getChildren().add(hbox);
            } catch (IOException e) {
                e.printStackTrace();
            }
        }
    }
}
