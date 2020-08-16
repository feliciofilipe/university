package Model;

import Utilities.Query2Pair;
import Utilities.Query3Triple;
import Utilities.Query4Triple;

import java.io.*;
import java.util.List;
import java.util.Map;
import java.util.Set;

public interface GuestVendasInterface extends Serializable {
    /**
     * Loads a SGV object from the given path
     *
     * @param objectPath path were the object file is stored to be loaded
     * @return SGV object that was stored in the file
     * @throws IOException            in case there's a problem reading the object file
     * @throws ClassNotFoundException in case the file does not contain the correct class
     */
    static GuestVendasInterface loadSGVObject(String objectPath) throws IOException, ClassNotFoundException {
        FileInputStream fis = new FileInputStream(objectPath);
        BufferedInputStream bif = new BufferedInputStream(fis);
        ObjectInputStream ois = new ObjectInputStream(bif);
        GuestVendasInterface guestVendasInterface = (GuestVendasInterface) ois.readObject();
        ois.close();
        return guestVendasInterface;
    }

    /**
     * Loads the clients IDs from a given file
     *
     * @param clientsPath path to the clients file
     * @throws IOException If the file can't be read
     */
     void readClientsFile(String clientsPath) throws IOException;

    /**
     * Loads the produts' IDs from a given file
     * @param productsPath path to the products file
     * @throws IOException If the file can't be read
     */
     void readProductsFile(String productsPath) throws IOException;

    /**
     * Reads the sales from the given files,
     * updating the sales, billing and branches structures accondingly
     *
     * @param salesPath Path to the sales file.
     * @throws IOException Happens when the file can't be accessed
     */
    void readSalesFile(String salesPath) throws IOException;

    /**
     * Checks if a given product ID is registered in the application
     * @param ID to check
     * @return if it is registered
     */
    boolean containsProduct(String ID);

    /**
     * Checks if a given client ID is registered in the application
     * @param ID to check
     * @return if it is registered
     */
    boolean containsClient(String ID);

    /**
     * Returns the number of products in the application
     *
     * @return number of products in the application
     */
    int getNumberOfProducts();

    /**
     * Returns the number of sales in the application
     *
     * @return number of sales in the application
     */
    int getNumberOfSales();

    /**
     * @return path of the file where saled were read from
     */
    String getSalesPath();

    /**
     * @return number of sales which were invalid
     */
    int getInvalidSales();

    /**
     * @return number of diffferent products bought
     */
    int getNumberProductsBought();

    /**
     * @return number of products which weren't bought
     */
    int getNumberProductsNotBought();

    /**
     * Returns the number of products in the application
     *
     * @return number of products in the application
     */
    int getNumberOfClients();

    /**
     * Returns the number of distinct clients which made purchases;
     *
     * @return number of distinct clients which made purchases
     */
    int getNumberOfClientsBuy();

    /**
     * Returns the number of clients which didn't buy anything.
     *
     * @return number of clients which didn't buy
     */
    int getNumberOfClientsDidntBuy();

    /**
     * Returns the number of sales that costed 0
     *
     * @return number of sales which were free
     */
    int getNumberFreeSales();

    /**
     * @return total billed in the apllication
     */
    float getTotalBilling();

    /* statictical query  1.2 */
    Map<Integer, Long> getNumberSalesByMonth();

    Map<Integer, Map<Integer, Double>> getTotalExpenditure();

    Map<Integer, Map<Integer, Long>> getIndividualClientsBranch();

    /**
     * Lists the Ids of products which were never bought
     *
     * @return Sorted list of users' IDs who never made a purchase
     */
    List<String> listProductsNotBought();

    /**
     * Given a month, returns the number of sales in that month and the number of distinct clients who did buy.
     *
     * @param month month to filter by
     * @return Pair containig the number of sales in that month and the number of distinct clients who did buy.
     */
    Query2Pair salesByMonth(int month);

    /**
     * Version that accepts a branch aswell
     *
     * @param month  month to filter by
     * @param branch branch to filter by
     * @return Pair containig the number of sales in that month and the number of distinct clients who did buy.
     */
    Query2Pair salesByMonth(int month, int branch);

    /**
     * Query 3
     * Given a clientID return, for each month, how many sales, how many distinct products and much was spent
     *
     * @param clientID ID of the client we are checking
     * @return Map associating each month with a structure containing the answers
     */
    Map<Integer, Query3Triple> distinctProductsByMonth(String clientID);

    /**
     * Query 4
     * Given a product return, for each month, how many sales, how many distinct clients and much was spent
     *
     * @param productID ID of the product we are checking
     * @return Map associating each month with a structure containing the answers
     */
    Map<Integer, Query4Triple> distinctClientsByMonth(String productID);

    /**
     * Query 5
     * Displays the products a client bought the most, in descending order.
     *
     * @param clientID Id of the client.
     * @return A map with the key being the number of times the clients bought each product show in the respective Set
     */
    Map<Integer, Set<String>> getClientMostBoughtProducts(String clientID);

    /**
     * Query 6
     * Returns the n most sold products(in terms of quantity), indicating the total number of distinct clients which bought them
     *
     * @param limit parameter deciding the size of the returned list
     * @return List of pairs (ProductID x Number of distinct clients)
     */
    List<Map.Entry<String, Long>> mostSoldProducts(int limit);

    /**
     * Query 7
     * Returns the list of the three biggest buyers
     *
     * @return list of IDs
     */
    Map<Integer, List<String>> listThreeBiggestBuyers();

    /**
     * Query 8
     * Calculates the biggest buyers in therms of different number of products
     *
     * @param limit the number of buyers the answer should contain
     * @return ordered map correlating Users to the number of distinct products
     */
    List<Map.Entry<String, Long>> getBiggestDistinctBuyers(int limit);

    /**
     * Query 9
     * Given a products's ID returns the N biggest buyers
     *
     * @return Map containing the products the client most bought, by descending order.
     * Each product is accompanied by the amount that client spent.
     */
    Map<Integer, Map<String, Float>> getNBiggestBuyers(String productID, int limite);

    /**
     * Query 10
     * Get the total Expenditure of all Products by Branch and Month
     *
     * @return Two Dimensional Map with total Expenditure of all products by branch and month
     */
    Map<String, float[][]> getTotalExpenditureByBranchAndMonth();

    /**
     * Stores the current sgv object as a file
     *
     * @param objectPath where to store the sgv
     * @throws IOException if there's a problem when storing the file
     */
    void saveSGVObject(String objectPath) throws IOException;
}
