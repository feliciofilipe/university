package model;

import javafx.util.Pair;

import java.util.ArrayList;
import java.util.List;

public class Robot extends Station implements Transporter {

    private List<Pair<Double, Double>> route;
    private boolean available;

    public Robot(String id, Integer x, Integer y, Integer capacity) {
        super(id, x, y, capacity);
        this.available = true;
        this.route = new ArrayList<>();
    }

    public Robot(String id, Integer x, Integer y, Integer capacity, boolean isAvailable) {
        super(id, x, y, capacity);
        this.available = isAvailable;
        this.route = new ArrayList<>();
    }

    public boolean isAvailable() {
        return this.available;
    }

    @Override
    public void dropPallet(String id, Station station) {
        station.takePallet(id, this.getPallets().get(id));
        this.getPallets().remove(id);
    }

    @Override
    public void takePallet(String id, Pallet pallet) {
        this.getPallets().put(id, pallet);
    }
}
