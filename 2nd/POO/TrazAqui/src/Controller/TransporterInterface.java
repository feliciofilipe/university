package Controller;

import Model.Carrier;
import Model.Exceptions.InvalidIDException;
import Model.Order;
import Model.Record;

import java.util.List;

public interface TransporterInterface {
    List<Record> getRecord();
    String getPossibleOrders();
    String makeOfferOnOrder(String orderID);
    String setTIN(String tin) throws InvalidIDException;
    String setFee(String fee) throws InvalidIDException;
    String setMaxOrders(String maxOrders) throws InvalidIDException;
    String setName(String name);
    String setEmail(String email);
    String setPassword(String password);
    String setX(String x);
    String setY(String y);
    String setRadius(String radius) throws InvalidIDException;
    String getProfile();
}
