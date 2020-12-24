package model;

import database.*;
import exceptions.AuthenticationException;
import javafx.util.Pair;

import java.lang.reflect.InvocationTargetException;
import java.security.NoSuchAlgorithmException;
import java.util.*;
import java.util.stream.Collectors;

public class WMS implements IWMS {

    private String id;
    private String name;
    private String picture;

    private IUMS ums;
    private ISMS sms;
    private IRMS rms;

    private PalletDAO palletDAO;

    public WMS() {
        this.ums = new UMS();
        this.sms = new SMS();
        this.rms = new RMS();
        this.palletDAO = new PalletDAO();
    }

    @Override
    public String getId() {
        return id;
    }

    @Override
    public void setId(String id) {
        this.id = id;
    }

    @Override
    public String getName() {
        return name;
    }

    @Override
    public void setName(String name) {
        this.name = name;
    }

    @Override
    public String getPicture() {
        return picture;
    }

    @Override
    public void setPicture(String picture) {
        this.picture = picture;
    }

    @Override
    public void authenticate(String id, String password) throws AuthenticationException {
        this.ums.authenticate(id, password);
    }

    @Override
    public User getUser(String id) {
        return this.ums.getUser(id);
    }

    @Override
    public int getNumberOf(Class clazz) {
        if (clazz.equals(Robot.class)) return this.rms.getNumberOfRobots();
        else return this.ums.getNumberOf(clazz);
    }

    @Override
    public void addUser(Class clazz, String[] input, Class[] classes)
            throws NoSuchMethodException, InstantiationException, IllegalAccessException,
                    InvocationTargetException, AuthenticationException {
        this.ums.addUser(clazz, input, classes);
    }

    @Override
    public void removeUser(String id) {
        this.ums.removeUser(id);
    }

    @Override
    public void acceptUser(String id)
            throws InvocationTargetException, NoSuchMethodException, InstantiationException,
                    IllegalAccessException {
        this.ums.acceptUser(id);
    }

    @Override
    public Class getClass(String id) {
        return this.ums.getClass(id);
    }

    @Override
    public String getUserName(String id) {
        return this.ums.getUserName(id);
    }

    @Override
    public String generatePalletID() throws NoSuchAlgorithmException {
        return this.sms.generatePalletID();
    }

    @Override
    public void addUserPallet(
            String truckID,
            String palletID,
            String product,
            Integer quantity,
            String company,
            String type)
            throws NoSuchMethodException, IllegalAccessException, InvocationTargetException {
        this.ums.addPallet(
                truckID, palletID, new Pallet(palletID, product, quantity, company, type));
    }

    @Override
    public void removeUserPallet(String truckID, String palletID)
            throws NoSuchMethodException, IllegalAccessException, InvocationTargetException {
        this.ums.removePallet(truckID, palletID);
    }

    @Override
    public void removeAllUserPallets(String id)
            throws NoSuchMethodException, IllegalAccessException, InvocationTargetException {
        this.ums.removeAllPallets(id);
    }

    @Override
    public Map<String, Pallet> getUserPallets(String id)
            throws NoSuchMethodException, IllegalAccessException, InvocationTargetException {
        return this.ums.getPallets(id);
    }

    @Override
    public List<List<String>> getPendingUsers() {
        return this.ums.getPendingUsers();
    }

    @Override
    public void makeEntryRequest(String id)
            throws NoSuchMethodException, IllegalAccessException, InvocationTargetException {
        this.ums.makeEntryRequest(id);
    }

    @Override
    public List getEntryRequests() {
        return this.ums.getEntryRequests().entrySet().stream()
                .map(
                        entry ->
                                new Pair(
                                        Arrays.asList(
                                                entry.getKey(),
                                                this.getUser(entry.getKey()).getFirstName(),
                                                this.getUser(entry.getKey()).getLastName()),
                                        entry.getValue().entrySet().stream()
                                                .map(
                                                        entry2 ->
                                                                Arrays.asList(
                                                                        entry2.getKey(),
                                                                        entry2.getValue()
                                                                                .getProduct(),
                                                                        String.valueOf(
                                                                                entry2.getValue()
                                                                                        .getQuantity()),
                                                                        entry2.getValue()
                                                                                .getCompany(),
                                                                        entry2.getValue()
                                                                                .getType()))
                                                .collect(Collectors.toList())))
                .collect(Collectors.toList());
    }

