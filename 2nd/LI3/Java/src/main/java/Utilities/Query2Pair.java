package Utilities;

public class Query2Pair {

    private int numberSales;

    private int numberDistinctClients;

    public Query2Pair(int numberSales, int numberDistinctClients) {
        this.numberSales = numberSales;
        this.numberDistinctClients = numberDistinctClients;
    }

    public int getNumberSales() {
        return numberSales;
    }

    public int getNumberDistinctClients() {
        return numberDistinctClients;
    }
}
