package gui_controller;

import javafx.fxml.FXML;
import javafx.fxml.FXMLLoader;

import javafx.scene.Parent;
import javafx.scene.Scene;
import javafx.scene.control.Button;
import javafx.scene.control.Label;
import javafx.scene.layout.Pane;
import javafx.scene.paint.Color;

import javafx.stage.Modality;
import javafx.stage.Stage;
import javafx.stage.StageStyle;

import java.io.IOException;
import java.util.concurrent.atomic.AtomicBoolean;

public class PopUpController {

    @FXML
    public static boolean popup(int type, String error, String message) {
        AtomicBoolean bool = new AtomicBoolean(true);

        Stage window = new Stage();

        window.initModality(Modality.APPLICATION_MODAL);
        window.initStyle(StageStyle.TRANSPARENT);
        window.setX(553);
        window.setY(343);

        if (type == 3) window.setX(645);

        try {
            FXMLLoader loader = new FXMLLoader();
            loader.setLocation(PopUpController.class.getResource("../views/popUp.fxml"));
            Parent layout = loader.load();

            Scene scene = new Scene(layout);
            scene.setFill(Color.TRANSPARENT);

            ((Button) loader.getNamespace().get("okButton")).setOnAction(e -> window.close());
            ((Button) loader.getNamespace().get("okButton")).toFront();
            ((Button) loader.getNamespace().get("yesButton")).toBack();
            ((Button) loader.getNamespace().get("yesButton"))
                    .setOnAction(
                            e -> {
                                window.close();
                                bool.set(true);
                            });
            ((Button) loader.getNamespace().get("noButton")).toBack();
            ((Button) loader.getNamespace().get("noButton"))
                    .setOnAction(
                            e -> {
                                window.close();
                                bool.set(false);
                            });
            ((Label) loader.getNamespace().get("errorLabel")).setText(error);
            ((Label) loader.getNamespace().get("messageLabel")).setText(message);

            switch (type) {
                case 0:
                    ((Pane) loader.getNamespace().get("exclamationPane")).toFront();
                    break;

                case 1:
                    ((Pane) loader.getNamespace().get("informationPane")).toFront();
                    break;

                case 2:
                    ((Pane) loader.getNamespace().get("interrogationPane")).toFront();
                    break;

                case 3:
                    ((Button) loader.getNamespace().get("yesButton")).toFront();
                    ((Button) loader.getNamespace().get("noButton")).toFront();
                    break;

                default:
                    break;
            }

            window.setScene(scene);
            window.showAndWait();

        } catch (IOException e) {
            e.printStackTrace();
        }

        return bool.get();
    }
}
