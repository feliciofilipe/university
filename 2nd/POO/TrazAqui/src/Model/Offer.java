package Model;

import java.io.Serializable;
import java.time.LocalDateTime;

public class Offer implements Serializable {

    /**
     * ID of the order
     */
    private String orderID;

    /**
     * ID of the transporter
     */
    private String transporterID;

    /**
     * Price of transportation
     */
    private Double priceOfTransport;

    /**
     * Price of the order
     */
    private Double priceOfOrder;

    /**
     * Total time of the delivery
     */
    private LocalDateTime timeOfDelivery;

    /**
     * Default Constructor
     */
    public Offer(){
        this.orderID = "";
        this.transporterID = "";
        this.priceOfTransport = 0.0;
        this.priceOfOrder = 0.0;
        this.timeOfDelivery = LocalDateTime.now();
    }

    /**
     * Parameterized Constructor
     * @param orderID ID of the order
     * @param transporterID ID of the transporter
     * @param priceOfTransport Price of transportation
     * @param priceOfOrder Price of the order
     * @param timeOfDelivery Total time of delivery
     */
    public Offer(String orderID, String transporterID, Double priceOfTransport, Double priceOfOrder, LocalDateTime timeOfDelivery){
        this.orderID = orderID;
        this.transporterID = transporterID;
        this.priceOfTransport = priceOfTransport;
        this.priceOfOrder = priceOfOrder;
        this.timeOfDelivery = timeOfDelivery;
    }

    /**
     * Clone Constructor
     * @param offer Class Offer to be instantiated
     */
    public Offer(Offer offer){
        this.orderID = offer.getOrderID();
        this.transporterID = offer.getTransporterID();
        this.priceOfTransport = offer.getPriceOfTransport();
        this.priceOfOrder = offer.getPriceOfOrder();
        this.timeOfDelivery = offer.getTimeOfDelivery();
    }

    /**
     * Function that return the orderID of the record
     * @return OrderID
     */
    public String getOrderID() {
        return orderID;
    }

    /**
     * Function that return the transporterID of the record
     * @return Transporter ID
     */
    public String getTransporterID() {
        return transporterID;
    }

    /**
     * Function that return the price of transportation of the record
     * @return Price of Transportation
     */
    public Double getPriceOfTransport() {
        return priceOfTransport;
    }

    /**
     * Function that return the price of the order of the record
     * @return Price of Order
     */
    public Double getPriceOfOrder() {
        return priceOfOrder;
    }

    /**
     * Function that return the total time of delivery of the record
     * @return Total delivery time
     */
    public LocalDateTime getTimeOfDelivery() {
        return timeOfDelivery;
    }

    /**
     * Updates the OrderID of the entity
     * @param orderID New orderID of the record
     */
    public void setOrderID(String orderID) {
        this.orderID = orderID;
    }

    /**
     * Updates the TransporterID f the entity
     * @param transporterID New transporterID of the order
     */
    public void setTransporterID(String transporterID) {
        this.transporterID = transporterID;
    }

    /**
     * Updates the Price of Transportation of the entity
     * @param priceOfTransport New priceOfTransport of the order
     */
    public void setPriceOfTransport(Double priceOfTransport) {
        this.priceOfTransport = priceOfTransport;
    }

    /**
     * Updates the Price of the order of the entity
     * @param priceOfOrder New priceOfOrder of the order
     */
    public void setPriceOfOrder(Double priceOfOrder) {
        this.priceOfOrder = priceOfOrder;
    }

    /**
     * Updates the Total Time of Delivery of the entity
     * @param timeOfDelivery New timeOfDelivery of the order
     */
    public void setTimeOfDelivery(LocalDateTime timeOfDelivery) {
        this.timeOfDelivery = timeOfDelivery;
    }


    /**
     * Compares an object to the Offer
     * @param obj Object to compare to
     * @return Whether the object and the Offer are equal
     */
    @Override
    public boolean equals(Object obj){
        if(this == obj) return true;
        if(obj == null || this.getClass() != obj.getClass()) return false;
        Offer offer = (Offer) obj;
        return offer.getOrderID().equals(this.orderID) &&
               offer.getTransporterID().equals(this.transporterID) &&
               offer.getPriceOfTransport() == this.getPriceOfTransport() &&
               offer.getPriceOfOrder() == this.priceOfOrder &&
               offer.getTimeOfDelivery().equals(this.timeOfDelivery);
    }

    /**
     * Turns the Offer information to a String
     * @return String with the Offer information
     */
    @Override
    public String toString(){
        StringBuilder sb = new StringBuilder();
        sb.append("OrderID: ").append(this.orderID).append("\n")
          .append("TransportedID: ").append(this.transporterID).append("\n")
          .append("Price of Transportation: ").append(this.priceOfTransport).append("\n")
          .append("Price of Order: ").append(this.priceOfOrder).append("\n")
          .append("Time of Delivery: ").append(this.getTimeOfDelivery()).append("\n");
        return sb.toString();
    }


    /**
     * Clones the Offer
     * @return Copie of the Offer
     */
    @Override
    public Offer clone(){
        return new Offer(this);
    }

}
