package Controller;

import Model.*;
import Model.Exceptions.InvalidIDException;
import View.View;

import java.util.List;

public class TransporterInteractiveController extends CarrierInteractiveController implements TransporterInterface{

    /**
     * Parameterized Constructor
     * @param model Model of the system
     * @param view View of the system
     * @param ID ID of the carrier
     */
    public TransporterInteractiveController(Model model,View view, String ID){
        super(model,view,ID);
    }

    /**
     * Updates the TIN of a transporter
     * @param tin New tin of a transport
     * @return String to know if the function was well executed or not
     * @throws InvalidIDException
     */
    public String setTIN(String tin) throws InvalidIDException {
        return getModel().setTIN(getID(),tin);
    }

    /**
     * Updates the free of a transporter
     * @param fee New fee of a transporter
     * @return String to know if the function was well executed or not
     */
    public String setFee(String fee){
        return getModel().setFee(getID(),fee);
    }

    /**
     * Updates the maxOrders of a transporter
     * @param maxOrders New maxOrders of a transporter
     * @return String to know if the function was well executed or not
     */
    public String setMaxOrders(String maxOrders){
        return getModel().setMaxOrders(getID(),maxOrders);
    }

    /**
     * Function that allow the transporter to make a offer to a order
     * @param orderID ID of the order
     * @return String to know if the function was well executed or not
     */
    public String makeOfferOnOrder(String orderID){
        return getModel().makeOfferOnOrderTransporter(getID(),orderID);
    }
}
