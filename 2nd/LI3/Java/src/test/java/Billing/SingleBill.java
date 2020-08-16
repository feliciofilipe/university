package Billing;

import java.io.Serializable;

public class SingleBill implements SingleBillInterface, Serializable {
    private static final long serialVersionUID = 8908850634900609514L;

    /**
     *
     */
    private int quantity;

    /**
     *
     */
    private double expenditure;

    /**
     *
     */
    private int recordsNumber;

    /**
     *
     */
    public SingleBill(){
        this.quantity = 0;
        this.expenditure = 0.0;
        this.recordsNumber = 0;
    }

    /**
     *
     * @return
     */
    public int getQuantity() {
        return quantity;
    }

    /**
     *
     * @return
     */
    public double getExpenditure() {
        return expenditure;
    }

    /**
     *
     * @return
     */
    public int getRecordsNumber() {
        return recordsNumber;
    }

    /**
     *
     * @param quantity
     */
    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }

    /**
     *
     * @param expenditure
     */
    public void setExpenditure(double expenditure) {
        this.expenditure = expenditure;
    }

    /**
     *
     * @param recordsNumber
     */
    public void setRecordsNumber(int recordsNumber) {
        this.recordsNumber = recordsNumber;
    }
}
