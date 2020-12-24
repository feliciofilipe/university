package gui_controller;

import exceptions.AuthenticationException;
import javafx.fxml.FXML;

import javafx.event.ActionEvent;

import javafx.scene.control.PasswordField;
import javafx.scene.control.TextField;

import java.io.IOException;
import java.lang.reflect.InvocationTargetException;

public class Login extends Controller {

    @FXML private TextField emailField;

    @FXML private PasswordField passwordField;

    @FXML
    public void loginHandler(final ActionEvent event) throws AuthenticationException {
        if (!emailField.getText().isBlank() && !passwordField.getText().isBlank()) {
            try {
                String id = emailField.getText();
                String password = passwordField.getText();
                wms.authenticate(id, password);
                wms.setId(id);
                wms.setName(wms.getUserName(id));
                wms.setPicture(getPath(id));
                helper.redirectTo(wms.getClass(id).toString());
            } catch (AuthenticationException e) {
                helper.errorPopUp(0, "INVALID CREDENTIALS", " ");
            } catch (InvocationTargetException
                    | IllegalAccessException
                    | NoSuchMethodException
                    | IOException e) {
                e.printStackTrace();
            }
        } else {
            PopUpController.popup(0, "EMPTY CREDENTIALS", " ");
        }
    }

    public void populate() {}
}
