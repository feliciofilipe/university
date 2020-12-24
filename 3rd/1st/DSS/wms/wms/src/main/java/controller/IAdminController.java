package controller;

import java.lang.reflect.InvocationTargetException;
import java.util.Map;

public interface IAdminController {

    void getPendingUsers();

    void acceptUser(String id)
            throws InvocationTargetException, NoSuchMethodException, InstantiationException,
                    IllegalAccessException;

    void denyUser(String id);

    void getEntryRequests();

    void acceptEntryRequest(String id);

    void denyEntryRequest(String id);

    void getPalletsLocations();

    void getNumberOf(String clazz) throws ClassNotFoundException;

    void getWarehouseCapacity();

    void getNumberOfPallets();

    void assignJobs();

    void getNotifications();

    void deleteAllNotifications();

    void removeNotification(String s);
}
