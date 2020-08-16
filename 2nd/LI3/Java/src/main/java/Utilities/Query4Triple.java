package Utilities;

public class Query4Triple {

    /**
     * number of sales in which the client is involved
     */
    private int numberOfSales;

    /**
     * number of different products the client has bought
     */
    private int numberOfDistinctClients;

    /**
     * total value of sales in which the client is involved
     */
    private float totalExpenditure;


    public Query4Triple(int numberOfSales, int numberOfDistinctClients, float totalExpenditure) {
        this.numberOfSales = numberOfSales;
        this.numberOfDistinctClients = numberOfDistinctClients;
        this.totalExpenditure = totalExpenditure;
    }

    public int getNumberOfSales() {
        return numberOfSales;
    }

    public int getNumberOfDistinctClients() {
        return numberOfDistinctClients;
    }

    public float getTotalExpenditure() {
        return totalExpenditure;
    }

    public String toString(){
        return "Number of sales: "+this.numberOfDistinctClients + ", "+"Number of distinct clients: "
                + this.numberOfDistinctClients + ", Total Expenditure: " + totalExpenditure +"\n";
    }
}


