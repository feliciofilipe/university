package Model;

import java.time.LocalDateTime;
import java.util.Map;


public class Record extends Order implements java.io.Serializable {

    /**
     * The rating of a delivery
     */
    Double rating;

    /**
     * Date of rating
     */
    LocalDateTime date;

    /**
     * Price of the transporter
     */
    Double transporterPrice;

    /**
     * Default Constructor
     */
    public Record(){
        super();
        this.rating = 0.0;
        this.date = LocalDateTime.now();
        this.transporterPrice = 0.0;
    }

    /**
     * Parameterized Constructor
     * @param orderID OrderID of the record
     * @param userID UserID of the record
     * @param storeID StoreID of the record
     * @param weight Weight of the record
     * @param productList ProductList of the record
     */
    public Record(String orderID, String userID, String storeID,
                  Double weight, Map<String,Product> productList, Double rating,Double transporterPrice){
        super(orderID, userID, storeID,weight,productList);
        this.rating = rating;
        this.date = LocalDateTime.now();
        this.transporterPrice = transporterPrice;
    }

    /**
     * Clone Constructor
     * @param record Class Record to be instantiated
     */
    public Record(Record record){
        super(record.getOrderID(),
              record.getOrderID(),
              record.getStoreID(),
              record.getWeight(),
              record.getProductList());
        this.rating = record.getRating();
        this.date = LocalDateTime.now();
        this.transporterPrice = record.getTransporterPrice();
    }

    /**
     * Constructor
     * @param order Class Record to be instantiated
     * @param rating Rating of and order
     */
    public Record(Order order,Double rating,Double transporterPrice){
        super(order);
        this.rating = rating;
        this.date = LocalDateTime.now();
        this.transporterPrice = transporterPrice;
    }

    /**
     * Returns the rating order
     * @return Rating of the product
     */
    public double getRating() {
        return rating;
    }

    /**
     * Returns the date order
     * @return Date of the product
     */
    public LocalDateTime getDate() {
        return date;
    }

    /**
     * Returns the price of the transporter
     * @return the Price of the Transporter
     */
    public Double getTransporterPrice() {
        return transporterPrice;
    }

    /**
     * Set the Record Date
     * @param date transporter date to set
     */
    public void setDate(LocalDateTime date) {
        this.date = date;
    }

    /**
     * Set the Record transporter price
     * @param transporterPrice transporter price to set
     */
    public void setTransporterPrice(Double transporterPrice) {
        this.transporterPrice = transporterPrice;
    }

    /**
     * Set the Record Rating
     * @param rating rating to set
     */
    public void setRating(Double rating) {
        this.rating = rating;
    }

    /**
     * Compares an object to the Record
     * @param obj Object to compare to
     * @return Whether the object and the Record are equal
     */
    @Override
    public boolean equals(Object obj) {
        if(obj==this) return true;
        if(obj==null || obj.getClass() != this.getClass()) return false;
        Record record = (Record) obj;
        return super.equals(obj) &&
               record.getRating() == this.rating &&
               record.getDate().equals(this.date);
    }


    /**
     * Turns the Record information to a String
     * @return String with the Record information
     */
    @Override
    public String toString() {
        return "Record{" +
                "rating=" + rating +
                ", date=" + date +
                "}\n" +
                super.toString();
    }

    /**
     * Clones the Record
     * @return Copie of the Record
     */
    @Override
    public Record clone() {
        return new Record(this);
    }

}
