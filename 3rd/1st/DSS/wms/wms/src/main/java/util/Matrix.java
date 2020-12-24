package util;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collections;
import java.util.List;
import java.util.stream.Collectors;

import javafx.util.Pair;
import model.Shelf;
import model.Station;

public class Matrix {

    static int default_width = 10;
    static int default_height = 10;
    static Character barrier = 'B';
    static Character empty = 'N';
    static Character shelf = 'S';
    static Character objective = 'O';

    private List<List<Character>> matrix;
    private int width;
    private int height;

    public Matrix(int width, int height) {
        this.width = width;
        this.height = height;
        this.matrix = new ArrayList<List<Character>>(height);
        for (int i = 0; i < height; i++) {
            // TODO - refactor
            this.matrix.add(i, new ArrayList<Character>(Collections.nCopies(width, Matrix.empty)));
        }
    }

    public Matrix() {
        this(Matrix.default_width, Matrix.default_height);
    }

    public Matrix(int width, int height, List<Shelf> shelves) {
        this(width, height);
        this.setShelves(shelves);
    }

    public Pair<Integer, Integer> getDimensions() {
        return new Pair<>(width, height);
    }

    public void setShelves(List<Shelf> shelves) {
        List<Pair<Integer, Integer>> coords =
                shelves.stream().map(Station::getCoordinates).collect(Collectors.toList());
        this.setShelvesCoords(coords);
    }

    public void setShelvesCoords(List<Pair<Integer, Integer>> coordinates) {
        // convert to int
        List<Pair<Integer, Integer>> coords =
                coordinates.stream()
                        .map(
                                coord ->
                                        new Pair<Integer, Integer>(
                                                (int) Math.round(coord.getKey()),
                                                (int) Math.round(coord.getValue())))
                        .collect(Collectors.toList());

        coords.forEach(
                coord -> {
                    this.matrix.get(realY(coord.getValue())).set(coord.getKey(), Matrix.shelf);
                });
    }

    private int realY(int y) {
        return this.height - y - 1;
    }

    private Character getValue(int x, int realy) {
        return this.matrix.get(realy).get(x);
    }

    public boolean isEmpty(int x, int realy) {
        return getValue(x, realy) == Matrix.empty;
    }

    public boolean isValid(int x, int realy) {
        return x < width && x >= 0 && realy < height && realy >= 0;
    }

    public boolean isValid(Pair<Integer, Integer> coord) {
        return isValid(coord.getKey(), coord.getValue());
    }

    public Character getAtPos(Pair<Integer, Integer> coord) {
        return this.matrix.get(realY(coord.getValue())).get(coord.getKey());
    }

    @Override
    public String toString() {
        StringBuilder sb = new StringBuilder();
        for (List<Character> row : this.matrix) {
            sb.append(row.toString() + "\n");
        }
        sb.setLength(sb.length() - 1);
        return sb.toString();
    }
}
