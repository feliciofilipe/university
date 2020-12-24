package model;

public class Truck extends Station implements Transporter {

    public Truck(String id, Integer x, Integer y, Integer capacity) {
        super(id, x, y, capacity);
    }

    public void dropPallet(String id, Station station) {
        station.takePallet(id, this.getPallets().get(id));
        this.removePallet(id);
    }
}
