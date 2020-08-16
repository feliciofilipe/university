package Controller;

import Model.Exceptions.InvalidIDException;
import Model.Model;
import View.View;

public abstract class CarrierInteractiveController extends InteractiveController{

    /**
     * Parameterized Constructor
     * @param model Model of the system
     * @param view View of the system
     * @param ID ID of the carrier
     */
    public CarrierInteractiveController(Model model, View view, String ID){
        super(model,view,ID);
    }

    /**
     * Function that gets the possible orders in a string
     * @return String of the possible orders
     */
    public String getPossibleOrders(){
        return getModel().getPossibleOrders(getID()).toString();
    }

    /**
     * Function that allows the carrier to change his radius
     * @param radius Radius
     * @return String to know if the function was well executed or not
     * @throws InvalidIDException e
     */
    public String setRadius(String radius) throws InvalidIDException {
        try {
            if (!radius.equals("")) {
                getModel().setRadius(getID(), radius);
                return "Radius Correctly Set";
            }
            else return "Error Setting Radius";
        }
        catch(Exception e){
            return "Error setting radius";
        }
    }
}
