package Model;

import Utilities.Config;

public interface SaleInterface {

    /**
     * @return ID of the product which was bought
     */
    String getProductID();

    /**
     * @return ID of the client who bought the product
     */
    String getClientID();

    /**
     * @return Amount of the produt bought
     */
    int getQuantity();

    /**
     * @return The unitary price of the product
     */
    float getCost();

    /**
     * @return If the sale was normal or discount
     */
    String getType();

    /**
     * @return Month of the sale
     */
    int getMonth();

    /**
     * @return Number of the branch in which the sale occured
     */
    int getBranch();


    /**
     *
     * @return Total value of the sale
     */
     float getTotalValue();

    /**
     *
     * @param price the price of an unit of the product bought
     * @param quantity the amount bought
     * @param type if the sale was regular or a promotion
     * @param month month of the sale
     * @param branch branch where the sale occored
     * @return boolean indicating if the sale is valid or not
     */
    static boolean validateSale(float price, int quantity, String type, int month, int branch) {
        return price >= 0 && price <= 999.99
                && quantity > 0 && quantity <=200
                && (type.equals("N") || type.equals("P"))
                && month >= Config.minMonth && month <= Config.maxMonth
                && branch >= 1 && branch <=  Config.numberOfBranches;
    }

    @Override
     int hashCode();
}
