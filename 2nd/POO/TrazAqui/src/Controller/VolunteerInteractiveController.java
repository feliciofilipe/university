package Controller;

import Model.*;
import Model.Exceptions.InvalidIDException;
import View.View;

public class VolunteerInteractiveController extends CarrierInteractiveController implements VolunteerInterface {

    /**
     * Parameterized Constructor
     * @param model Model of the system
     * @param view View of the system
     * @param ID ID of the carrier
     */
    public VolunteerInteractiveController(Model model, View view, String ID) {
        super(model, view, ID);
    }

    /**
     * Function accepts an order
     * @param orderID ID of the order
     * @return String to know if the function was well executed or not
     */
    public String acceptOrder(String orderID){
        return getModel().acceptVolunteerOrder(getID(),orderID);
    }
}
