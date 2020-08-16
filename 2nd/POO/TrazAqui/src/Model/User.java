package Model;

import javax.naming.NamingEnumeration;
import java.util.*;

public class User extends Entitie implements java.io.Serializable{

    /**
     * ID of the store that the user is going to buy products
     */
    private String _storeToBuyFromID;

    /**
     * Offers of orders from different transporters
     */
    private Map<String,Map<String,Offer>> _transportOffers; //orderID (carriedID, offer)

    /**
     * Cart of the user
     */
    private Map<String,Double> _cart;

    /**
     * Desired Carrier for the orders
     */
    private String _carrier;

    /**
     * List of orders to be rated
     */
    private Set<String> _toBeRated; //orderID

    /**
     * Default Constructor
     */
    public User(){
        super();
        _storeToBuyFromID = null;
        _transportOffers = new HashMap<>();
        _cart = new HashMap<>();
        _carrier = null;
        _toBeRated = new HashSet<>();
    }

    /**
     * Parameterized Constructor
     * @param ID ID of the user
     * @param name Name of the user
     * @param email Email of the user
     * @param password Password of the user
     * @param x Coordinate X of the GPS
     * @param y Coordinate Y of the GPS
     */
    public User(String ID, String name, String email, String password, Double x, Double y){
        super(ID,name,email,password,x,y);
        _storeToBuyFromID = null;
        _transportOffers = new HashMap<>();
        _cart = new HashMap<>();
        _carrier = "Carrier";
        _toBeRated = new HashSet<>();
    }

    /**
     * Clone Constructor
     * @param user Class User to be instantiated
     */
    public User(User user){
        super(user);
        _transportOffers = new HashMap<>();
        _storeToBuyFromID = null;
        _transportOffers = new HashMap<>();
        _cart = new HashMap<>();
        _carrier = "Carrier";
        _toBeRated = new HashSet<>();
    }

    /**
     * Returns the ID of the store that the user is making the order
     * @return ID of the store
     */
    public String get_storeToBuyFromID() {
        return _storeToBuyFromID;
    }

    /**
     * TODO: Verify if it is needed
     */
    public String get_carrier() {
        return _carrier;
    }

    /**
     * Returns the list of orders to be rated
     * @return Orders to be rated
     */
    public Set<String> get_toBeRated() {
        return new HashSet<>(this._toBeRated);
    }

    /**
     * Returns the cart of products
     * @return Cart of products
     */
    public Map<String, Double> get_cart() {
        Map<String, Double> cart = new HashMap<>();
        this._cart.forEach(cart::put);
        return cart;
    }

    /**
     * Returns the offers of transporters
     * @return Offers of transporters
     */
    public Map<String,Map<String,Offer>> get_transportOffers() {
        Map<String,Map<String,Offer>> transportOffers = new HashMap<>();

        for(Map.Entry<String,Map<String,Offer>> entry : this._transportOffers.entrySet()){
            Map<String,Offer> aux = new HashMap<>();
            for(Map.Entry<String,Offer> map : entry.getValue().entrySet()){
                aux.put(map.getKey(),map.getValue().clone());
            }
            transportOffers.put(entry.getKey(),aux);
        }

        return transportOffers;

    }

    /**
     * Updates the store that the user wants to make and order
     * @param _storeToBuyFromID storeID
     */
    public void set_storeToBuyFromID(String _storeToBuyFromID) {
        this._storeToBuyFromID = _storeToBuyFromID;
    }

    /**
     * TODO: Verify if it is needed
     */
    public void set_carrier(String _carrier) {
        this._carrier = _carrier;
    }

    /**
     * Updates cart with products
     * @param cart Cart with products
     */
    public void set_cart(Map<String, Double> cart) {
        this._cart = new HashMap<>();
        cart.forEach((k,v) -> this._cart.put(k,v));
    }

    /**
     * Updates the offers of transporters
     * @param _transportOffers Offers of the transporters
     */
    public void set_transportOffers(Map<String, Map<String, Double>> _transportOffers) {
        this._transportOffers = new HashMap<>();
    }

    /**
     * Updates the list of orders to be rated
     * @param _toBeRated list of orders to be rated
     */
    public void set_toBeRated(Set<String> _toBeRated) {
        this._toBeRated = new HashSet<>(_toBeRated);
    }

    /**
     * Verifies if an order is completed to be rated
     * @param orderID ID of the order
     * @return boolean value indicating if the order belongs to the toBeRated map
     */
    public boolean isToBeRated(String orderID){
        return this._toBeRated.contains(orderID);
    }

    /**
     * Function that adds a product to a cart
     * @param description Description of the product
     * @param quantity Quantity of the product
     */
    public void addToCart(String description,Double quantity){
        if(this._cart.containsKey(description)){
            Double old_quantity = this._cart.get(description);
            this._cart.put(description,old_quantity+quantity);
        }else{
            this._cart.put(description,quantity);
        }
    }

    /**
     * Function that adds a transporter offers to the list of offers
     * @param offer ID of the order
     */
    public void addTransportOffer(Offer offer) {
        Map<String,Offer> inner_map = this._transportOffers.computeIfAbsent(offer.getOrderID(),f -> new HashMap<>());
        inner_map.put(offer.getTransporterID(), offer.clone());
        this._transportOffers.put(offer.getOrderID(),inner_map);
    }

    /**
     * Function that cleans the transporters offer
     * @param orderID ID of the order
     */
    public void cleanTransporterOffersOnOrder(String orderID){
        this._transportOffers.remove(orderID);
    }

    /**
     * Function that adds an orders to be rated
     * @param orderID ID of the order
     */
    public void addToBeRated(String orderID){
        this._toBeRated.add(orderID);
    }

    /**
     * Function that verifies if a transporter offer is already on the list of offers
     * @param transporterID Transporters ID
     * @param orderID Orders ID
     * @return Whether the offer is on the list of offers or not
     */
    public boolean containsTransportOffer(String transporterID,String orderID){
        return this._transportOffers.containsKey(orderID) && this._transportOffers.get(orderID).containsKey(transporterID);
    }

    /**
     * Function that verifies if a order is on the list of offers to be rated
     * @param orderID Orders ID
     * @return Whether the order is on the list or not
     */
    public boolean containsOrderToBeRated(String orderID){
        return this._toBeRated.contains(orderID);
    }


    /**
     * Compares an object to the User
     * @param o Object to compare to
     * @return Whether the object and the User are equal
     */
    @Override
    public boolean equals(Object o){
        if(this == o) return true;
        if(o == null || this.getClass() != o.getClass()) return false;
        User user = (User) o;
        return super.equals(user);
    }

    /**
     * Turns the User information to a String
     * @return String with the User information
     */
    @Override
    public String toString(){
        return super.toString();
    }

    @Override
    public int hashCode() {
        return super.hashCode();
    }

    /**
     * Clones the User
     * @return Copie of the User
     */
    @Override
    public User clone(){
        return new User(this);
    }
}
