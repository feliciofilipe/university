package model;

import javafx.util.Pair;

import java.util.HashMap;
import java.util.Map;

public abstract class Station extends SystemEntity {

    private Pair<Integer, Integer> coordinates;
    private Integer capacity;
    private Map<String, Pallet> pallets;

    public Station(String id, Integer x, Integer y, Integer capacity) {
        super(id);
        this.coordinates = new Pair<>(x, y);
        this.capacity = capacity;
        this.pallets = new HashMap<>();
    }

    public Pair<Integer, Integer> getCoordinates() {
        return coordinates;
    }

    public void setCoordinates(Pair<Integer, Integer> coordinates) {
        this.coordinates = coordinates;
    }

    public Map<String, Pallet> getPallets() {
        Map<String, Pallet> pallets = new HashMap<>();
        this.pallets.forEach((k, v) -> pallets.put(k, v /*.clone()*/));
        return pallets;
    }

    public void setPallets(Map<String, Pallet> pallets) {
        this.pallets = pallets;
    }

    public void removePallet(String id) {
        Map<String, Pallet> pallets = new HashMap<>();
        this.getPallets().values().stream()
                .filter(pallet -> !pallet.getId().equals(id))
                .forEach(pallet -> pallets.put(pallet.getId(), pallet));
        this.setPallets(pallets);
    }

    public void removeAllPallets() {
        this.setPallets(new HashMap<>());
    }

    public Integer getCapacity() {
        return capacity;
    }

    public void setCapacity(Integer capacity) {
        this.capacity = capacity;
    }

    public void takePallet(String id, Pallet pallet) {
        this.pallets.put(id, pallet);
    }
}
