package Model;

import java.util.Map;

public interface BillingInterface {


    /**
     * Returns the number of Products (entries) in the map
     *
     * @return The size of map
     */
     int getNumberOfProducts();

    /**
     * Returns the quantity sold of a product in a certain branch, month and type
     *
     * @param productID String with the ID of the product
     * @param branch number to filter the information by branch
     * @param month number to filter the information by month
     * @param type number to filter the information by type
     * @return the quantity sold of a product within the given branch, month and type
     */
     int getProductQuantity(String productID,int branch, int month, String type);

    /**
     * Returns the expenditure sold of a product in a certain branch, month and type
     *
     * @param productID String with the ID of the product
     * @param branch number to filter the information by branch
     * @param month number to filter the information by month
     * @param type number to filter the information by type
     * @return the expenditure sold of a product within the given branch, month and type
     */
     double getProductExpenditure(String productID,int branch, int month, String type);

    /**
     * Returns the number of sales of a product in a certain branch, month and type
     *
     * @param productID String with the ID of the product
     * @param branch number to filter the information by branch
     * @param month number to filter the information by month
     * @param type number to filter the information by type
     * @return the the number of sales of a product within the given branch, month and type
     */
     int getProductRecordsNumber(String productID,int branch, int month, String type);

    /**
     * Update the information of a Bill in the given dimensions and sale information
     *
     * @param productID String with the ID of the product
     * @param branch Branch dimension value
     * @param month Month dimension value
     * @param type Type dimension value
     * @param quantity Quantity of units in the sale
     * @param cost Cost per unit in the sale
     */
     void updateBilling(String productID,int branch,int month,String type,int quantity,float cost);

    /**
     * Get the total Expenditure of a Product
     *
     * @return Two Dimensional Map with total Expenditure of the product by branch and month
     */
     Map<Integer, Map<Integer, Double>> getTotalExpenditure();

    /**
     * Check is there is a instance of a product in the Bill Map
     *
     * @param productID String with the ID of the product
     * @return If the map contains a bill of the product
     */
     boolean contains(String productID);

    /**
     * Get the total Expenditure of all Products by Branch and Month
     *
     * @return Two Dimensional Map with total Expenditure of all products by branch and month
     */
     Map<String,float[][]> getTotalExpenditureByProduct();
}
