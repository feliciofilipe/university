package gui_controller;

import javafx.fxml.FXMLLoader;

import javafx.scene.Scene;
import javafx.stage.Stage;

import java.io.IOException;

import java.lang.reflect.InvocationTargetException;
import java.util.Map;
import static java.util.Map.entry;

public final class Helper {

    private static Stage stage;

    private final Map<String, String> scenes =
            Map.ofEntries(
                    entry("loginButton", "login.fxml"),
                    entry("signupButton", "signup.fxml"),
                    entry("dashboardButton", "dashboard.fxml"),
                    entry("manageTrucksButton", "manageTrucks.fxml"),
                    entry("manageAccountsButton", "manageAccounts.fxml"),
                    entry("seeLocationsButton", "seeLocations.fxml"),
                    entry("notificationsButton", "notifications.fxml"),
                    entry("adminEditProfileButton", "adminEditProfile.fxml"),
                    entry("receivingStationButton", "receivingStation.fxml"),
                    entry("shippingStationButton", "shippingStation.fxml"),
                    entry("floorWorkerEditProfileButton", "floorWorkerEditProfile.fxml"),
                    entry("entryRequestButton", "entryRequest.fxml"),
                    entry("truckDriverEditProfileButton", "truckDriverEditProfile.fxml"),
                    entry("class model.Admin", "dashboard.fxml"),
                    entry("class model.FloorWorker", "receivingStation.fxml"),
                    entry("class model.TruckDriver", "entryRequest.fxml"));

    public Helper() throws IOException {}

    public static void init(final Stage stage) {
        Helper.stage = stage;
    }

    public void redirectTo(final String pane)
            throws NoSuchMethodException, InvocationTargetException, IllegalAccessException,
                    IOException {
        FXMLLoader loader = new FXMLLoader();
        loader.setLocation(getClass().getResource("../views/" + scenes.get(pane)));
        Scene view = new Scene(loader.load());
        loader.getController().getClass().getMethod("populate").invoke(loader.getController());
        stage.setScene(view);
    }

    public boolean errorPopUp(final int type, final String error_message, final String message) {
        return PopUpController.popup(type, error_message, message);
    }
}
