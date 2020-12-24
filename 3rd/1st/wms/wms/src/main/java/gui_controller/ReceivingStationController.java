package gui_controller;

import javafx.event.ActionEvent;
import javafx.fxml.FXML;
import javafx.fxml.FXMLLoader;

import javafx.scene.control.*;
import javafx.scene.image.Image;
import javafx.scene.image.ImageView;
import javafx.scene.layout.HBox;
import javafx.scene.layout.Pane;
import javafx.scene.layout.VBox;
import javafx.util.Pair;

import java.io.IOException;

import java.util.*;
import java.util.stream.Collectors;

public class ReceivingStationController extends UserController {

    @FXML
    private final List<Pair<Pair<RadioButton, String>, List<String>>> list = new ArrayList<>();

    @FXML private Pane outerPane1;

    @FXML private VBox vbox1;

    @FXML private ImageView qrCodeImage;

    public void populate() {
        changeImage(wms.getPicture());
        changeUserName(wms.getName());
        addPallets(wms.getReceivingStationPallets());
    }

    @FXML
    private void addPallets(List<List<String>> pallets) {
        pallets.forEach(this::addPallet);
    }

    @FXML
    private void addPallet(List<String> palletsInfo) {

        FXMLLoader fxmlTableLoader = new FXMLLoader();
        fxmlTableLoader.setLocation(
                getClass().getResource("../views/receivingStationTableRow.fxml"));

        try {
            HBox hbox = fxmlTableLoader.load();
            ReceivingStationTableRowController rstrc = fxmlTableLoader.getController();
            rstrc.setData(palletsInfo);

            RadioButton rb = (RadioButton) (fxmlTableLoader.getNamespace().get("selectButton"));
            String QRimagePath =
                    "../images/QRCodes/qrcode" + (int) ((Math.random() * (8 - 1)) + 1) + ".png";

            list.add(new Pair<>(new Pair<>(rb, QRimagePath), palletsInfo));

            rb.setOnAction(
                    e -> {
                        selectButton(rb);
                    });

            if (vbox1.getChildren().size() * 59 + 53 > vbox1.getMinHeight()) {
                vbox1.setMinHeight(59 + vbox1.getMinHeight());
            }

            vbox1.getChildren().add(hbox);

        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    @FXML
    private void readQRButtonHandler(ActionEvent event) {
        List<RadioButton> radioButtons = getRadioButtonList();
        int res = getButtonIndex(radioButtons);

        if (res != -1) {

            // id da palet
            // todo - depois fazer algoritmo de escolher palete
            String pallet = list.get(res).getValue().get(0);
            System.out.println(pallet);
            wms.createNewJob(pallet, "2");

            // TODO SEND PALLET TO BACKEND (list.get(res).getValue())
            vbox1.setMinHeight(vbox1.getMinHeight() - 59);
            list.remove(res);
            vbox1.getChildren().remove(radioButtons.get(res).getParent());
            qrCodeImage.setImage(null);
        } else {
            PopUpController.popup(
                    0, "PALLET NOT SELECTED", "PLEASE SELECT A PALLET BEFORE TRYING\nTO READ IT");
        }
    }

    @FXML
    private int getButtonIndex(List<RadioButton> radioButtons) {
        int i = 0, res = -1;

        if (!radioButtons.isEmpty()) {
            Iterator<RadioButton> radioButtonsIt = radioButtons.iterator();

            while (radioButtonsIt.hasNext() && res == -1) {
                RadioButton radioButton = radioButtonsIt.next();
                if (radioButton.isSelected()) res = i;
                else {
                    i++;
                }
            }
        }
        return res;
    }

    @FXML
    private List<RadioButton> getRadioButtonList() {
        return vbox1.getChildren().stream()
                .filter(node -> !node.getId().equals("firstHbox"))
                .map(hb -> ((RadioButton) ((HBox) hb).getChildren().get(3)))
                .collect(Collectors.toList());
    }

    @FXML
    private void selectButton(RadioButton rb) {
        List<RadioButton> radioButtons = getRadioButtonList();
        if (!radioButtons.isEmpty()) {
            radioButtons.stream()
                    .filter(r -> !r.equals(rb))
                    .forEach(button -> button.setSelected(false));
            if (radioButtons.stream().anyMatch(ToggleButton::isSelected)) {
                qrCodeImage.setImage(
                        new Image(
                                getClass()
                                        .getResourceAsStream(
                                                list.get(getButtonIndex(radioButtons))
                                                        .getKey()
                                                        .getValue())));
            } else qrCodeImage.setImage(null);
        }
    }
}
