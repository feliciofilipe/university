package gui_controller;

import javafx.fxml.FXML;

import javafx.scene.control.Label;
import javafx.scene.layout.Pane;

import java.util.List;

public class ManageTrucksTableRowController {

    @FXML Label productLabel, companyLabel, quantityLabel, typeLabel;

    @FXML Pane typePane;

    public void setData(List<String> info) {
        productLabel.setText(info.get(1).toUpperCase());
        companyLabel.setText(info.get(3).toUpperCase());
        quantityLabel.setText(info.get(2).toUpperCase());
        typeLabel.setText(info.get(4).toUpperCase());

        if (info.get(4).toUpperCase().equals("NORMAL")) {
            typePane.setStyle("-fx-background-color: #6e7ffb");
        } else {
            typePane.setStyle("-fx-background-color: #82c3fa");
        }
    }
}
