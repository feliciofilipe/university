package Model;


import java.util.HashMap;
import java.util.Map;

public class Order implements java.io.Serializable{

    /**
     * Id of the order
     */
    private String orderID;

    /**
     * Id of the user that made the order
     */
    private String userID;

    /**
     * Id of the store
     */
    private String storeID;

    /**
     * Id of the carrier
     */
    private String carrierID;

    /**
     * Weight of the order
     */
    private Double weight;

    /**
     * List of Products ordered
     */
    private Map<String,Product> productList;

    /**
     * Default Constructor
     */
    public Order(){
        this.orderID = "n/a";
        this.userID = "n/a";
        this.storeID = "n/a";
        this.carrierID = "n/a";
        this.weight = 0.0;
        this.productList = new HashMap<String,Product>();
    }

    /**
     * Parameterized Constructor
     * @param orderID OrderID
     * @param userID UserID of the order
     * @param storeID StoreID of the order
     * @param weight Weight of the order
     * @param productList Products of an order
     */
    public Order(String orderID, String userID,
                 String storeID, Double weight,
                 Map<String,Product> productList){
        this.orderID = orderID;
        this.userID = userID;
        this.storeID = storeID;
        this.weight = weight;
        this.carrierID = null;
        setProductList(productList);
    }

    /**
     * Clone Constructor
     * @param order Class Order to be instantiated
     */
    public Order(Order order){
        this.orderID = order.getOrderID();
        this.userID = order.getUserID();
        this.storeID = order.getStoreID();
        this.weight = order.getWeight();
        this.carrierID = order.getCarrierID();
        setProductList(order.getProductList());
    }

    /**
     * Function that return the orderID of an order
     * @return OrderID
     */
    public String getOrderID() {
        return orderID;
    }

    /**
     * Function that return the userID of an order
     * @return UserID of the order
     */
    public String getUserID() {
        return userID;
    }

    /**
     * Function that return the storeID of an order
     * @return StoreID of the order
     */
    public String getStoreID() {
        return storeID;
    }

    /**
     * Function that return the carrierID of an order
     * @return CarrierID of the order
     */
    public String getCarrierID() {
        return carrierID;
    }

    /**
     * Function that return the weight of an order
     * @return Weight of the order
     */
    public double getWeight() {
        return weight;
    }

    /**
     * Function that return the productList of an order
     * @return ProductList of the order
     */
    public HashMap<String,Product> getProductList(){
        HashMap<String,Product> map = new HashMap<>();
        this.productList.forEach((k,v) -> map.put(k,v.clone()));
        return map;
    }

    /**
     * Updates the OrderID of the entity
     * @param orderID New orderID of the order
     */
    public void setOrderID(String orderID) {
        this.orderID = orderID;
    }

    /**
     * Updates the userID of the entity
     * @param userID New userID of the order
     */
    public void setUserID(String userID) {
        this.userID = userID;
    }

    /**
     * Updates the storeID of the entity
     * @param storeID New storeID of the order
     */
    public void setStoreID(String storeID) {
        this.storeID = storeID;
    }

    /**
     * Updates the weight of the entity
     * @param weight New weight of the order
     */
    public void setWeight(Double weight) {
        this.weight = weight;
    }

    public void setCarrierID(String carrierID) {
        this.carrierID = carrierID;
    }

    /**
     * Updates the list of products of the entity
     * @param map New productList of the order
     */
    public void setProductList(Map<String,Product> map) {
        this.productList = new HashMap<String, Product>();
        map.forEach((k,v) -> this.productList.put(k,v.clone()));
    }

    /**
     * Calculates the total cost of an order
     * @return the total cost of an order
     */
    public double getOrderTotalValue(){
        return this.productList.values().stream().map(p -> p.getPrice()).reduce(0.0,(a,c) -> a+c);
    }

    /**
     * Verifies if the order is available dor delivery
     * @return Availability of a order
     */
    public boolean isAvailableForDelivery(){
        return (this.carrierID == null);
    }

    /**
     * Compares an object to the Order
     * @param obj Object to compare to
     * @return Whether the object and the Order are equal
     */
    @Override
    public boolean equals(Object obj){
        if(this == obj) return true;
        if(obj == null || this.getClass() != obj.getClass()) return false;
        Order order = (Order) obj;
        return  order.getOrderID().equals(this.orderID) &&
                order.getUserID().equals(this.userID) &&
                order.getStoreID().equals(this.storeID) &&
                order.getWeight() == this.weight &&
                order.getProductList().equals(this.productList);
    }


    /**
     * Turns the Order information to a String
     * @return String with the Order information
     */
    @Override
    public String toString(){
        StringBuilder sb = new StringBuilder();

        sb.append("\nOrder ID: ").append(this.orderID).append("\n")
                .append("User ID: ").append(this.userID).append("\n")
                .append("Store ID: ").append(this.storeID).append("\n")
                .append("Weight: ").append(this.weight).append("\n")
                .append("Product List: \n");

                this.productList.forEach((key,value) -> sb.append(value.toString()).append("\n"));

        return sb.toString();
    }

    /**
     * Clones an Order
     * @return Returns an Order cloned
     */
    @Override
    public Order clone(){
        return new Order(this);
    }
}
