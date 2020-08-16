package Utilities;

public class Query3Triple {

    /**
     * number of sales in which the client is involved
     */
    private int numberOfSales;

    /**
     * number of different products the client has bought
     */
    private int numberOfDistinctProducts;

    /**
     * total value of sales in which the client is involved
     */
    private float totalExpenditure;


    public Query3Triple(int numberOfSales, int numberOfDistinctProducts, float totalExpenditure) {
        this.numberOfSales = numberOfSales;
        this.numberOfDistinctProducts = numberOfDistinctProducts;
        this.totalExpenditure = totalExpenditure;
    }

    public int getNumberOfSales() {
        return numberOfSales;
    }

    public int getNumberOfDistinctProducts() {
        return numberOfDistinctProducts;
    }

    public float getTotalExpenditure() {
        return totalExpenditure;
    }

    public String toString(){
        return "Number of sales: "+this.numberOfDistinctProducts + ", "+"Number of distinct products: "
                + this.numberOfDistinctProducts + ", Total Expenditure: " + totalExpenditure +"\n";
    }
}
