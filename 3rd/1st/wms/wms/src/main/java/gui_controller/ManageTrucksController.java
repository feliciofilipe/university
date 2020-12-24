package gui_controller;

import javafx.event.ActionEvent;

import javafx.fxml.FXML;
import javafx.fxml.FXMLLoader;

import javafx.scene.control.Label;
import javafx.scene.image.Image;
import javafx.scene.image.ImageView;
import javafx.scene.layout.HBox;
import javafx.scene.layout.Pane;

import javafx.util.Pair;

import java.io.IOException;
import java.util.Deque;
import java.util.LinkedList;
import java.util.List;

public class ManageTrucksController extends UserController {

    @FXML private final Deque<Pair<HBox, List<String>>> hboxlist = new LinkedList<>();

    @FXML private Label noRequestLabel, momentLabel;

    @FXML private Pane outerPane1;

    public void populate() {
        changeImage(wms.getPicture());
        changeUserName(wms.getName());
        addIncomingTruckDrivers(wms.getEntryRequests());
    }

    private void addIncomingTruckDrivers(List<Pair<List<String>, List<List<String>>>> list) {
        list.forEach(this::addIncomingTruckDriver);
    }

    private void addIncomingTruckDriver(Pair<List<String>, List<List<String>>> list) {

        FXMLLoader fxmlTableLoader = new FXMLLoader();
        fxmlTableLoader.setLocation(getClass().getResource("../views/manageTrucksTables.fxml"));

        try {
            HBox hbox = fxmlTableLoader.load();
            hbox.setLayoutX(422);
            hbox.setLayoutY(86);
            ManageTrucksTablesController mttc = fxmlTableLoader.getController();

            String path =
                    (!list.getKey().get(0).equals("felicio@gmail.com"))
                            ? "truckdriver.png"
                            : "filipe.png";

            ((ImageView) fxmlTableLoader.getNamespace().get("truckDriverImage"))
                    .setImage(
                            new Image(getClass().getResourceAsStream("../images/profile/" + path)));

            mttc.setData(list.getKey(), list.getValue());
            outerPane1.getChildren().add(hbox);
            hboxlist.addFirst(new Pair<>(hbox, list.getKey()));
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    public void decisionHandler(ActionEvent event) {

        switch (event.getSource().toString().substring(10).split(",", 2)[0]) {
            case "rejectButton":
                if (!hboxlist.isEmpty()) {
                    wms.denyEntryRequest(hboxlist.getFirst().getValue().get(0));
                    outerPane1.getChildren().remove(hboxlist.getFirst().getKey());
                    hboxlist.removeFirst();
                } else {
                    PopUpController.popup(0, "NO REQUESTS!", "THERE ARE NO REQUESTS TO REJECT");
                }
                break;

            case "waitButton":
                if (!hboxlist.isEmpty()) {
                    hboxlist.addLast(hboxlist.getFirst());
                    hboxlist.getFirst().getKey().toBack();
                    noRequestLabel.toBack();
                    momentLabel.toBack();
                    hboxlist.removeFirst();
                } else {
                    PopUpController.popup(0, "NO REQUESTS!", "THERE ARE NO REQUESTS TO WAIT");
                }
                break;

            case "acceptButton":
                if (!hboxlist.isEmpty()) {
                    wms.acceptEntryRequest(hboxlist.getFirst().getValue().get(0));
                    outerPane1.getChildren().remove(hboxlist.getFirst().getKey());
                    hboxlist.removeFirst();
                } else {
                    PopUpController.popup(0, "NO REQUESTS!", "THERE ARE NO REQUESTS TO ACCEPT");
                }
                break;

            default:
                break;
        }
    }
}
