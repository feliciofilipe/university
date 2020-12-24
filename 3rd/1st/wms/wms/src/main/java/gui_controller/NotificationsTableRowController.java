package gui_controller;

import javafx.fxml.FXML;
import javafx.scene.control.Label;

public class NotificationsTableRowController {

    @FXML private Label notificationLabel;

    public void setData(String string) {
        notificationLabel.setText(string.toUpperCase());
    }
}
