package util;

import javafx.util.Pair;

import java.util.*;
import java.util.stream.Collectors;

public class PathFinder {
  static List<Pair<Integer, Integer>> Directions =
      new ArrayList<>(
          Arrays.asList(
              new Pair<>(1, 0),
              new Pair<>(0, 1),
              new Pair<>(-1, 0),
              new Pair<>(0, -1),
              new Pair<>(1, 1),
              new Pair<>(-1, -1),
              new Pair<>(1, -1),
              new Pair<>(-1, 1)));

  static List<Integer> weights = new ArrayList<>(Arrays.asList(10, 10, 10, 10, 14, 14, 14, 14));

  Matrix matrix;
  Map<Pair<Integer, Integer>, Boolean> closedList;
  Set<Pair<Integer, Integer>> openList;
  boolean foundDest;
  List<List<Cell>> cellDetails;

  public PathFinder(Matrix matrix) {
    // todo - podia usar matriz para todos
    this.matrix = matrix;
    this.cellDetails = new ArrayList<>(matrix.getDimensions().getValue());
    for (int i = 0; i < matrix.getDimensions().getValue(); i++) {
      // TODO - refactor
      this.cellDetails.add(
          i, new ArrayList<>(Collections.nCopies(matrix.getDimensions().getKey(), new Cell())));
    }
    initOpened();
    initClosed();
  }

  private void initClosed() {
    this.closedList = new HashMap<>();
    Pair<Integer, Integer> dims = this.matrix.getDimensions();
    int width = dims.getKey();
    int height = dims.getValue();

    for (int i = 0; i < height; i++) {
      for (int j = 0; j < width; j++) {
        this.closedList.put(new Pair<>(i, j), false);
      }
    }
  }

  private void initOpened() {
    this.openList = new HashSet<>();
  }

  private void resetDetails() {
    Pair<Integer, Integer> dims = this.matrix.getDimensions();
    for (int i = 0; i < dims.getValue(); i++) {
      for (int j = 0; j < dims.getKey(); j++) {
        this.cellDetails.get(i).set(j, new Cell());
      }
    }
  }

  private Stack<Pair<Integer, Integer>> tracePath(Pair<Integer, Integer> dest) {
    int row = dest.getKey();
    int col = dest.getValue();
    // System.out.println("row: " + row + ", col: " + col);
    Stack<Pair<Integer, Integer>> path;
    path = new Stack<>();
    while (!(this.getCell(new Pair<>(row, col)).parent.getKey() == row
        && this.getCell(new Pair<>(row, col)).parent.getValue() == col)) {
      // System.out.println("ola");
      path.push(new Pair<>(row, col));
      // System.out.println("path " + path);
      Pair<Integer, Integer> parent = this.getCell(new Pair<>(row, col)).parent;
      row = parent.getKey();
      col = parent.getValue();
    }
    path.push(new Pair<>(row, col));
    return path;
    //
  }

  public void printPath(Stack<Pair<Integer, Integer>> path) {
    while (!path.isEmpty()) {
      Pair<Integer, Integer> r = path.pop();
      System.out.print(" -> (" + r.getKey() + "," + r.getValue() + ")");
    }
    System.out.print("\n");
  }

  public Stack<Pair<Integer, Integer>> search(
      Pair<Integer, Integer> orig, Pair<Integer, Integer> dest) {
    // reset details and closed and opened
    this.foundDest = false;
    this.resetDetails();
    this.initClosed();
    this.initOpened();
    // set this pair as open
    openList.add(orig);
    this.setCellParent(orig, orig);
    this.setCellDetails(orig, 0, 0);

    if (orig.equals(dest)) this.foundDest = true;

    while (!openList.isEmpty() && !this.foundDest) {
      // printCellDetails();
      Pair<Integer, Integer> initial = mininumF_inOpen();

      openList.remove(initial);
      // System.out.println("INITIAL: " + initial);
      closedList.put(initial, true);

      searchAdjacent(initial, dest);
    }
    if (this.foundDest) {
      // System.out.println("Encontrei");
      return this.tracePath(dest);
    }
    return null;
  }

  private void searchAdjacent(Pair<Integer, Integer> initial, Pair<Integer, Integer> dest) {
    for (int i = 0; i < 8; i++) {
      Pair<Integer, Integer> direction = PathFinder.Directions.get(i);
      Pair<Integer, Integer> adj =
          new Pair<>(
              initial.getKey() + direction.getKey(), initial.getValue() + direction.getValue());

      // if is valid
      if (matrix.isValid(adj.getKey(), adj.getValue())) {
        // System.out.println("adj->"+adj.getKey()+","+adj.getValue());
        // if is the destination
        if (adj.getKey().equals(dest.getKey()) && adj.getValue().equals(dest.getValue())) {
          this.setCellParent(adj, initial);
          this.foundDest = true;
          return;
          // else if is unblocked and not in closed
        } else if (closedList.get(adj) == false && this.matrix.getAtPos(adj) == Matrix.empty) {

          int gNew = getCellDetailG(initial) + weights.get(i);
          int hNew = (int) calculateHValue(adj.getKey(), adj.getValue(), dest);
          int fNew = gNew + hNew;

          if (this.getCellDetailF(adj) == Integer.MAX_VALUE || getCellDetailF(adj) > fNew) {
            openList.add(adj); // todo muito cuidado com isto!!
            this.setCellDetails(adj, gNew, hNew);
            this.setCellParent(adj, initial);
          }
        }
      }
    }
  }

