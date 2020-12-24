package gui_controller;

import javafx.fxml.FXML;
import javafx.scene.control.Label;
import javafx.scene.image.Image;
import javafx.scene.image.ImageView;
import javafx.scene.layout.Pane;

import java.util.List;

public class ManageAccountsTableRowController {

    @FXML Label firstNameLabel, lastNameLabel, emailLabel, typeAccountLabel;

    @FXML Pane typePane;

    @FXML ImageView image2;

    public void setData(List<String> info) {
        firstNameLabel.setText(info.get(1).toUpperCase());
        lastNameLabel.setText(info.get(2).toUpperCase());
        emailLabel.setText(info.get(0).toUpperCase());

        switch (info.get(5).toUpperCase()) {
            case "ADMIN":
                typeAccountLabel.setText("ADMIN");
                typePane.setStyle("-fx-background-color: #81c2f9");
                image2.setImage(
                        new Image(getClass().getResourceAsStream("../images/profile/admin.png")));
                break;

            case "FLOORWORKER":
                typeAccountLabel.setText("FLOOR WORKER");
                typePane.setStyle("-fx-background-color: #6e7ffa");
                image2.setImage(
                        new Image(
                                getClass()
                                        .getResourceAsStream("../images/profile/floorworker.png")));
                break;

            case "TRUCKDRIVER":
                typeAccountLabel.setText("TRUCK DRIVER");
                typePane.setStyle("-fx-background-color: #b7b7b7");
                image2.setImage(
                        new Image(
                                getClass()
                                        .getResourceAsStream("../images/profile/truckdriver.png")));
                break;

            default:
                break;
        }
    }
}
