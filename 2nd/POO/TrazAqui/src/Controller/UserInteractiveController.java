package Controller;

import Model.Model;

import Model.*;
import Utilities.Colors;
import View.*;

import java.util.*;
import java.util.stream.Collectors;
import java.util.Map;


public class UserInteractiveController extends InteractiveController implements UserInterface {

    public void run(){}

    /**
     * Parameterized Constructor
     * @param model Model of the system
     * @param view View of the system
     * @param ID ID of the carrier
     */
    public UserInteractiveController(Model model,View view,String ID){
        super(model,view,ID);
    }

    /**
     * Function that allows a user to make an order
     * @return String with the information where the function was successful or not
     */
    public String makeOrder(){
        try {
            getModel().userMakeOrder(getID());
            return "Order made with success, pending Store approval";
        }catch (Exception e){
            return "";
        }
    }

    /**
     * Function that allows the user to change the store that he is going to buy at
     * @param storeID ID of the store
     * @return String with the information where the function was successful or not
     */
    public String setStoreID(String storeID){
        try {
            this.getModel().setUserStoreID(getID(),storeID);
            return "Store set to ID: " + storeID + " - " + this.getModel().getEntitie(storeID).getName();
        }catch (Exception e){
            return "This Store does not exist";
        }
    }

    /**
     * Function that gets the catalog of a store
     * @return Catalog of a sotre
     */
    public Map<String,Product> seeStoreCatalog(){
        return getModel().userSeeStoreCatalog(getID());
    }

    /**
     * Function that sets the type of delivery that the user wants
     * @return String with the information where the function was successful or not
     * @throws ClassNotFoundException e
     */
    public String setTypeOfDeliver() throws ClassNotFoundException {
            Scanner scanner = new Scanner(System.in);
            List<String> aux = Controller.getClasses("src/Model");
            List<String> classesNames = aux.stream().map(n -> n.replace("src/","").replace("/",".").replace(".java","")).collect(Collectors.toList());
            List<Object> list = new ArrayList<>();
            for (int i = 0; i < classesNames.size(); i++)
                if (isSubclass(classesNames.get(i),Carrier.class))
                    list.add(Class.forName(classesNames.get(i)));
            getView().showln(Colors.ANSI_CYAN + View.toAnsi("Set Deliver") + Colors.ANSI_RESET);
            getView().showln("Carrier Options:");
            list.stream().forEach(l -> getView().showln(l.toString().replace("class Model.","")));
            getView().prompt(getID(), "setTypeOfOrder");
            String carrier = scanner.nextLine();
            try {
                Class.forName("Model." + carrier);
                getModel().setTypeOfOrder(getID(), carrier);
                return "Carrier set to: " + carrier;
            }catch(ClassNotFoundException e){
                return "Invalid Carrier";
            }
    }

    private boolean isSubclass(String subClass,Class clazz){
        try {
            return clazz.isAssignableFrom(Class.forName(subClass));
        } catch (ClassNotFoundException e) {
            e.printStackTrace();
        }
        return false;
    }

    /**
     * Function to add products to the cart of the user
     * @param productID Product ID to be added
     * @param quantity Quantity of the product
     * @return String with the information where the function was successful or not
     */
    public String addProductToCart(String productID,Double quantity){
       return this.getModel().addToUserCart(getID(),productID,quantity);
    }

    /**
     * Function that gets the current cart of the user
     * @return Cart of the user
     */
    public Map<String,Double> seeCart(){
        return getModel().getUserCart(getID());
    }

    /**
     * Function that gets the transporters offers
     * @return Transporters offers
     */
    public String seeTransportOffers(){
        return getModel().getUserTransportOffers(getID());
    }

    /**
     * Function that allow the user to accept an offer from a transporter
     * @param orderID Order to be accepted
     * @param transporterID Transported ID
     * @return String with the information where the function was successful or not
     */
    public String acceptTransportOfferOnOrder(String orderID,String transporterID){
        return getModel().acceptUserTransportOfferOnOrder(getID(),orderID,transporterID);
    }

    /**
     * Function the get all the orders that needs a rating from the user
     * @return List of orders that are waiting of a rating
     */
    public Set<String> seeOrdersNeedingRating(){
        return getModel().seeUserOrdersNeedingRating(getID());
    }

    /**
     * Function that allow the user to rate a order
     * @param orderID Order to be rated
     * @param rating Rating of the Order
     * @return String with the information where the function was successful or not
     */
    public String rateOrder(String orderID, Double rating){
        return getModel().userRatesOrder(getID(),orderID,rating);
    }

}
