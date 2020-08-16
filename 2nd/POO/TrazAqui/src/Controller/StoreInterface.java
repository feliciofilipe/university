package Controller;

import Model.Product;
import Model.Record;

import java.util.List;
import java.util.Map;

public interface StoreInterface {
    List<Record> getRecord();
    Map<String,Map<String,Double>> showPendingOrders();
    List<String> getStoreList();
    String acceptOrder(String user) throws Exception;
    String setName(String ID);
    String setEmail(String ID);
    String setPassword(String ID);
    String setX(String ID);
    String setY(String ID);
    String getProfile();
    String addProduct() throws Exception;
    String removeProduct(String productID);
    Map<String, Product> seeCatalog();
}