package Model;

import java.util.Map;

public interface BillInterface {
    /**
     * Returns the quantity sold of a product in a certain branch, month and type
     *
     * @param branch number to filter the information by branch
     * @param month number to filter the information by month
     * @param type number to filter the information by type
     * @return the quantity sold of a product within the given branch, month and type
     */
     int getProductQuantity(int branch, int month, String type);

    /**
     * Returns the expenditure sold of a product in a certain branch, month and type
     *
     * @param branch number to filter the information by branch
     * @param month number to filter the information by month
     * @param type number to filter the information by type
     * @return the expenditure sold of a product within the given branch, month and type
     */
     double getProductExpenditure(int branch, int month, String type);

    /**
     * Returns the number of sales of a product in a certain branch, month and type
     *
     * @param branch number to filter the information by branch
     * @param month number to filter the information by month
     * @param type number to filter the information by type
     * @return the the number of sales of a product within the given branch, month and type
     */
     int getProductRecordsNumber(int branch, int month, String type);

    /**
     * Update the information of a Bill in the given dimensions and sale information
     *
     * @param branch Branch dimension value
     * @param month Month dimension value
     * @param type Type dimension value
     * @param quantity Quantity of units in the sale
     * @param cost Cost per unit in the sale
     */
     void updateBill(int branch,int month, String type, int quantity, float cost);

    /**
     * Get the total Expenditure of a Product made in a month
     *
     * @param month Month dimension value
     * @return The map with total Expenditure in the given month by branch
     */
     Map<Integer, Double> getTotalExpenditureMonth(int month);

    /**
     * Get the total Expenditure of a Product
     * @return total Expenditure of the product
     */
     float[][] getTotalExpenditure();
}
