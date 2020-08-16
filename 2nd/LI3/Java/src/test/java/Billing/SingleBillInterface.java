package Billing;

public interface SingleBillInterface {
     int getQuantity();

    /**
     *
     * @return
     */
     double getExpenditure();

    /**
     *
     * @return
     */
     int getRecordsNumber();

    /**
     *
     * @param quantity
     */
     void setQuantity(int quantity);

    /**
     *
     * @param expenditure
     */
     void setExpenditure(double expenditure);

    /**
     *
     * @param recordsNumber
     */
     void setRecordsNumber(int recordsNumber);

}
