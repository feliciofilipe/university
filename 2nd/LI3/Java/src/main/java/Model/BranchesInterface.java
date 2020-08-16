package Model;

import Utilities.Query4Triple;
import Utilities.Query3Triple;


import java.util.List;
import java.util.Map;
import java.util.Set;

public interface BranchesInterface {
    /**
     * Updates structure with sale record.
     * @param clientID Id of the client in the sale.
     * @param productID Id of the product in the sale.
     * @param sale Sale to be processed.
     */
     void update(String clientID, String productID,int branch,SaleInterface sale);


    /**
     * Query 3
     * Given a clientID return, for each month, how many sales, how many distinct products and much was spent
     * @param clientID ID of the client we are checking
     * @return Map associating each month with a structure containing the answers
     */
     Map<Integer, Query3Triple> distinctProductsByMonth(String clientID);

    /**
     * Qeury 4
     * Given a product return, for each month, how many sales, how many distinct clients and much was spent
     * @param producttID ID of the product we are checking
     * @return Map associating each month with a structure containing the answers
     */
     Map<Integer, Query4Triple> distinctClientsByMonth(String producttID);
    /*
     * Query 7
     * Returns the list of the three biggest buyers, for each branch
     * @return list of IDs
     */
     Map<Integer,List<String>> listThreeBiggestBuyers();

    /**
     * Query 5
     * Displays the products a client bought the most, in descending order.
     * @param clientId Id of the client.
     * @return A map with the key being the number of times the clients bought each product show in the respective Set
     */
    Map<Integer, Set<String>> getClientMostBoughtProducts(String clientId);

    /** Query 9
     * @return Map containing the products the client most bought, by descending order.
     * Each product is accompanied by the amount that client spent.
     */
     Map<Integer,Map<String,Float>> getProductMostBoughtClients(String productID, int x);
}
