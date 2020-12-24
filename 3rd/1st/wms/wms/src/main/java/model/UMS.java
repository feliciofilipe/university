package model;

import database.AdminDAO;
import database.EntryRequestDAO;
import database.FloorWorkerDAO;
import database.TruckDriverDAO;
import exceptions.AuthenticationException;
import util.Tools;

import java.lang.reflect.InvocationTargetException;
import java.util.*;

public class UMS implements IUMS {

    private Map<String, Admin> admins;
    private Map<String, FloorWorker> floorWorkers;
    private Map<String, TruckDriver> truckDrivers;
    private Map<String, EntryRequest> entryRequests;
    private Map<String, Truck> trucks;

    public UMS() {
        this.admins = new AdminDAO();
        this.floorWorkers = new FloorWorkerDAO();
        this.truckDrivers = new TruckDriverDAO();
        this.entryRequests = new EntryRequestDAO();
        this.trucks = new HashMap<>();
    }

    @Override
    public void authenticate(String id, String password) throws AuthenticationException {
        if (!this.admins.containsKey(id)
                || !this.admins.get(id).getActive()
                || !this.admins.get(id).authenticate(password)) {
            this.trucks.put(id, new Truck("truck", 0, 0, 100));
            if (!this.truckDrivers.containsKey(id)
                    || !this.truckDrivers.get(id).getActive()
                    || !this.truckDrivers.get(id).authenticate(password)) {
                this.trucks.remove(id);
                if (!this.floorWorkers.containsKey(id)
                        || !this.floorWorkers.get(id).getActive()
                        || !this.floorWorkers.get(id).authenticate(password)) {
                    throw new AuthenticationException("Invalid Credentials");
                }
            }
        }
    }

    @Override
    public User getUser(String id) {
        if (this.admins.containsKey(id)) {
            return this.admins.get(id);
        } else if (this.truckDrivers.containsKey(id)) {
            return this.truckDrivers.get(id);
        } else if (this.floorWorkers.containsKey(id)) {
            return this.floorWorkers.get(id);
        } else return null;
    }

    public Map getDAO(String id) {
        if (this.admins.containsKey(id)) {
            return this.admins;
        } else if (this.truckDrivers.containsKey(id)) {
            return this.truckDrivers;
        } else if (this.floorWorkers.containsKey(id)) {
            return this.floorWorkers;
        } else return new HashMap();
    }

    public Map getDAO(Class clazz) {
        if (clazz.equals(Admin.class)) {
            return this.admins;
        } else if (clazz.equals(TruckDriver.class)) {
            return this.truckDrivers;
        } else if (clazz.equals(FloorWorker.class)) {
            return this.floorWorkers;
        } else return new HashMap();
    }

    @Override
    public String getUserName(String id) {
        return getUser(id).getFirstName() + " " + getUser(id).getLastName();
    }

    @Override
    public int getNumberOf(Class clazz) {
        if (clazz.equals(Admin.class)) {
            return (int) this.admins.values().stream().filter(User::getActive).count();
        } else if (clazz.equals(FloorWorker.class)) {
            return (int) this.floorWorkers.values().stream().filter(User::getActive).count();
        } else if (clazz.equals(TruckDriver.class)) {
            return (int) this.truckDrivers.values().stream().filter(User::getActive).count();
        }
        return 0;
    }

    @Override
    public void addUser(Class clazz, String[] input, Class[] classes)
            throws NoSuchMethodException, IllegalAccessException, InvocationTargetException,
                    InstantiationException, AuthenticationException {
        if (!admins.containsKey(input[0])
                && !floorWorkers.containsKey(input[0])
                && !truckDrivers.containsKey(input[0])
                && Arrays.stream(input).noneMatch(inpt -> inpt.equals("")))
            getDAO(clazz)
                    .put(
                            input[0],
                            clazz.getConstructor(classes)
                                    .newInstance(Tools.argsGenerator(input, classes)));
        else {
            throw new AuthenticationException("error");
        }
    }

    @Override
    public void acceptUser(String id) {
        this.getDAO(id).put(id, getUser(id).setActiveAndReturnUser(true));
    }

    @Override
    public void removeUser(String id) {
        this.getDAO(id).remove(id);
    }

    public Map<String, Admin> getAdmins() {
        Map<String, Admin> admins = new HashMap<>();
        this.admins.forEach((k, v) -> admins.put(k, v)); // TODO Clone
        return admins;
    }

    public void setAdmins(Map<String, Admin> admins) {
        this.admins = new HashMap<>();
        admins.forEach(this.admins::put);
    }