  private Pair<Integer, Integer> mininumF_inOpen() {
    List<Pair<Pair<Integer, Integer>, Integer>> opened =
        openList.stream()
            .map(
                p -> {
                  Pair<Pair<Integer, Integer>, Integer> ret = new Pair<>(p, this.getCellDetailF(p));
                  return ret;
                })
            .sorted(Comparator.comparing(Pair::getValue))
            .collect(Collectors.toList());
    int min = opened.get(0).getValue();
    List<Pair<Pair<Integer, Integer>, Integer>> minimums = new ArrayList<>();
    Iterator<Pair<Pair<Integer, Integer>, Integer>> iter = opened.iterator();
    Pair<Pair<Integer, Integer>, Integer> cur;
    while (iter.hasNext() && (cur = iter.next()).getValue() == min) {
      minimums.add(cur);
    }
    return minimums.stream()
        .sorted(Comparator.comparingInt(pp -> getCellDetailH(pp.getKey())))
        .map(Pair::getKey)
        .findFirst()
        .orElse(null);
  }

  // A Utility Function to calculate the 'h' heuristics.
  private double calculateHValue(int x, int y, Pair<Integer, Integer> dest) {
    // Return using the distance formula
    //        return ((double) Math.sqrt((x-dest.getKey())*(x-dest.getKey())
    //             + (y-dest.getValue())*(y-dest.getValue())));

    return Integer.max(Math.abs((x - dest.getKey()) * 10), Math.abs((y - dest.getValue()) * 10));
  }

  // todo - refactor
  private int realY(int y) {
    return this.matrix.getDimensions().getValue() - y - 1;
  }

  public void printCellDetails() {
    StringBuilder sb = new StringBuilder();
    Pair<Integer, Integer> dims = this.matrix.getDimensions();
    int width = dims.getKey();
    int height = dims.getValue();
    for (int i = 0; i < height; i++) {
      for (int j = 0; j < width; j++) {
        sb.append(this.cellDetails.get(i).get(j));
      }
      sb.append("\n");
    }
    System.out.println(sb.toString());
  }

  private void setCellParent(Pair<Integer, Integer> child, Pair<Integer, Integer> parent) {
    // System.out.println("a mudar os pais de: " + child.getKey()+","+child.getValue());
    this.cellDetails.get(realY(child.getValue())).get(child.getKey()).setParent(parent);
  }

  private void setCellDetails(int x, int y, int g, int h) {
    this.cellDetails.get(realY(y)).get(x).setValues(g, h);
  }

  private void setCellDetails(Pair<Integer, Integer> coord, int g, int h) {
    this.cellDetails.get(realY(coord.getValue())).get(coord.getKey()).setValues(g, h);
  }

  private int getCellDetailF(Pair<Integer, Integer> coord) {
    return this.cellDetails.get(realY(coord.getValue())).get(coord.getKey()).getF();
  }

  private int getCellDetailH(Pair<Integer, Integer> coord) {
    return this.cellDetails.get(realY(coord.getValue())).get(coord.getKey()).getH();
  }

  private int getCellDetailG(Pair<Integer, Integer> coord) {
    return this.cellDetails.get(realY(coord.getValue())).get(coord.getKey()).getG();
  }

  private Cell getCell(Pair<Integer, Integer> coord) {
    return this.cellDetails.get(realY(coord.getValue())).get(coord.getKey());
  }

  public class Cell {
    Pair<Integer, Integer> parent;
    int f, g, h;

    public Cell() {
      this.parent = null;
      this.g = Integer.MAX_VALUE;
      this.h = Integer.MAX_VALUE;
      this.f = Integer.MAX_VALUE;
    }

    public Cell(Pair<Integer, Integer> parent, int g, int h) {
      this.parent = parent;
      this.g = g;
      this.h = h;
      this.f = g + h;
    }

    public Cell(Pair<Integer, Integer> parent, int g, int h, int f) {
      this.parent = parent;
      this.g = g;
      this.h = h;
      this.f = f;
    }

    public void setParent(Pair<Integer, Integer> parent) {
      this.parent = parent;
    }

    public void setValues(int g, int h) {
      this.g = g;
      this.h = h;
      this.f = g + h;
    }

    public int getF() {
      return this.f;
    }

    public int getH() {
      return this.h;
    }

    public int getG() {
      return this.g;
    }

    @Override
    public String toString() {
      StringBuilder sb = new StringBuilder();
      int px = -1;
      int py = -1;
      if (this.parent != null) {
        px = this.parent.getKey();
        py = this.parent.getValue();
      }
      String G = this.g == 2147483647 ? "Inf" : String.valueOf(g);
      String H = this.h == 2147483647 ? "Inf" : String.valueOf(h);
      String F = this.f == 2147483647 ? "Inf" : String.valueOf(f);

      sb.append("{p:" + px + "," + py);
      sb.append("-g:" + G + ";h:" + H + ";f:" + F + "}");

      return sb.toString();
    }
  }
}
