package gui_controller;

import javafx.event.ActionEvent;
import javafx.fxml.FXML;
import javafx.fxml.FXMLLoader;

import javafx.scene.control.Button;
import javafx.scene.control.TextField;
import javafx.scene.control.ToggleButton;
import javafx.scene.control.ToggleGroup;
import javafx.scene.layout.HBox;
import javafx.scene.layout.VBox;

import java.io.IOException;

import java.lang.reflect.InvocationTargetException;
import java.security.NoSuchAlgorithmException;
import java.util.*;

public class EntryRequestController extends UserController {

    @FXML private Map<HBox, String> indexMap = new HashMap<>();

    @FXML private VBox vbox1;

    @FXML private TextField productField, companyField, quantityField;
    @FXML private ToggleButton normalButton, perishableButton;

    @FXML private ToggleGroup typeGroup;

    public void populate() {
        changeImage(wms.getPicture());
        changeUserName(wms.getName());
    }

    public void addPalletButtonHandler(ActionEvent event) {

        if (!productField.getText().equals("")
                && !companyField.getText().equals("")
                && !quantityField.getText().equals("")
                && (normalButton.isSelected() || perishableButton.isSelected())) {
            FXMLLoader fxmlTableRowLoader = new FXMLLoader();
            fxmlTableRowLoader.setLocation(
                    getClass().getResource("../views/entryRequestTableRow.fxml"));
            try {
                HBox hbox = fxmlTableRowLoader.load();
                EntryRequestTableRowController ertrc = fxmlTableRowLoader.getController();
                if (vbox1.getChildren().size() * 59 + 60 > vbox1.getMinHeight()) {
                    vbox1.setMinHeight(59 + vbox1.getMinHeight());
                }
                String palletID = this.wms.generatePalletID();
                String product = productField.getText().toUpperCase();
                String quantity = quantityField.getText().toUpperCase();
                String company = companyField.getText().toUpperCase();
                String type =
                        ((ToggleButton) typeGroup.getSelectedToggle()).getId().split("Button")[0];
                ((Button) fxmlTableRowLoader.getNamespace().get("deleteButton"))
                        .setOnAction(
                                e -> {
                                    vbox1.getChildren().remove(hbox);
                                    try {
                                        this.wms.removeUserPallet(
                                                this.wms.getId(), this.indexMap.get(hbox));
                                    } catch (NoSuchMethodException
                                            | InvocationTargetException
                                            | IllegalAccessException noSuchMethodException) {
                                        PopUpController.popup(
                                                0, "ERROR", "SOMETHING IS WRONG WITH THIS REMOVAL");
                                    }
                                    this.removeIndex(hbox);
                                });
                wms.addUserPallet(
                        wms.getId(), palletID, product, Integer.valueOf(quantity), company, type);
                ertrc.setData(Arrays.asList("id", product, quantity, company, type));
                indexMap.put(hbox, palletID);
                vbox1.getChildren().add(hbox);
                productField.clear();
                companyField.clear();
                quantityField.clear();
                normalButton.setSelected(false);
                perishableButton.setSelected(false);

            } catch (IOException
                    | NoSuchMethodException
                    | IllegalAccessException
                    | InvocationTargetException
                    | NoSuchAlgorithmException e) {
                PopUpController.popup(0, "ERROR", "SOMETHING IS WRONG WITH THIS PALLET");
            }
        } else {
            PopUpController.popup(0, "INVALID PALLET", "");
        }
    }

    public Map<HBox, String> getIndexMap() {
        Map<HBox, String> indexMap = new HashMap<>();
        this.indexMap.forEach(indexMap::put);
        return indexMap;
    }

    public void setIndexMap(Map<HBox, String> indexMap) {
        this.indexMap = new HashMap<>();
        indexMap.forEach(this.indexMap::put);
    }

    public void removeIndex(HBox hbox) {
        Map<HBox, String> indexMap = new HashMap<>();
        this.indexMap.entrySet().stream()
                .filter(entry -> !entry.getKey().equals(hbox))
                .forEach(entry -> indexMap.put(entry.getKey(), entry.getValue()));
        this.setIndexMap(indexMap);
    }

    public void deleteAllButtonHandler(ActionEvent event)
            throws NoSuchMethodException, IllegalAccessException, InvocationTargetException {
        this.wms.removeAllUserPallets(this.wms.getId());
        this.indexMap = new HashMap<>();
        vbox1.getChildren()
                .removeAll(vbox1.getChildren().filtered(i -> !i.getId().equals("firstNode")));
    }

    public void saveButtonHandler(ActionEvent event) {
        vbox1.getChildren()
                .removeAll(vbox1.getChildren().filtered(i -> !i.getId().equals("firstNode")));
        try {
            wms.makeEntryRequest(wms.getId());
            PopUpController.popup(1, "ENTRY REQUEST SENT!", "WAITING FOR APPROVAL FROM AN ADMIN");
        } catch (NoSuchMethodException | IllegalAccessException | InvocationTargetException e) {
            PopUpController.popup(0, "ERROR", "SOMETHING IS WRONG WITH YOUR REQUEST");
        }
    }
}
