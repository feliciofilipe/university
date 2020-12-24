package gui_controller;

import javafx.fxml.FXML;
import javafx.fxml.FXMLLoader;
import javafx.scene.layout.HBox;
import javafx.scene.layout.VBox;

import java.io.IOException;
import java.util.List;

public class ShippingStationPalletTableController {

    @FXML private VBox vbox1;

    @FXML
    public void setData(List<List<String>> palletsInfo) {

        vbox1.setMinHeight((45 * palletsInfo.size()) + 45);

        for (List<String> palletInfo : palletsInfo) {

            FXMLLoader fxmlTableRowLoader = new FXMLLoader();
            fxmlTableRowLoader.setLocation(
                    getClass().getResource("../views/shippingStationPalletTableRow.fxml"));

            try {
                HBox hbox = fxmlTableRowLoader.load();
                ShippingStationPalletTableRowController ssptrc = fxmlTableRowLoader.getController();
                ssptrc.setData(palletInfo);
                vbox1.getChildren().add(hbox);
            } catch (IOException e) {
                e.printStackTrace();
            }
        }
    }
}
