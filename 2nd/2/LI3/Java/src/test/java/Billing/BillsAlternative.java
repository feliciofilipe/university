package Billing;

import Model.BillInterface;
import Utilities.Config;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class BillsAlternative implements BillInterface, Serializable {

    private static final long serialVersionUID = 5053186396247406605L;

    List<List<List<SingleBill>>> billList;

    public BillsAlternative(){
        this.billList = new ArrayList<>(Config.numberOfBranches);
        for(int i = 0; i < Config.numberOfBranches; i++){
            List<List<SingleBill>> matrix = new ArrayList<>(Config.maxMonth);
            for(int j = 0; j < Config.maxMonth; j++) {
                List<SingleBill> list = new ArrayList<>(Config.numberOfSaleTypes);
                for (int k = 0; k < Config.numberOfSaleTypes; k++){
                    SingleBill singleBill = new SingleBill();
                    list.add(k, singleBill);
                }
                matrix.add(j,list);
            }
            this.billList.add(i,matrix);
        }
    }

    public int getProductQuantity(int branch, int month, String type) {
        int typeCode = (type.equals("N")) ? Config.saleN : Config.saleP;
        return this.billList.get(branch).get(month).get(typeCode).getQuantity();
    }

    public double getProductExpenditure(int branch, int month, String type) {
        int typeCode = (type.equals("N")) ? Config.saleN : Config.saleP;
        return this.billList.get(branch).get(month).get(typeCode).getExpenditure();
    }

    public int getProductRecordsNumber(int branch, int month, String type) {
        int typeCode = (type.equals("N")) ? Config.saleN : Config.saleP;
        return this.billList.get(branch).get(month).get(typeCode).getRecordsNumber();
    }

    public void updateBill(int branch, int month, String type, int quantity, float cost) {
        int typeCode = (type.equals("N")) ? Config.saleN : Config.saleP;
        SingleBill singleBill = this.billList.get(branch-1).get(month-1).get(typeCode);
        singleBill.setQuantity(singleBill.getQuantity() + quantity);
        singleBill.setExpenditure(singleBill.getExpenditure() + (quantity*cost));
        singleBill.setRecordsNumber(singleBill.getRecordsNumber() + 1);
    }

    public Map<Integer, Double> getTotalExpenditureMonth(int month){
        return new HashMap<>();
    }

    @Override
    public float[][] getTotalExpenditure() {
        return new float[0][];
    }
}
