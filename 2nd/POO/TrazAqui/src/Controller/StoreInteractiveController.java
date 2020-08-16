package Controller;

import Model.*;
import Utilities.Colors;
import View.*;

import java.lang.reflect.Field;
import java.lang.reflect.Method;
import java.util.Arrays;
import java.util.HashMap;
import java.util.Map;
import java.util.Scanner;

public class StoreInteractiveController extends InteractiveController implements StoreInterface {

    /**
     * Parameterized Constructor
     * @param model Model of the system
     * @param view View of the system
     * @param ID ID of the carrier
     */
    public StoreInteractiveController(Model model, View view, String ID){
        super(model,view,ID);
    }

    /**
     * Function that shows the pending orders of a store
     * @return Pending orders of a store
     */
    public Map<String,Map<String,Double>> showPendingOrders(){
        return getModel().getStoreUserRequests(getID());
    }

    /**
     * Function that accept order from a user
     * @param userID user that made the order
     * @return String with the information where the function was successful or not
     * @throws Exception e
     */
    public String acceptOrder(String userID) throws Exception {
        Scanner scanner = new Scanner(System.in);
        if(getModel().userRequestExists(getID(),userID)){
            Map<String,Product> productList = new HashMap<String, Product>();
            Map<String,Map<String,Double>> userRequests = getModel().getStoreUserRequests(getID());
            for(Map.Entry<String,Double> user_request : userRequests.get(userID).entrySet()){
                Product product = getModel().getProductFromCatalog(getID(),user_request.getKey());
                productList.put(product.getProductID(),product);
            }
            getView().showln("Set Order weight");
            getView().prompt(userID, "setWeight");
            Double weight  = scanner.nextDouble();
            Order order = new Order(getModel().generateOrderID(),userID,getID(),weight,productList);
            getModel().addOrder(userID,order);
            getModel().cleanStoreOrder(getID(),userID);
            return "Order completed - waiting for an available carrier";
        }

        else{
            return "User Does Not Exist";
        }
    }

    public Map<String,Product> seeCatalog(){
        return getModel().storeSeeCatalog(getID());
    }

    /**
     * Function that adds a product to the catalog of the store
     * @return String with the information where the function was successful or not
     * @throws Exception e
     */
    public String addProduct() throws Exception {
        Scanner scanner = new Scanner(System.in);
        Product product = new Product();
        getView().showln(Colors.ANSI_CYAN + View.toAnsi("New Product") + Colors.ANSI_RESET);
        Field[] fields = Arrays.stream(Product.class.getDeclaredFields()).filter(s -> !(s.getName().equals("quantity") || s.getName().equals("productID"))).toArray(Field[]::new);
        for (Field field : fields) {
            getView().showln("Set " + field.getName());
            getView().prompt(getID(), "set" + field.getName());
            Method method = Product.class.getDeclaredMethod("set" + field.getName().replace(field.getName().charAt(0), Character.toUpperCase(field.getName().charAt(0))), field.getType());
            Object[] arg = new Object[1];
            arg[0] = parseObjectFromString(scanner.nextLine(), field.getType());
            method.invoke(product, arg);
        }
        return getModel().storeAddProduct(getID(), product);
    }

    /**
     * Remove a product From this Store Catalog
     * @param productID product's IS to be removed
     * @return message
     */
    public String removeProduct(String productID){
        return getModel().removeStoreProduct(getID(),productID);
    }

}
