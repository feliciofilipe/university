package gui_controller;

import javafx.fxml.FXML;
import javafx.fxml.FXMLLoader;
import javafx.scene.layout.HBox;
import javafx.scene.layout.VBox;

import java.io.IOException;

import java.util.List;

public class SeeLocationsController extends UserController {

    @FXML private VBox vbox;

    public void populate() {
        changeImage(wms.getPicture());
        changeUserName(wms.getName());
        addPalletsLocation(wms.getPalletsLocations());
    }

    private void addPalletsLocation(List<List<String>> pallets) {
        pallets.forEach(this::addPalletLocation);
    }

    private void addPalletLocation(List<String> pallet) {

        FXMLLoader fxmlTableLoader = new FXMLLoader();
        fxmlTableLoader.setLocation(getClass().getResource("../views/seeLocationsTableRow.fxml"));

        try {
            HBox hbox = fxmlTableLoader.load();
            SeeLocationsTableRowController sltrc = fxmlTableLoader.getController();

            if (vbox.getChildren().size() * 62 + 60 > vbox.getMinHeight()) {
                vbox.setMinHeight(62 + vbox.getMinHeight());
            }

            sltrc.setData(pallet);
            vbox.getChildren().add(hbox);

        } catch (IOException e) {
            e.printStackTrace();
        }
    }
}
