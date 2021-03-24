package model;

import exceptions.AuthenticationException;
import javafx.util.Pair;

import java.lang.reflect.InvocationTargetException;
import java.security.NoSuchAlgorithmException;
import java.util.List;
import java.util.Map;

public interface IWMS {

  String getId();

  void setId(String id);

  String getName();

  void setName(String name);

  String getPicture();

  void setPicture(String picture);

  void authenticate(String id, String password) throws AuthenticationException;

  User getUser(String id);

  int getNumberOf(Class clazz);

  void addUser(Class clazz, String[] input, Class[] classes)
      throws NoSuchMethodException, InstantiationException, IllegalAccessException,
          InvocationTargetException, AuthenticationException;

  void removeUser(String id);

  void acceptUser(String id)
      throws NoSuchMethodException, InstantiationException, IllegalAccessException,
          InvocationTargetException;

  Class getClass(String id);

  String getUserName(String id);

  String generatePalletID() throws NoSuchAlgorithmException;

  void addUserPallet(
      String truckID,
      String palletID,
      String product,
      Integer quantity,
      String company,
      String type)
      throws NoSuchMethodException, IllegalAccessException, InvocationTargetException;

  void removeUserPallet(String truckID, String palletID)
      throws NoSuchMethodException, InvocationTargetException, IllegalAccessException;

  void removeAllUserPallets(String id)
      throws NoSuchMethodException, IllegalAccessException, InvocationTargetException;

  Map<String, Pallet> getUserPallets(String id)
      throws NoSuchMethodException, IllegalAccessException, InvocationTargetException;

  List<List<String>> getPendingUsers();

  void makeEntryRequest(String id)
      throws NoSuchMethodException, IllegalAccessException, InvocationTargetException;

  List<Pair<List<String>, List<List<String>>>> getEntryRequests();

  void acceptEntryRequest(String id);

  void denyEntryRequest(String id);

  List<List<String>> getPalletsLocations();

  int getWarehouseCapacity();

  int getNumberOfPallets();

  List<List<String>> getReceivingStationPallets();

  List<List<String>> getShippingStationPallets();

  void removePallet(String id);

  void changeStatus(String palletID);

  void createNewJob(String pallet, String station);

  void assignJobs();

  void robotNotifiesPickUp(String RobotId, String idJob);

  void robotNotifiesDelivery(String RobotId, String idJob);

  Map<String, String> getNotifications();

  void deleteAllNotifications();

  void removeNotification(String s);

  String chooseShelf(String palletID);

  List<List<String>> getLastPallet();

  void addLastPallet(List<String> lastPallet);

  void addWeeklyShipments(int v);

  List<Integer> getWeeklyShipments();

  String helloWorld();
}
