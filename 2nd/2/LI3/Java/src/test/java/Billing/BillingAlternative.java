package Billing;

import Model.BillingInterface;
import Model.BillInterface;

import java.io.Serializable;
import java.util.Map;
import java.util.HashMap;

public class BillingAlternative implements  Serializable {

    private static final long serialVersionUID = 4403750127299672198L;

    public Map<String, BillInterface> billsMap;

    /**
     * Instanciates a new billing structure
     */
    public BillingAlternative(){
        this.billsMap = new HashMap<>();
    }

    /**
     *
     * @return number of products which were bought
     */
    public int getNumberOfProducts(){
        return  this.billsMap.size();
    }


    public int getProductQuantity(String productID,int branch, int month, String type){
        return this.billsMap.get(productID).getProductQuantity(branch,month,type);
    }

    public double getProductExpenditure(String productID,int branch, int month, String type){
        return this.billsMap.get(productID).getProductExpenditure(branch,month,type);
    }

    public int getProductRecordsNumber(String productID,int branch, int month, String type){
        return this.billsMap.get(productID).getProductRecordsNumber(branch,month,type);
    }

    public void updateBilling(String productID,int branch,int month,String type,int quantity,float cost){
        if(!(this.billsMap.containsKey(productID))){
            BillInterface bills = new BillsAlternative();
            this.billsMap.put(productID,bills);
        }
        this.billsMap.get(productID).updateBill(branch,month,type,quantity,cost);
    }

    public Map<Integer, Map<Integer, Double>> getTotalExpenditure(){
        return new HashMap<>();
    }

    public boolean contains(String productID){
        return this.billsMap.containsKey(productID);
    }

    public Map<String,float[][]> query10(){return new HashMap<>();}
}