    @Override
    public void acceptEntryRequest(String id) {
        this.ums
                .getEntryRequests()
                .get(id)
                .values()
                .forEach(
                        entry ->
                                this.sms
                                        .getPalletDAO()
                                        .put(
                                                entry.getId(),
                                                new Pallet(
                                                        entry.getId(),
                                                        entry.getProduct(),
                                                        entry.getQuantity(),
                                                        entry.getCompany(),
                                                        entry.getType()),
                                                "1"));
        this.ums.denyEntryRequest(id);
    }

    @Override
    public void denyEntryRequest(String id) {
        this.ums.denyEntryRequest(id);
    }

    @Override
    public List<List<String>> getPalletsLocations() {
        Map<String, Pair<List<String>, String>> m4p = this.sms.getPalletsLocations();
        return m4p.entrySet().stream()
                .map(
                        entry ->
                                Arrays.asList(
                                        entry.getKey(),
                                        entry.getValue().getKey().get(0),
                                        entry.getValue().getKey().get(1),
                                        entry.getValue().getKey().get(2),
                                        entry.getValue().getKey().get(3),
                                        entry.getValue().getValue()))
                .collect(Collectors.toList());
    }

    @Override
    public int getWarehouseCapacity() {
        return this.sms.getWarehouseCapacity();
    }

    @Override
    public int getNumberOfPallets() {
        return this.sms.getNumberOfPallets();
    }

    @Override
    public List<List<String>> getReceivingStationPallets() {
        return this.sms.getPallets(ReceivingStation.class).entrySet().stream()
                .map(
                        entry ->
                                Arrays.asList(
                                        entry.getKey(),
                                        entry.getValue().getProduct(),
                                        String.valueOf(entry.getValue().getQuantity()),
                                        entry.getValue().getCompany(),
                                        entry.getValue().getType()))
                .collect(Collectors.toList());
    }

    @Override
    public Map<String, String> getNotifications() {
        return this.rms.getNotifications();
    }

    @Override
    public void createNewJob(String pallet, String station) {
        this.rms.getJobDAO().createNewJob(pallet, station);
    }

    @Override
    public void assignJobs() {
        this.rms.assignJobs(this.sms.getStationDAO());
    }

    @Override
    public void robotNotifiesPickUp(String robotId, String idJob) {
        Pair<Integer, Integer> coords = this.rms.getJobDAO().getFirstPosition(idJob);
        this.rms.getRobotDAO().changeRobotCoords(robotId, coords.getKey(), coords.getValue());
        String idPallet = this.rms.getJobDAO().getPallet(idJob);
        this.palletDAO.changePalletStation(idPallet, robotId);
    }

    @Override
    public void robotNotifiesDelivery(String RobotId, String idJob) {
        Pair<Integer, Integer> coords = this.rms.getJobDAO().getSecondPosition(idJob);
        this.rms.getRobotDAO().changeRobotCoords(RobotId, coords.getKey(), coords.getValue());
        String idPallet = this.rms.getJobDAO().getPallet(idJob);
        String idStation = this.rms.getJobDAO().getStation(idJob);
        this.palletDAO.changePalletStation(idPallet, idStation);
        this.rms.getRobotDAO().changeRobotStatus(RobotId, "AVAILABLE");
        this.rms.getJobDAO().changeJobStatus(idJob, "COMPLETED");
    }

    @Override
    public void deleteAllNotifications() {
        this.rms.deleteAllNotifications();
    }

    @Override
    public void removeNotification(String s) {
        this.rms.removeNotification(s);
    }
}
