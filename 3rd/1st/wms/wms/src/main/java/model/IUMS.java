package model;

import exceptions.AuthenticationException;

import java.lang.reflect.InvocationTargetException;
import java.util.List;
import java.util.Map;

public interface IUMS {

    void authenticate(String id, String password) throws AuthenticationException;

    User getUser(String id);

    int getNumberOf(Class clazz);

    String getUserName(String id);

    void addUser(Class clazz, String[] input, Class[] classes)
            throws NoSuchMethodException, InstantiationException, IllegalAccessException,
                    InvocationTargetException, AuthenticationException;

    void acceptUser(String id)
            throws NoSuchMethodException, InstantiationException, IllegalAccessException,
                    InvocationTargetException;

    void removeUser(String id);

    Class getClass(String id);

    void addPallet(String truckID, String palletID, Pallet pallet)
            throws NoSuchMethodException, InvocationTargetException, IllegalAccessException;

    void removePallet(String truckID, String palletID)
            throws NoSuchMethodException, InvocationTargetException, IllegalAccessException;

    void removeAllPallets(String id)
            throws NoSuchMethodException, InvocationTargetException, IllegalAccessException;

    Map<String, Pallet> getPallets(String id)
            throws NoSuchMethodException, InvocationTargetException, IllegalAccessException;

    List<List<String>> getPendingUsers();

    void makeEntryRequest(String id)
            throws NoSuchMethodException, IllegalAccessException, InvocationTargetException;

    Map<String, Map<String, Pallet>> getEntryRequests();

    void denyEntryRequest(String id);
}
