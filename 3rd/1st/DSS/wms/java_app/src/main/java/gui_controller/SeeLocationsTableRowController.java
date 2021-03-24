package gui_controller;

import javafx.fxml.FXML;
import javafx.scene.control.Label;
import javafx.scene.layout.Pane;
import util.Config;

import java.util.List;

public class SeeLocationsTableRowController {

  @FXML private Label palletIDLabel, productLabel, locationLabel, typeLabel;

  @FXML private Pane typePane;

  public void setData(List<String> pallet) {
    palletIDLabel.setText(pallet.get(0).replaceFirst("", "PAL").toUpperCase());
    productLabel.setText(pallet.get(5).toUpperCase());
    String station;
    switch (pallet.get(4)) {
      case "1":
        station = Config.ReceivingStation;
        break;
      case "2":
        station = Config.ShippingStation;
        break;
      default:
        if (Integer.parseInt(pallet.get(4)) < 500) {
          station = "SHELF " + pallet.get(4).toUpperCase();
        } else {
          station = "ROBOT " + pallet.get(4);
        }
        break;
    }
    locationLabel.setText(station);
    typeLabel.setText(pallet.get(3).toUpperCase());

    if (pallet.get(3).toUpperCase().equals("NORMAL")) {
      typePane.setStyle("-fx-background-color: #6e7ffb");
    } else {
      typePane.setStyle("-fx-background-color: #82c3fa");
    }
  }
}
