package model;

import database.PalletDAO;
import database.StationDAO;
import javafx.util.Pair;

import java.security.NoSuchAlgorithmException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Random;

public class SMS implements ISMS {

  private StationDAO stationDAO;
  private PalletDAO palletDAO;

  public SMS() {
    this.stationDAO = new StationDAO();
    this.palletDAO = new PalletDAO();
  }

  public StationDAO getStationDAO() {
    return stationDAO;
  }

  public void setStationDAO(StationDAO stationDAO) {
    this.stationDAO = stationDAO;
  }

  public PalletDAO getPalletDAO() {
    return palletDAO;
  }

  public void setPalletDAO(PalletDAO palletDAO) {
    this.palletDAO = palletDAO;
  }

  @Override
  public String generatePalletID() throws NoSuchAlgorithmException {
    return String.valueOf(this.palletDAO.size()) + (int) (Math.random() * 50000 + 1);
  }

  @Override
  public void dropPalletsReceivingStation(Map<String, Pallet> pallets) {
    //    pallets.forEach((k, v) -> receivingStation.takePallet(k, v /*.clone*/)); // TODO;
  }

  @Override
  public Map<String, Pair<List<String>, String>> getPalletsLocations() {
    return this.palletDAO.getPalletsLocations();
  }

  @Override
  public int getWarehouseCapacity() {
    return stationDAO.getWarehouseCapacity();
  }

  @Override
  public int getNumberOfPallets() {
    return palletDAO.size();
  }

  @Override
  public Map<String, Pair<Pallet, String>> getPallets(Class clazz) {
    if (ReceivingStation.class.equals(clazz)) {
      return this.palletDAO.getPalletsFrom(1);
    } else if (ShippingStation.class.equals(clazz)) {
      return this.palletDAO.getPalletsFrom(2);
    }
    return new HashMap();
  }

  public String chooseShelf(String palletID) {
    Random randomizer = new Random();
    List<String> list = stationDAO.getShelfs();
    return list.get(randomizer.nextInt(list.size()));
  }
}
