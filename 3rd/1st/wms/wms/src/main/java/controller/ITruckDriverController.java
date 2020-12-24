package controller;

import java.lang.reflect.InvocationTargetException;
import java.security.NoSuchAlgorithmException;

public interface ITruckDriverController {

    void addPallet(String product, Integer quantity, String company, String type)
            throws NoSuchMethodException, IllegalAccessException, InvocationTargetException,
                    NoSuchAlgorithmException;

    void removePallet(String id)
            throws NoSuchMethodException, IllegalAccessException, InvocationTargetException;

    void removeAllPallets()
            throws NoSuchMethodException, IllegalAccessException, InvocationTargetException;

    void getPallets()
            throws NoSuchMethodException, IllegalAccessException, InvocationTargetException;

    void makeEntryRequest()
            throws NoSuchMethodException, IllegalAccessException, InvocationTargetException;
}
