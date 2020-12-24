/*
import controller.Controller;
import model.Admin;
import model.IWMS;
import model.TruckDriver;
import model.WMS;
import util.Passwords;

import java.io.IOException;
import java.lang.reflect.InvocationTargetException;
import java.security.NoSuchAlgorithmException;

public class App {
    public static void main(String[] args)
            throws IOException, NoSuchAlgorithmException, InvocationTargetException,
                    NoSuchMethodException, InstantiationException, IllegalAccessException,
                    ClassNotFoundException {
        IWMS wms = new WMS();
        String salt = Passwords.getSalt();
        String[] input_admin = {
            "felicio", "Filipe", "Felicio", salt, Passwords.getEncryptedPassword("pass", salt)
        };
        Class[] classes_admin = {
            String.class, String.class, String.class, String.class, String.class
        };
        String[] input_admin2 = {
            "georgina", "Filipe", "Felicio", salt, Passwords.getEncryptedPassword("pass", salt)
        };
        wms.addUser(Admin.class, input_admin, classes_admin);
        wms.addUser(TruckDriver.class, input_admin2, classes_admin);
        wms.acceptUser("felicio");
        wms.acceptUser("georgina");
        Controller controller = new Controller(wms);
        controller.run();
    }
}

*/
import exceptions.AuthenticationException;
import gui_controller.*;

import javafx.application.Application;
import javafx.scene.text.Font;
import javafx.stage.Stage;

import model.*;

import java.io.IOException;
import java.lang.reflect.InvocationTargetException;
import java.security.NoSuchAlgorithmException;

public final class App extends Application {
    private Helper helper;
    private IWMS wms;

    public App() throws Exception {
        this.helper = new Helper();
        this.wms = new WMS();
    }

    @Override
    public void init() throws Exception {
        super.init();
        Login.init(this.helper, this.wms);
        Signup.init(this.helper, this.wms);
        DashboardController.init(this.helper, this.wms);
        ManageTrucksController.init(this.helper, this.wms);
        ManageAccountsController.init(this.helper, this.wms);
        SeeLocationsController.init(this.helper, this.wms);
        NotificationsController.init(this.helper, this.wms);
        ReceivingStationController.init(this.helper, this.wms);
        EntryRequestController.init(this.helper, this.wms);
        AdminEditProfileController.init(this.helper, this.wms);
        FloorWorkerEditProfileController.init(this.helper, this.wms);
        TruckDriverEditProfileController.init(this.helper, this.wms);
    }

    @SuppressWarnings("checkstyle:FinalParameters")
    public void start(Stage stage) throws Exception {
        Font.loadFont(getClass().getResourceAsStream("fonts/Montserrat/Montserrat-Bold.ttf"), 14);
        Font.loadFont(
                getClass().getResourceAsStream("fonts/Montserrat/Montserrat-Regular.ttf"), 14);
        Helper.init(stage);
        stage.setTitle("Warehouse Management System");
        // stage.getIcons().add(new Image(App.class.getResourceAsStream("images/icon.png")));
        stage.setResizable(false);
        // stage.initStyle(StageStyle.UNDECORATED);
        this.helper.redirectTo("loginButton");
        stage.show();
    }

    @Override
    public void stop() throws Exception {
        super.stop();
    }

    @SuppressWarnings("checkstyle:FinalParameters")
    public static void main(final String[] args) {
        Thread t =
                new Thread(
                        () -> {
                            launch(args);
                        });
        t.start();
        try {
            Shell.main(null);
        } catch (IOException | NoSuchAlgorithmException | InvocationTargetException | NoSuchMethodException | InstantiationException | IllegalAccessException | ClassNotFoundException | AuthenticationException e) {
            e.printStackTrace();
        }
    }
}
