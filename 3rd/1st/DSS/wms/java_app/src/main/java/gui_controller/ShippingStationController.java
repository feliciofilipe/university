package gui_controller;

import javafx.event.ActionEvent;
import javafx.fxml.FXML;
import javafx.fxml.FXMLLoader;

import javafx.scene.control.RadioButton;
import javafx.scene.layout.HBox;
import javafx.scene.layout.VBox;

import java.io.IOException;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.Iterator;
import java.util.List;
import java.util.stream.Collectors;

public class ShippingStationController extends UserController {

  @FXML private final List<List<String>> list = new ArrayList<>();

  @FXML private VBox vbox1;

  public void populate() {
    changeImage(wms.getPicture());
    changeUserName(wms.getName());
    addOrders(wms.getShippingStationPallets());
  }

  @FXML
  private void addOrders(List<List<String>> list) {
    list.forEach(this::addOrder);
  }

  @FXML
  private void addOrder(List<String> palletsInfo) {

    FXMLLoader fxmlTableLoader = new FXMLLoader();
    fxmlTableLoader.setLocation(getClass().getResource("../views/receivingStationTableRow.fxml"));

    try {
      HBox hbox = fxmlTableLoader.load();
      ReceivingStationTableRowController rstrc = fxmlTableLoader.getController();
      rstrc.setData(palletsInfo);

      RadioButton rb = (RadioButton) (fxmlTableLoader.getNamespace().get("selectButton"));

      list.add(palletsInfo);

      rb.setOnAction(e -> selectButton(rb));

      if (vbox1.getChildren().size() * 59 + 53 > vbox1.getMinHeight()) {
        vbox1.setMinHeight(59 + vbox1.getMinHeight());
      }

      vbox1.getChildren().add(hbox);

    } catch (IOException e) {
      e.printStackTrace();
    }
  }

  @FXML
  private void acceptButtonHandler(ActionEvent event) {
    int index = getButtonIndex(getRadioButtonList());
    vbox1.getChildren().remove(index + 1);
    wms.addLastPallet(
        Arrays.asList(
            list.get(index).get(0),
            list.get(index).get(2),
            list.get(index).get(3),
            list.get(index).get(1),
            "OUT"));
    wms.addWeeklyShipments(-1);
    wms.removePallet(list.get(index).get(0));
    list.remove(index);
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
      radioButtons.stream().filter(r -> !r.equals(rb)).forEach(button -> button.setSelected(false));
    }
  }
}
