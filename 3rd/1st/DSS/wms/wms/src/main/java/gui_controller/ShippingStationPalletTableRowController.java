package gui_controller;

import javafx.fxml.FXML;
import javafx.scene.control.Label;
import javafx.scene.layout.Pane;

import java.util.List;

public class ShippingStationPalletTableRowController {

    @FXML private Pane typePane;

    @FXML private Label productLabel, quantityLabel, typeLabel;

    public void setData(List<String> pallet) {
        productLabel.setText(pallet.get(1).toUpperCase());
        quantityLabel.setText(pallet.get(2).toUpperCase());
        typeLabel.setText(pallet.get(4).toUpperCase());

        if (pallet.get(4).toUpperCase().equals("NORMAL")) {
            typePane.setStyle("-fx-background-color: #6e7ffb");
        } else {
            typePane.setStyle("-fx-background-color: #82c3fa");
        }
    }
}
