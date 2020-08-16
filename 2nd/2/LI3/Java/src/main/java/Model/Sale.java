package Model;

import java.io.Serializable;
import java.util.Arrays;

public class Sale implements SaleInterface, Serializable {
    private static final long serialVersionUID = 1438415444064061994L;
    /**
     * ID of the product bought
     */
    private final String productID;
    /**
     * ID of the client who made the purchase
     */
    private final String clientID;
    /**
     * The unitary price of the product
     */
    private final float cost;
    /**\
     * Amount of the produt bought
     */
    private final int quantity;
    /**
     * If the sale was normal or discount
     */
    private final String type;
    /**
     * Month of the sale
     */
    private final int month;
    /**
     * Number of the branch in which the sale occured
     */
    private final int branch;

    /**
     *
     * @param productID ID of the product bought
     * @param clientID ID of the client who made the purchase
     * @param cost The unitary price of the product
     * @param quantity  If the sale was normal or discount
     * @param type If the sale was normal or discount
     * @param month Month of the sale
     * @param branch Number of the branch in which the sale occured
     */



    public Sale(String productID, String clientID, float cost, int quantity, String type, int month, int branch) {
        this.productID = productID;
        this.clientID = clientID;
        this.cost = cost;
        this.quantity = quantity;
        this.type = type;
        this.month = month;
        this.branch = branch;
    }

    /**
     * @return ID of the product which was bought
     */
    public String getProductID() {
        return productID;
    }

    /**
     * @return ID of the client who bought the product
     */
    public String getClientID() {
        return clientID;
    }

    /**
     * @return The unitary price of the product
     */
    public float getCost() {
        return cost;
    }

    /**
     * @return Amount of the produt bought
     */
    public int getQuantity() {
        return quantity;
    }

    /**
     * @return If the sale was normal or discount
     */
    public String getType() {
        return type;
    }

    /**
     * @return Month of the sale
     */
    public int getMonth() {
        return month;
    }

    /**
     * @return Number of the branch in which the sale occured
     */
    public int getBranch() {
        return branch;
    }

    /**
     *
     * @return Total value of the sale
     */
    public float getTotalValue(){
        return this.quantity * this.cost;
    }

    @Override
    public String toString() {
        return "Sale{" +
                "productID='" + productID +
                ", clientID='" + clientID +
                ", cost="  +
                ", quantity=" + quantity +
                ", type='" + type +
                ", month=" + month +
                ", branch=" + branch +
                '}';
    }

    @Override
    public int hashCode(){
        return Arrays.hashCode(new Object[]{productID,clientID, cost,quantity,type,month,branch });
    }
}