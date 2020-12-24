package gui_controller;

import javafx.fxml.FXML;
import javafx.scene.control.Label;

public class ShippingStationTableRowController {

    @FXML private Label orderLabel;

    public void setData(String orderID) {

        orderLabel.setText(orderID.toUpperCase());
    }
}
