package model;

import database.PalletDAO;
import database.StationDAO;
import javafx.util.Pair;
import util.Passwords;

import java.security.NoSuchAlgorithmException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class SMS implements ISMS {

    private StationDAO stationDAO;
    PalletDAO palletDAO;

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
        return String.valueOf(this.palletDAO.size()) + (int)(Math.random() * 50000 + 1);
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
        return 0;
    }

    @Override
    public int getNumberOfPallets() {
        return 0;
    }

    @Override
    public Map<String, Pallet> getPallets(Class clazz) {
        if (ReceivingStation.class.equals(clazz)) {
            //    return this.receivingStation.getPallets();
        } else if (ShippingStation.class.equals(clazz)) {
            //    return this.shippingStation.getPallets();
        }
        return new HashMap();
    }
}
