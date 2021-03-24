package gui_controller;

import javafx.fxml.FXML;

import javafx.scene.control.Label;
import javafx.scene.layout.Pane;
import util.Config;

import java.util.List;

public class DashboardTableRowController {
  @FXML private Label productLabel;

  @FXML private Label quatityLabel;

  @FXML private Label typeLabel;

  @FXML private Pane typePane;

  @FXML private Label companyLabel;

  public void setData(List<String> pallet) {
    productLabel.setText(pallet.get(3).toUpperCase());
    quatityLabel.setText(pallet.get(1).toUpperCase());
    companyLabel.setText(pallet.get(2).toUpperCase());
    typeLabel.setText(pallet.get(4).toUpperCase());

    if (pallet.get(4).equals("IN")) {
      typePane.setStyle(Config.green);
    } else {
      typePane.setStyle(Config.red);
    }
  }
}
