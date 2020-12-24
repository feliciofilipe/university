package model;

import javafx.util.Pair;


public class Shelf extends Station {

    public Shelf(String id, Integer x, Integer y, Integer capacity) {
        super(id, x, y, capacity);
    }

    public Shelf(String id, Pair<Integer, Integer> coords, Integer capacity) {
        super(id, coords.getKey(), coords.getValue(), capacity);
    }
}
