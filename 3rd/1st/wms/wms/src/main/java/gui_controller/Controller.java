package gui_controller;

import javafx.event.ActionEvent;
import javafx.fxml.FXML;
import javafx.scene.layout.Pane;
import model.FloorWorker;
import model.IWMS;
import model.TruckDriver;
import util.Passwords;

import java.io.IOException;
import java.lang.reflect.InvocationTargetException;

public abstract class Controller {

    protected static IWMS wms;
    protected static Helper helper;

    private final String[] arrayColers;

    {
        arrayColers =
                new String[] {
                    "#1F2940", "#DB1313", "#F2A71D", "#199019", "#3535D8",
                };
    }

    public static void init(final Helper helper, final IWMS wms) {
        Controller.wms = wms;
        Controller.helper = helper;
    }

    // TODO: CUIDADO COM LOGOUT, NAO É APENAS SAIR!!!
    @FXML
    public void changeSceneHandler(final ActionEvent event)
            throws NoSuchMethodException, IllegalAccessException, InvocationTargetException,
                    IOException {
        helper.redirectTo(event.getSource().toString().substring(10).split(",", 2)[0]);
    }

    public String getPath(String id) {
        Class aClass = wms.getClass(id);
        if (FloorWorker.class.equals(aClass)) {
            switch (id) {
                case "paulobarros@gmail.com":
                    return "paulo.png";
                case "rubenadao@gmail.com":
                    return "ruben.png";
                default:
                    return "floorworker.png";
            }
        } else if (TruckDriver.class.equals(aClass)) {
            switch (id) {
                case "felicio@gmail.com":
                    return "filipe.png";
                case "manuelhenrique@gmail.com":
                    return "henrique.png";
                default:
                    return "truckdriver.png";
            }
        } else {
            if (id.equals("laraujo@gmail.com")) return "luis.png";
            else return "admin.png";
        }
    }

    void scoreHandler(
            String password, Pane redPane, Pane orangePane, Pane greenPane, Pane bluePane) {

        Pane[] arrayPanes = new Pane[] {redPane, orangePane, greenPane, bluePane};

        int score = Passwords.score(password);

        int[] array = new int[] {0, 0, 0, 0};

        for (int i = 0; i < 4 && !password.equals(""); i++) {
            if (i <= score) array[i] = 1;
        }

        for (int i = 0; i < 4; i++) {
            if (array[i] == 1)
                arrayPanes[i].setStyle("-fx-background-color: " + arrayColers[i + 1]);
            else {
                arrayPanes[i].setStyle("-fx-background-color: " + arrayColers[0]);
            }
        }
    }
}
