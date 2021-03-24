package gui_controller;

import javafx.event.ActionEvent;

import javafx.fxml.FXML;
import javafx.fxml.FXMLLoader;
import javafx.scene.Node;
import javafx.scene.control.Button;
import javafx.scene.layout.HBox;
import javafx.scene.layout.VBox;

import java.io.IOException;

import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

public class NotificationsController extends UserController {

  @FXML private VBox vbox;

  private List<String> ids = new ArrayList<>();

  public void populate() {
    changeImage(wms.getPicture());
    changeUserName(wms.getName());
    addNotifications(wms.getNotifications());
  }

  @FXML
  private void addNotifications(Map<String, String> notifications) {
    notifications.forEach(this::addNotification);
  }

  @FXML
  private void addNotification(String id, String notification) {

    FXMLLoader fxmlTableLoader = new FXMLLoader();
    fxmlTableLoader.setLocation(getClass().getResource("../views/notificationsTableRow.fxml"));

    try {
      HBox hbox = fxmlTableLoader.load();
      NotificationsTableRowController ntrc = fxmlTableLoader.getController();

      if (vbox.getChildren().size() * 59 > vbox.getMinHeight()) {
        vbox.setMinHeight(59 + vbox.getMinHeight());
      }

      ((Button) (fxmlTableLoader.getNamespace().get("deleteRowButton")))
          .setOnAction(
              e -> {
                int index = getIndex(hbox);
                vbox.getChildren().remove(hbox);
                wms.removeNotification(ids.get(index));
                ids.remove(index);
              });

      ids.add(id);
      ntrc.setData(notification);
      vbox.getChildren().add(hbox);

    } catch (IOException e) {
      e.printStackTrace();
    }
  }

  @FXML
  public void deleteAllHandler(ActionEvent event) {
    vbox.getChildren().clear();
    ids.forEach(id -> wms.removeNotification(id));
    ids = new ArrayList<>();
  }

  private int getIndex(HBox hbox) {
    int res = 0, i = 0;

    Iterator<Node> it = vbox.getChildren().iterator();
    while (it.hasNext() && res == 0) {
      HBox hb = (HBox) it.next();
      if (hb.equals(hbox)) res = i;
      i++;
    }
    return res;
  }
}
