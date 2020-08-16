package Model;

import Utilities.Config;

import java.util.HashMap;
import java.util.Map;
import java.util.stream.Collectors;
import java.util.stream.Stream;

public class Store extends Entitie implements java.io.Serializable{

    /**
     * Requests of orders from every user
     */
    private Map<String, Map<String,Double>> _userRequests; // user,  map productName qtity

    /**
     * Store product catalog
     */
    private Map<String,Product> _productCatalog;


    /**
     * Default Constructor
     */
    public Store(){
        super();
        _userRequests = new HashMap<>();
    }

    /**
     * Parameterized Constructor
     * @param ID ID of the store
     * @param name Name of the store
     * @param email Email of the user
     * @param password Password of the user
     * @param x Coordinate X of the GPS
     * @param y Coordinate Y of the GPS
     */
    public Store(String ID, String name, String email, String password, Double x, Double y){
        super(ID,name,email,password,x,y);
        _userRequests = new HashMap<>();
        _productCatalog = new HashMap<>();
    }

    /**
     * Clone Constructor
     * @param store Class Store to be instantiated
     */
    public Store(Store store){
        super(store);
        setUserRequests(store.getUserRequests());
        setProductCatalog(store.getProductCatalog());
    }

    /**
     * Returns users requests of orders
     * @return Users requests
     */
    public Map<String,Map<String,Double>> getUserRequests(){
        Map<String,Map<String,Double>> res = new HashMap<>();
        _userRequests.forEach((key,value) -> res.put(key,new HashMap<>(value)));
        return res;
    }

    /**
     * Returns the store product catalog
     * @return Catalog of products
     */
    public Map<String,Product> getProductCatalog() {
        Map<String,Product> catalog = new HashMap<String, Product>();
        this._productCatalog.forEach((k,v) -> catalog.put(k,v.clone()));
        return catalog;
    }

    /**
     * Updates Requests of Orders
     * @param requests resquests of orders
     */
    public void setUserRequests(Map<String,Map<String,Double>> requests){
        this._userRequests = new HashMap<>();
        requests.forEach((key,value) -> _userRequests.put(key,new HashMap<>(value)));
    }

    /**
     * Updates store product catalog
     * @param catalog catalog of products
     */
    public void setProductCatalog(Map<String,Product> catalog) {
        this._productCatalog = new HashMap<String, Product>();
        catalog.forEach((k,v) -> this._productCatalog.put(k,v.clone()));
    }


    /**
     * Function that verifies if a product is present on the store catalog
     * @param productID ProductID to be verified
     * @return Boolean with the solution of the function
     */
    public boolean isProductValid(String productID){
        return this._productCatalog.containsKey(productID);
    }

    /**
     * Function that adds an user request to the orders requests of the store
     * @param userID ID of the user
     * @param userReq Request of the user
     */
    public void addUserRequest(String userID,Map <String,Double> userReq){
        this._userRequests.computeIfAbsent(userID,k -> new HashMap<>());

        this._userRequests.computeIfPresent(userID, (k,v) ->
             Stream.concat(userReq.entrySet().stream(), v.entrySet().stream())
             .collect(Collectors.toMap(
                        Map.Entry::getKey,
                        Map.Entry::getValue,
                        (value1, value2) -> value2)));
    }

    /**
     * Function that verifies if a user has an request
     * @param user Users ID
     */
    public boolean userRequestExists(String user){
        return _userRequests.containsKey(user);
    }

    /**
     * Function that cleans the request of an user
     * @param userID Users ID
     */
    public void cleanStoreOrder(String userID){
        this._userRequests.remove(userID);
    }

    /**
     * Function that verifies if a product is on the catalog
     * @param description Product to be verified
     * @return Whether the product exists or not on the catalog
     */
    public boolean productDoesNotExit(String description){
        return this._productCatalog.values().stream().noneMatch(p -> p.getDescription().equalsIgnoreCase(description));
    }

    /**
     * Function that adds a product to the catalog
     * @param product product to be added
     */
    public void addProduct(Product product){
        product.setProductID(generateProductID());
        this._productCatalog.put(product.getProductID(),product);
    }

    /**
     * Function that generates a ID for the product
     * @return String with the productID
     */
    public String generateProductID(){
        int n =  this._productCatalog.size();
        String ID = "p" + n;
        while (this._productCatalog.containsKey(ID))
            ID = "+p" + n++;
        return ID;
    }

    /**
     * Function that removes a product from the catalog
     * @param productID ID of the product
     * @return Message String
     */
    public String removeProduct(String productID){
        if(this._productCatalog.containsKey(productID)){
            this._productCatalog.remove(productID);
            return "Product removed with success";
        }
        return Config.ProductDoesntExists(productID);
    }

    /**
     * Compares an object to the Store
     * @param o Object to compare to
     * @return Whether the object and the Store are equal
     */
    @Override
    public boolean equals(Object o){
        if(this == o) return true;
        if(o == null || this.getClass() != o.getClass()) return false;
        Store store = (Store) o;
        return super.equals(store);
    }


    /**
     * Turns the Store information to a String
     * @return String with the Store information
     */
    @Override
    public String toString(){
        return super.toString();
    }


    /**
     * Clones the Store
     * @return Copie of the Store
     */
    @Override
    public Store clone(){
        return new Store(this);
    }

}