    public Map<String, FloorWorker> getFloorWorkers() {
        Map<String, FloorWorker> floorWorkers = new HashMap<>();
        this.floorWorkers.forEach((k, v) -> floorWorkers.put(k, v)); // TODO Clone
        return floorWorkers;
    }

    public void setFloorWorkers(Map<String, FloorWorker> floorWorkers) {
        this.floorWorkers = new HashMap<>();
        floorWorkers.forEach(this.floorWorkers::put);
    }

    public Map<String, TruckDriver> getTruckDrivers() {
        Map<String, TruckDriver> truckDrivers = new HashMap<>();
        this.truckDrivers.forEach((k, v) -> truckDrivers.put(k, v)); // TODO Clone
        return truckDrivers;
    }

    public void setTruckDrivers(Map<String, TruckDriver> truckDrivers) {
        this.truckDrivers = new HashMap<>();
        truckDrivers.forEach(this.truckDrivers::put);
    }

    @Override
    public Class getClass(String id) {
        if (this.admins.containsKey(id)) {
            return Admin.class;
        } else if (this.truckDrivers.containsKey(id)) {
            return TruckDriver.class;
        } else if (this.floorWorkers.containsKey(id)) {
            return FloorWorker.class;
        } else return null;
    }

    @Override
    public void addPallet(String truckID, String palletID, Pallet pallet) {
        this.trucks.get(truckID).takePallet(palletID, pallet);
    }

    @Override
    public void removePallet(String truckID, String palletID) {
        this.trucks.get(truckID).removePallet(palletID);
    }

    @Override
    public void removeAllPallets(String id) {
        this.trucks.get(id).removeAllPallets();
    }

    @Override
    public Map<String, Pallet> getPallets(String id)
            throws NoSuchMethodException, InvocationTargetException, IllegalAccessException {
        return this.trucks.get(id).getPallets();
    }

    @Override
    public List<List<String>> getPendingUsers() {
        List<List<String>> res = new ArrayList<>();
        this.admins.values().stream()
                .filter(t -> !t.getActive())
                .forEach(
                        v ->
                                res.add(
                                        Arrays.asList(
                                                v.getId(),
                                                v.getFirstName(),
                                                v.getLastName(),
                                                "",
                                                "",
                                                v.getClass().getSimpleName())));
        this.floorWorkers.values().stream()
                .filter(t -> !t.getActive())
                .forEach(
                        v ->
                                res.add(
                                        Arrays.asList(
                                                v.getId(),
                                                v.getFirstName(),
                                                v.getLastName(),
                                                "",
                                                "",
                                                v.getClass().getSimpleName())));
        this.truckDrivers.values().stream()
                .filter(t -> !t.getActive())
                .forEach(
                        v ->
                                res.add(
                                        Arrays.asList(
                                                v.getId(),
                                                v.getFirstName(),
                                                v.getLastName(),
                                                "",
                                                "",
                                                v.getClass().getSimpleName())));
        return res;
    }

    @Override
    public void makeEntryRequest(String id)
            throws NoSuchMethodException, IllegalAccessException, InvocationTargetException {
        this.getPallets(id)
                .values()
                .forEach(
                        pallet ->
                                this.entryRequests.put(
                                        pallet.getId(), (new EntryRequest(pallet, id))));
    }

    @Override
    public Map<String, Map<String, Pallet>> getEntryRequests() {
        Map<String, Map<String, Pallet>> entryRequests = new HashMap<>();
        for (EntryRequest e : this.entryRequests.values()) {
            if (entryRequests.containsKey(e.getTruckID())) {
                entryRequests
                        .get(e.getTruckID())
                        .put(
                                e.getId(),
                                new Pallet(
                                        e.getId(),
                                        e.getProduct(),
                                        e.getQuantity(),
                                        e.getCompany(),
                                        e.getType()));
            } else {
                Map<String, Pallet> pallets = new HashMap<>();
                pallets.put(
                        e.getId(),
                        new Pallet(
                                e.getId(),
                                e.getProduct(),
                                e.getQuantity(),
                                e.getCompany(),
                                e.getType()));
                entryRequests.put(e.getTruckID(), pallets);
            }
        }
        return entryRequests;
    }

    /*public void setEntryRequests(Map<String, Map<String, Pallet>> entryRequests) {
        this.entryRequests = new HashMap<>();
        entryRequests.forEach(this.entryRequests::put);
    }*/

    @Override
    public void denyEntryRequest(String id) {
        this.entryRequests.remove(id);
    }
}
