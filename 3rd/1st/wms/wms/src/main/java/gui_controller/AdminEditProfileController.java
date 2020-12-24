package gui_controller;

import javafx.fxml.FXML;
import javafx.scene.control.PasswordField;
import javafx.scene.input.KeyEvent;
import javafx.scene.layout.Pane;

public class AdminEditProfileController extends EditProfile {

    @FXML PasswordField passwordField;

    @FXML Pane redPane, orangePane, greenPane, bluePane;

    @FXML
    private void scoreHandler(KeyEvent event) {
        scoreHandler(passwordField.getText(), redPane, orangePane, greenPane, bluePane);
    }
}
