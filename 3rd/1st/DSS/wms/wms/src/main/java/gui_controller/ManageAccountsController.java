package gui_controller;

import javafx.fxml.FXML;
import javafx.fxml.FXMLLoader;

import javafx.scene.control.Button;
import javafx.scene.layout.HBox;
import javafx.scene.layout.VBox;

import java.io.IOException;

import java.lang.reflect.InvocationTargetException;
import java.util.List;

public class ManageAccountsController extends UserController {

    @FXML private VBox vbox;

    public void populate() {
        changeImage(wms.getPicture());
        changeUserName(wms.getName());
        addAccounts(wms.getPendingUsers());
    }

    @FXML
    private void addAccounts(List<List<String>> accounts) {
        accounts.forEach(this::addAccount);
    }

    @FXML
    private void addAccount(List<String> account) {

        FXMLLoader fxmlTableLoader = new FXMLLoader();
        fxmlTableLoader.setLocation(getClass().getResource("../views/manageAccountsTableRow.fxml"));

        try {
            HBox hbox = fxmlTableLoader.load();
            ManageAccountsTableRowController matrc = fxmlTableLoader.getController();

            if (vbox.getChildren().size() * 73 + 60 > vbox.getMinHeight()) {
                vbox.setMinHeight(73 + vbox.getMinHeight());
            }

            ((Button) (fxmlTableLoader.getNamespace().get("acceptAccountButton")))
                    .setOnAction(
                            e -> {
                                try {
                                    wms.acceptUser(account.get(0));
                                } catch (NoSuchMethodException
                                        | InstantiationException
                                        | IllegalAccessException
                                        | InvocationTargetException noSuchMethodException) {
                                    PopUpController.popup(0, "ERROR", "");
                                }
                                vbox.getChildren().remove(hbox);
                            });

            ((Button) (fxmlTableLoader.getNamespace().get("rejectAccountButton")))
                    .setOnAction(
                            e -> {
                                wms.removeUser(account.get(0));
                                vbox.getChildren().remove(hbox);
                            });

            matrc.setData(account);
            vbox.getChildren().add(hbox);

        } catch (IOException e) {
            e.printStackTrace();
        }
    }
}
