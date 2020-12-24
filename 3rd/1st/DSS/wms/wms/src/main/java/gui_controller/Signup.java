package gui_controller;

import exceptions.AuthenticationException;
import javafx.event.ActionEvent;
import javafx.fxml.FXML;
import javafx.scene.control.Button;
import javafx.scene.control.Label;
import javafx.scene.control.TextField;
import javafx.scene.input.KeyEvent;
import javafx.scene.layout.Pane;

import model.Admin;
import model.FloorWorker;
import model.TruckDriver;

import util.Passwords;

import java.io.IOException;
import java.lang.reflect.InvocationTargetException;
import java.security.NoSuchAlgorithmException;

public final class Signup extends Controller {

    @FXML Button adminButton, floorWorkerButton, truckDriverButton, signupButton;
    @FXML TextField firstName, lastName, email, password;
    @FXML Pane redPane, orangePane, greenPane, bluePane;
    @FXML Label floorWorkerLabel, adminLabel, truckDriverLabel;

    private Class clazz = Admin.class;

    @FXML
    private void signupHandler(ActionEvent event)
            throws NoSuchAlgorithmException, InvocationTargetException, NoSuchMethodException,
                    InstantiationException, IllegalAccessException {
        Class[] classes = {
            String.class, String.class, String.class, String.class, String.class, Boolean.class
        };
        String salt = Passwords.getSalt();
        String[] input = {
            email.getText(),
            firstName.getText(),
            lastName.getText(),
            salt,
            Passwords.getEncryptedPassword(password.getText(), salt),
            "0"
        };
        try {
            wms.addUser(clazz, input, classes);
            helper.errorPopUp(1, "SIGNUP REQUESTED!", "WAITING FOR APPROVAL FROM AN ADMIN");
            clearSignupSpace();
        } catch (AuthenticationException e) {
            helper.errorPopUp(0, "INVALID CREDENTIALS", " ");
        }
    }

    @FXML
    private void scoreHandler(KeyEvent event) {
        scoreHandler(password.getText(), redPane, orangePane, greenPane, bluePane);
    }

    @FXML
    private void accountType(ActionEvent event) {
        Object source = event.getSource();

        if (adminButton.equals(source)) {
            adminLabel.setUnderline(true);
            floorWorkerLabel.setUnderline(false);
            truckDriverLabel.setUnderline(false);
            this.clazz = Admin.class;
        } else if (floorWorkerButton.equals(source)) {
            adminLabel.setUnderline(false);
            floorWorkerLabel.setUnderline(true);
            truckDriverLabel.setUnderline(false);
            this.clazz = FloorWorker.class;
        } else if (truckDriverButton.equals(source)) {
            adminLabel.setUnderline(false);
            floorWorkerLabel.setUnderline(false);
            truckDriverLabel.setUnderline(true);
            this.clazz = TruckDriver.class;
        }
    }

    @FXML
    public void backHandler(ActionEvent event)
            throws NoSuchMethodException, IllegalAccessException, InvocationTargetException,
                    IOException {
        clearSignupSpace();
        helper.redirectTo("loginButton");
    }

    public void clearSignupSpace() {
        firstName.clear();
        lastName.clear();
        email.clear();
        password.clear();
        clazz = Admin.class;
        adminLabel.setUnderline(true);
        floorWorkerLabel.setUnderline(false);
        truckDriverLabel.setUnderline(false);
        redPane.setStyle("-fx-background-color: #1F2940");
        orangePane.setStyle("-fx-background-color: #1F2940");
        greenPane.setStyle("-fx-background-color: #1F2940");
        bluePane.setStyle("-fx-background-color: #1F2940");
    }

    public void populate() {}
}
