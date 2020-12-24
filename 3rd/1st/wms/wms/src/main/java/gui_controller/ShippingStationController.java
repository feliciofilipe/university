package gui_controller;

import javafx.fxml.FXML;
import javafx.fxml.FXMLLoader;

import javafx.scene.Node;
import javafx.scene.control.Button;
import javafx.scene.control.RadioButton;
import javafx.scene.layout.HBox;
import javafx.scene.layout.VBox;

import java.io.IOException;

import javafx.util.Pair;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;

public class ShippingStationController extends UserController {

    @FXML private final List<Pair<HBox, List<List<String>>>> vboxlist = new ArrayList<>();

    @FXML private HBox outerPane1;

    @FXML private VBox vbox;

    public void populate() {
        changeImage(wms.getPicture());
        changeUserName(wms.getName());
    }
    /*
            addOrders(wms.getOrders()); //TODO : GET ORDERS TO BE SHIPPED LIST<PAIR<STRING,LIST<LIST<STRING>>>>
                                        //                                            ^             ^
                                        //                                            |             |
                                        //                                      ORDERID    LIST OF INFORMATION OF PALLETS
                                        //                                                                          ^
                                        //                                                                          |
                                        //                                                              [ID,PRODUCT,QUANTITY,COMPANY,TYPE]
        }

        TODO: REMOVE (EXAMPLE)
        addOrder(new Pair<>("ORD0032",Arrays.asList(
                Arrays.asList("PAL0032","IPHONE","40","APPLE INC.","NORMAL","SHIPPING STATION"),
                Arrays.asList("PAL0212","BOOKS","200","CONTINENTE","NORMAL","SHELF"),
                Arrays.asList("PAL0312","SHOES","10","ADIDAS","NORMAL","SHELF"),
                Arrays.asList("PAL1032","KEYBOARD","100","CHIP7","NORMAL","RECEIVING STATION"))));

    */

    @FXML
    private void addOrders(List<Pair<String, List<List<String>>>> list) {
        list.forEach(this::addOrder);
    }

    @FXML
    private void addOrder(Pair<String, List<List<String>>> pair) {

        FXMLLoader fxmlTableLoader = new FXMLLoader();
        fxmlTableLoader.setLocation(
                getClass().getResource("../views/shippingStationTableRow.fxml"));

        try {
            HBox hbox = fxmlTableLoader.load();
            ShippingStationTableRowController sstrc = fxmlTableLoader.getController();
            sstrc.setData(pair.getKey());

            RadioButton rb = (RadioButton) (fxmlTableLoader.getNamespace().get("selectButton"));

            rb.setOnAction(
                    e -> {
                        selectButton(hbox);
                        addSideTable(pair.getValue());
                    });

            if (((vbox.getChildren().size() - 1) * 60) + 40 > vbox.getMinHeight()) {
                vbox.setMinHeight(60 + vbox.getMinHeight());
            }

            vboxlist.add(new Pair<>(hbox, pair.getValue()));
            vbox.getChildren().add(hbox);
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    @FXML
    private void selectButton(HBox hbox) {
        vbox.getChildren().stream()
                .filter(node -> !node.equals(hbox) && !node.getId().equals("orderLabel"))
                .forEach(hb -> ((RadioButton) ((HBox) hb).getChildren().get(1)).setSelected(false));
    }

    @FXML
    private int getSelectedButtonIndex() {
        int i = 0, res = 0;
        Iterator<Node> nodes =
                vbox.getChildren().stream()
                        .filter(node -> !node.getId().equals("orderLabel"))
                        .map(node -> ((HBox) node).getChildren().get(1))
                        .iterator();

        while (nodes.hasNext() && res == 0) {
            RadioButton radioButton = (RadioButton) nodes.next();
            i++;
            if (radioButton.isSelected()) res = i;
        }

        return res;
    }

    @FXML
    private void addSideTable(List<List<String>> palletInfo) {

        if (outerPane1.getChildren().size() == 2) {
            outerPane1.getChildren().remove(1);
        }

        FXMLLoader fxmlTableLoader = new FXMLLoader();
        fxmlTableLoader.setLocation(
                getClass().getResource("../views/shippingStationPalletTable.fxml"));

        try {
            VBox vboxTable = fxmlTableLoader.load();
            ShippingStationPalletTableController ssptc = fxmlTableLoader.getController();

            ssptc.setData(vboxlist.get(getSelectedButtonIndex() - 1).getValue());

            ((Button) vboxTable.getChildren().get(1))
                    .setOnAction(
                            e -> {
                                // TODO: CLEAN PALLET FROM BACKEND (PALLETINFO)
                                outerPane1.getChildren().remove(1);
                                vbox.getChildren().remove(getSelectedButtonIndex());
                            });

            outerPane1.getChildren().add(vboxTable);

        } catch (IOException e) {
            e.printStackTrace();
        }
    }
}
