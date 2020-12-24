package gui_controller;

import exceptions.AuthenticationException;
import javafx.event.ActionEvent;

import javafx.fxml.FXML;

import javafx.scene.control.TextField;
import util.Passwords;

import java.lang.reflect.InvocationTargetException;
import java.security.NoSuchAlgorithmException;

public class EditProfile extends UserController {

    @FXML private TextField firstNameField, lastNameField, emailField, passwordField;

    public void populate() {
        changeImage(wms.getPicture());
        changeUserName(wms.getName());
    }

    public void saveButtonHandler(ActionEvent event)
            throws NoSuchAlgorithmException, InvocationTargetException, NoSuchMethodException,
                    InstantiationException, IllegalAccessException {

        if (PopUpController.popup(
                3, "EDIT PROFILE", "ARE YOU SURE WANT TO CHANGE YOUR\nCREDENTIALS?")) {
            Class[] classes = {
                String.class, String.class, String.class, String.class, String.class
            };
            String salt = Passwords.getSalt();
            String[] input = {
                emailField.getText(),
                firstNameField.getText(),
                lastNameField.getText(),
                salt,
                Passwords.getEncryptedPassword(passwordField.getText(), salt)
            };

            try {
                wms.addUser(this.wms.getClass(this.wms.getId()), input, classes);
                wms.acceptUser(emailField.getText());
                wms.removeUser(this.wms.getId());
                this.wms.setName(firstNameField.getText() + " " + lastNameField.getText());
                this.wms.setId(emailField.getText());
                wms.setPicture(getPath(emailField.getText()));
                PopUpController.popup(1, "SUCCESS!", "YOUR PROFILE HAS BEEN\nSUCCESSFULLY UPDATED");
            } catch (AuthenticationException e) {
                PopUpController.popup(0, "INVALID CREDENTIALS", " ");
            }
        }
    }
}
