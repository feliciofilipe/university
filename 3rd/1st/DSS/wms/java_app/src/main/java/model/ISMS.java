package model;

import database.PalletDAO;
import database.StationDAO;
import javafx.util.Pair;

import java.security.NoSuchAlgorithmException;
import java.util.List;
import java.util.Map;

public interface ISMS {

  StationDAO getStationDAO();

  void setStationDAO(StationDAO stationDAO);

  PalletDAO getPalletDAO();

  void setPalletDAO(PalletDAO palletDAO);

  String generatePalletID() throws NoSuchAlgorithmException;

  void dropPalletsReceivingStation(Map<String, Pallet> pallets);

  Map<String, Pair<List<String>, String>> getPalletsLocations();

  int getWarehouseCapacity();

  int getNumberOfPallets();

  Map<String, Pair<Pallet, String>> getPallets(Class clazz);

  String chooseShelf(String palletID);
}
