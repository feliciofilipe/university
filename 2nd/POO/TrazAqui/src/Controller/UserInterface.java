package Controller;

import Model.Product;
import Model.Record;

import java.util.List;
import java.util.Map;
import java.util.Set;

public interface UserInterface {
    Map<String, Product> seeStoreCatalog();
    List<Record> getRecord();
    Set<String> seeOrdersNeedingRating();
    String seeTransportOffers();
    List<String> getStoreList();
    String acceptTransportOfferOnOrder(String transporterID,String orderID);
    String rateOrder(String orderID, Double rating);
    String setStoreID(String storeID);
    String addProductToCart(String description,Double quantity);
    String makeOrder();
    Map<String,Double> seeCart();
    String setTypeOfDeliver() throws ClassNotFoundException;
    String setName(String name);
    String setEmail(String email);
    String setPassword(String password);
    String setX(String x);
    String setY(String y);
    String getProfile();
}
