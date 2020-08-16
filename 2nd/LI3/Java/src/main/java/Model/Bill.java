package Model;

import Utilities.Config;

import java.io.Serializable;
import java.util.HashMap;
import java.util.Map;

public class Bill implements BillInterface, Serializable {

    private static final long serialVersionUID = 9114290045350281784L;

    /**
     * Three dimensional array (Branch,Month,Type) with the quantity sold of a product in the occurrence of the dimensional values
     */
    private int[][][] quantities;

    /**
     * Three dimensional array (Branch,Month,Type) with the expenditure made with a product in the occurrence of the dimensional values
     */
    private float[][][] expenditures;

    /**
     * Three dimensional array (Branch,Month,Type) with the number of sales of a product in the occurrence of the dimensional values
     */
    private int[][][] recordsNumber;

    /**
     * Instantiates a new bill structure
     */
    public Bill(){
        this.quantities = new int[Config.numberOfBranches][Config.maxMonth][Config.numberOfSaleTypes];
        this.expenditures = new float[Config.numberOfBranches][Config.maxMonth][Config.numberOfSaleTypes];
        this.recordsNumber = new int[Config.numberOfBranches][Config.maxMonth][Config.numberOfSaleTypes];
    }

    /**
     * Returns the quantity sold of a product in a certain branch, month and type
     *
     * @param branch number to filter the information by branch
     * @param month number to filter the information by month
     * @param type number to filter the information by type
     * @return the quantity sold of a product within the given branch, month and type
     */
    public int getProductQuantity(int branch, int month, String type) {
        int typeCode = (type.equals("N")) ? Config.saleN : Config.saleP;
        return this.quantities[branch-1][month-1][typeCode];
    }

    /**
     * Returns the expenditure sold of a product in a certain branch, month and type
     *
     * @param branch number to filter the information by branch
     * @param month number to filter the information by month
     * @param type number to filter the information by type
     * @return the expenditure sold of a product within the given branch, month and type
     */
    public double getProductExpenditure(int branch, int month, String type) {
        int typeCode = (type.equals("N")) ? Config.saleN : Config.saleP;
        return this.expenditures[branch-1][month-1][typeCode];
    }

    /**
     * Returns the number of sales of a product in a certain branch, month and type
     *
     * @param branch number to filter the information by branch
     * @param month number to filter the information by month
     * @param type number to filter the information by type
     * @return the the number of sales of a product within the given branch, month and type
     */
    public int getProductRecordsNumber(int branch, int month, String type) {
        int typeCode = (type.equals("N")) ? Config.saleN : Config.saleP;
        return this.recordsNumber[branch-1][month-1][typeCode];
    }


    /**
     * Update the information of a Bill in the given dimensions and sale information
     *
     * @param branch Branch dimension value
     * @param month Month dimension value
     * @param type Type dimension value
     * @param quantity Quantity of units in the sale
     * @param cost Cost per unit in the sale
     */
    public void updateBill(int branch,int month, String type, int quantity, float cost) {
        int typeCode = (type.equals("N")) ? Config.saleN : Config.saleP;
        this.quantities[branch-1][month-1][typeCode] += quantity;
        this.expenditures[branch-1][month-1][typeCode] += quantity*cost;
        this.recordsNumber[branch-1][month-1][typeCode]++;
    }

    /**
     * Get the total Expenditure of a Product made in a month
     *
     * @param month Month dimension value
     * @return The map with total Expenditure in the given month by branch
     */
    public Map<Integer, Double> getTotalExpenditureMonth(int month){
        Map<Integer, Double> map = new HashMap<>();
        double expenditure = 0;
        for(int branch = 0; branch < Config.numberOfBranches; branch++){
            for(int type = 0; type < Config.numberOfSaleTypes; type++)
                expenditure += this.expenditures[branch][month][type];
            map.put(branch,expenditure);
        }
        return map;
    }

    /**
     * Get the total Expenditure of a Product
     *
     * @return total Expenditure of the product
     */
    public float[][] getTotalExpenditure(){
        float[][] totalExpenditure = new float[Config.maxMonth][Config.numberOfBranches];
            for(int month = 0; month < Config.maxMonth; month++) {
                for(int branch = 0; branch < Config.numberOfBranches; branch++){
                for (int type = 0; type < Config.numberOfSaleTypes; type++){
                    totalExpenditure[month][branch] = this.expenditures[branch][month][type];
                }
            }
        }
        return totalExpenditure;
    }
}
