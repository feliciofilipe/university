package Model;

import Model.Exceptions.AuthenticationErrorException;

public class Product implements java.io.Serializable{

    /**
     * ID of product
     */
    private String productID;

    /**
     * Description of the product
     */
    private String description;

    /**
     * Unit price of the product
     */
    private Double price;

    /**
     * Quantity of the product
     * e.g.: a dozen eggs
     */
    private Double quantity;

    /**
     * Default Constructor
     */
    public Product() {
        this.productID = "n/a";
        this.description = "n/a";
        this.price = 0.0;
        this.quantity = 0.0;
    }

    /**
     * Parameterized Constructor
     * @param productID ID of the product
     * @param description Description of the product
     * @param price Price of the product
     * @param quantity Quantity of the product
     */
    public Product(String productID, String description, Double price,
                   Double quantity) {
        this.productID = productID;
        this.description = description;
        this.price = price;
        this.quantity = quantity;
    }

    /**
     * Clone Constructor
     * @param product Class Product to be instantiated
     */
    public Product(Product product) {
        this.productID = product.getProductID();
        this.description = product.getDescription();
        this.price = product.getPrice();
        this.quantity = product.getQuantity();
    }

    /**
     * Returns the ID of the product
     * @return ID of the product
     */
    public String getProductID() {
        return this.productID;
    }

    /**
     * Returns the ID of the product
     * @return ID of the product
     */
    public String getDescription() {
        return this.description;
    }

    /**
     * Returns the unit price of the product
     * @return Price of the product
     */
    public Double getPrice() {
        return this.price;
    }

    /**
     * Returns the quantity of the product
     * @return Quantity of the product
     */
    public Double getQuantity() {
        return this.quantity;
    }

    /**
     * Updates the ID of the product
     * @param productID ID of the product
     */
    public void setProductID(String productID) {
        this.productID = productID;
    }

    /**
     * Updates the description of the product
     * @param description Description of the product
     */
    public void setDescription(String description) {
        this.description = description;
    }

    /**
     * Updates the unit price of the product
     * @param price Price of a product
     */
    public void setPrice(Double price) {
        this.price = price;
    }

    /**
     * Updates the quantity of the product
     * @param quantity Quantity of a product
     */
    public void setQuantity(Double quantity) {
        this.quantity = quantity;
    }

    /**
     * Calculates the total price of the product
     * @return Global price of the Model.Product
     */
    public double TotalPrice() {
        return this.quantity * this.price;
    }

    /**
     * Compares an object to the Product
     * @param obj Object to compare to
     * @return Whether the object and the Product are equal
     */
    @Override
    public boolean equals(Object obj) {
        if(obj==this) return true;
        if(obj==null || obj.getClass() != this.getClass()) return false;
        Product product = (Product) obj;
        return  product.getProductID().equals(this.productID) &&
                product.getDescription().equals(this.description) &&
                product.getPrice() == this.price;
    }

    /**
     * Turns the Product information to a String
     * @return String with the Product information
     */
    @Override
    public String toString() {
        StringBuilder sb = new StringBuilder();
        sb.append("Product ID: ").append(this.productID).append(", ")
          .append("Description: ").append(this.description).append(", ")
          .append("Price: ").append(this.price).append(", ")
          .append("Quantity: ").append(this.quantity).append(", ");
        return sb.toString();
    }

    /**
     * Clones the Product
     * @return Copie of the Product
     */
    @Override
    public Product clone() {
        return new Product(this);
    }
}