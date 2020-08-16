package Controller;

import Model.Exceptions.InvalidIDException;
import Model.Record;

import java.util.List;

public interface MedicalSupliesVolunteerInterface {
    String acceptOrder(String orderID);
    List<Record> getRecord();
    String setName(String name);
    String setEmail(String email);
    String setPassword(String password);
    String setX(String x);
    String setY(String y);
    String setRadius(String radius) throws InvalidIDException;
    String getProfile();
}
