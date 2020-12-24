package gui_controller;

import javafx.fxml.FXML;
import javafx.scene.control.Label;
import javafx.scene.image.Image;
import javafx.scene.image.ImageView;

public class UserController extends Controller {

    @FXML private ImageView image;

    @FXML private Label userNameLabel;

    @FXML
    public void changeUserName(String name) {
        userNameLabel.setText(name);
    }

    // Recebe o nome do file.png
    @FXML
    public void changeImage(String imagePath) {
        image.setImage(new Image(getClass().getResourceAsStream("../images/profile/" + imagePath)));
    }
}
