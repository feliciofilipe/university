package Model;

import Utilities.Config;

import java.io.Serializable;
import java.util.HashMap;
import java.util.Map;

public class Billing implements BillingInterface, Serializable {

    private static final long serialVersionUID = 4213023488500624677L;

    /**
     * Map with Bills of Products
     */
    public Map<String, BillInterface> billsMap;


    /**
     * Instanciates a new billing structure
     */
    public Billing(){
        this.billsMap = new HashMap<>();
    }

    /**
     * Returns the number of Products (entries) in the map
     *
     * @return The size of map
     */
    public int getNumberOfProducts(){
        return  this.billsMap.size();
    }

    /**
     * Returns the quantity sold of a product in a certain branch, month and type
     *
     * @param productID String with the ID of the product
     * @param branch number to filter the information by branch
     * @param month number to filter the information by month
     * @param type number to filter the information by type
     * @return the quantity sold of a product within the given branch, month and type
     */
    public int getProductQuantity(String productID,int branch,int month,String type){
        return this.billsMap.get(productID).getProductQuantity(branch,month,type);
    }

    /**
     * Returns the expenditure sold of a product in a certain branch, month and type
     *
     * @param productID String with the ID of the product
     * @param branch number to filter the information by branch
     * @param month number to filter the information by month
     * @param type number to filter the information by type
     * @return the expenditure sold of a product within the given branch, month and type
     */
    public double getProductExpenditure(String productID,int branch,int month,String type){
         return this.billsMap.get(productID).getProductExpenditure(branch,month,type);
    }

    /**
     * Returns the number of sales of a product in a certain branch, month and type
     *
     * @param productID String with the ID of the product
     * @param branch number to filter the information by branch
     * @param month number to filter the information by month
     * @param type number to filter the information by type
     * @return the the number of sales of a product within the given branch, month and type
     */
    public int getProductRecordsNumber(String productID,int branch,int month,String type){
        return this.billsMap.get(productID).getProductRecordsNumber(branch,month,type);
    }

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
    public void updateBilling(String productID, int branch, int month, String type, int quantity, float cost) {
        BillInterface bill = this.billsMap.computeIfAbsent(productID, k -> new Bill());
        bill.updateBill(branch,month,type,quantity,cost);
    }

    /**
     * Get the total Expenditure of a Product
     *
     * @return Two Dimensional Map with total Expenditure of the product by branch and month
     */
    public Map<Integer, Map<Integer, Double>> getTotalExpenditure(){
        Map<Integer, Map<Integer, Double>> map = new HashMap<>();
        for(int month = 0; month < Config.maxMonth; month++){
            Map<Integer,Double> innerMap = new HashMap<>();
            for(int branch = 0; branch < Config.numberOfBranches; branch++) innerMap.put(branch,0.0);
            for (BillInterface bills : this.billsMap.values()) {
                Map<Integer, Double> billMap = bills.getTotalExpenditureMonth(month);
                billMap.forEach((k,v) -> innerMap.put(k,(innerMap.get(k)+v)));
            }
            map.put(month,innerMap);
        }
        return map;
    }

    /**
     * Check is there is a instance of a product in the Bill Map
     *
     * @param productID String with the ID of the product
     * @return If the map contains a bill of the product
     */
    public boolean contains(String productID){
        return this.billsMap.containsKey(productID);
    }


    /**
     * Get the total Expenditure of all Products by Branch and Month
     *
     * @return Two Dimensional Map with total Expenditure of all products by branch and month
     */
    public Map<String,float[][]> getTotalExpenditureByProduct(){
        Map<String,float[][]> totalExpenditures = new HashMap<>();
        this.billsMap.forEach((k,v) -> totalExpenditures.put(k,v.getTotalExpenditure()));
        return totalExpenditures;
    }
}