package Model;

import Controller.InteractiveController;

import java.awt.geom.Point2D;

public class Transporter extends Carrier implements java.io.Serializable {

    /**
     * TIN ("NIF") of the transporter
     */
    private String TIN;

    /**
     * Free to be payed per kilometer
     */
    private Double fee;

    /**
     * Maximum number of orders that a transporter can transport
     */
    private Integer maxOrders;

    /**
     * Total numbers of deliveries
     */
    private Integer _noDeliveringOrders;

    /**
     * Default Constructor
     */
    public Transporter(){
        super();
        this.TIN = "n/a";
        this.fee = 0.0;
        this.maxOrders = 0;
        this._noDeliveringOrders = 0;
    }

    /**
     * Parameterized Constructor
     * @param ID ID of the transporter
     * @param name Name of the transporter
     * @param email Email of the user
     * @param password Password of the user
     * @param x Coordinate X of the GPS
     * @param y Coordinate Y of the GPS
     * @param radius Radius of distance that the transporter can deliver
     * @param TIN TIN ("NIF") of the transporter
     * @param fee Fee that the transporter charge per kilometer
     * @param maxOrders Maximum number that the transporter can deliver
     */
    public Transporter(String ID, String name, String email, String password,Double x, Double y,Double radius,String TIN,Double fee,Integer maxOrders){
        super(ID,name,email,password,x,y,radius);
        this.TIN = TIN;
        this.fee = fee;
        this.maxOrders = maxOrders;
        this._noDeliveringOrders = 0;
    }

    /**
     * Clone Constructor
     * @param transporter Class Transporter to be instantiated
     */
    public Transporter(Transporter transporter){
        super(transporter);
        this.TIN = transporter.getTIN();
        this.fee = transporter.getFee();
        this.maxOrders = transporter.getMaxOrders();
        this._noDeliveringOrders = transporter.get_noDeliveringOrders();
    }

    /**
     * Returns the TIN ("NIF") of the transporter
     * @return TIN ("NIF") of the transporter
     */
    public String getTIN(){
        return this.TIN;
    }

    /**
     * Returns the fee charged by the transporter
     * @return Fee charged
     */
    public Double getFee(){
        return this.fee;
    }

    /**
     * Return the maximum number of orders that a transporter can transport
     * @return Number of maximum orders
     */
    public Integer getMaxOrders() {
        return maxOrders;
    }

    /**
     * Return the number of deliveries made from a transporter
     * @return Number of deliveries made
     */
    public Integer get_noDeliveringOrders() {
        return _noDeliveringOrders;
    }

    /**
     * Updates the TIN ("NIF") of the transporter
     * @param TIN New TIN ("NIF") of the transporter
     */
    public void setTIN(String TIN) {
        this.TIN = TIN;
    }

    /**
     * Updates the fee of the transporter
     * @param fee New fee of the tansporter
     */
    public void setFee(double fee) {
        this.fee = fee;
    }

    /**
     * Updates the maximu, number of orders of the transporter
     * @param maxOrders New maximum number of orders of the tansporter
     */
    public void setMaxOrders(Integer maxOrders) {
        this.maxOrders = maxOrders;
    }

    /**
     * Updates the number of deliveries
     * @param _noDeliveringOrders New number of deliveries of the tansporter
     */
    public void set_noDeliveringOrders(Integer _noDeliveringOrders) {
        this._noDeliveringOrders = _noDeliveringOrders;
    }

    /**
     * Function that calculates the price of transportation of a order
     * @param userGPS GPS of the user
     * @param storeGPS GPS of the store
     * @return Price of transportation
     */
    public Double getPriceForOrder(Point2D userGPS, Point2D storeGPS){
        Point2D center = this.getGPS();
        return (center.distance(storeGPS) + storeGPS.distance(userGPS)) * this.fee;
    }

    /**
     * Compares an object to the Transporter
     * @param obj Object to compare to
     * @return Whether the object and the Transporter are equal
     */
    @Override
    public boolean equals(Object obj){
        if(this == obj) return true;
        if(obj == null || this.getClass() != obj.getClass()) return false;
        Transporter transporter = (Transporter) obj;
        return super.equals(transporter) &&
               transporter.getTIN().equals(this.TIN) &&
               transporter.getFee() == this.fee;
    }

   /**
    * Turns the Transporter information to a String
    * @return String with the Transporter information
    */
   @Override
   public String toString(){
        StringBuilder sb = new StringBuilder();
        sb.append(super.toString())
          .append("TIN: ").append(this.TIN).append("\n")
          .append("Fee: ").append(this.fee).append("\n")
          .append("MaxOrders: ").append(this.maxOrders).append("\n");
        return sb.toString();
   }


    /**
     * Clones the Transporter
     * @return Copie of the Transporter
     */
    @Override
    public Transporter clone(){
        return new Transporter(this);
    }

}
