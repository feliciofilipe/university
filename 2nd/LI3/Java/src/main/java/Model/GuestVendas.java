package Model;

import Utilities.*;

import java.io.*;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.stream.Collectors;


public class GuestVendas implements GuestVendasInterface {
    private static final long serialVersionUID = -7075554248547952933L;
    /**
     * Clients registered in the application
     */
    private ClientsInterface clients;

    /**
     * Products registered in the application
     */
    private ProductsInterface products;

    /**
     * Sales registered in the application
     */
    private SalesInterface sales;

    /**
     * Billing registered in this application
     */
    private BillingInterface billing;

    private BranchesInterface branches;

    /**
     * Path to the sales path
     */
    private String salesPath;

    /**
     * Number of invalid lines in the sales file
     */
    private int invalidSales;

    // escrever aqui a  branchInterface[] branches;
    public GuestVendas() {
        this.clients = new Clients();
        this.products = new Products();
        this.sales = new Sales();
        this.billing = new Billing();
        this.branches = new Branches(Config.numberOfBranches);
        this.salesPath = "No file read yet";
        this.invalidSales = 0;
    }

    /**
     * Loads the clients IDs from a given file
     * @param clientsPath path to the clients file
     * @throws IOException If the file can't be read
     */
    public void readClientsFile(String clientsPath) throws IOException{
        this.clients.readClientsFile(clientsPath);
    }

    /**
     * Loads the produts' IDs from a given file
     * @param productsPath path to the products file
     * @throws IOException If the file can't be read
     */
    public void readProductsFile(String productsPath) throws IOException {
        this.products.readProductsFile(productsPath);
    }

    /**
     * Reads the sales from the given files,
     * updating the sales, billing and branches structures accondingly
     *
     * @param salesPath Path to the sales file.
     * @throws IOException Happens when the file can't be accessed
     */
    @Override
    public void readSalesFile(String salesPath)
            throws IOException {
        this.salesPath =salesPath;
        this.sales = new Sales();
        this.billing = new Billing();
        this.branches = new Branches(Config.numberOfBranches);
        BufferedReader buf;
        String saleLine;
        buf = new BufferedReader(new FileReader(salesPath));
        while ((saleLine = buf.readLine()) != null) {
            String[] saleLineSplit = saleLine.split(" ");
                try {
                    String productID = saleLineSplit[0];
                    float cost = Float.parseFloat(saleLineSplit[1]);
                    int quantity = Integer.parseInt(saleLineSplit[2]);
                    String type = saleLineSplit[3];
                    String clientID = saleLineSplit[4];
                    int month = Integer.parseInt(saleLineSplit[5]);
                    int branch = Integer.parseInt(saleLineSplit[6]);
                    if (this.products.constainsProduct(productID) && this.clients.constainsClient(clientID)
                            && SaleInterface.validateSale(cost, quantity, type, month, branch)) {
                        SaleInterface sale = new Sale(productID, clientID, cost, quantity, type, month, branch);
                        this.sales.addSale(sale);
                        this.billing.updateBilling(productID, branch, month, type, quantity, cost);
                        this.branches.update(clientID, productID, branch, sale);
                    } else {
                        this.invalidSales++;
                    }
                } catch (NumberFormatException | ArrayIndexOutOfBoundsException e ) { // when the file doesn't follow the type stiplation
                    this.invalidSales++;
                }
        }
    }


    /**
     * Checks if a given product ID is registered in the application
     * @param ID to check
     * @return if it is registered
     */
    public boolean containsProduct(String ID){
        return this.products.constainsProduct(ID);
    }

    /**
     * Checks if a given client ID is registered in the application
     * @param ID to check
     * @return if it is registered
     */
    public boolean containsClient(String ID){
        return this.clients.constainsClient(ID);
    }

    /**
     * Returns the number of products in the application
     *
     * @return number of products in the application
     */
    @Override
    public int getNumberOfProducts() {
        return this.products.getNumberOfProducts();
    }

    /**
     * Returns the number of sales in the application
     *
     * @return number of sales in the application
     */
    @Override
    public int getNumberOfSales() {
        return this.sales.getNumberOfSales();
    }



    /* Statistical query 1.1 */
    /**
     *
     * @return path of the file where saled were read from
     */
    @Override
    public String getSalesPath() {
        return this.salesPath;
    }

    /**
     *
     * @return number of sales which were invalid
     */
    @Override
    public int getInvalidSales() {
        return this.invalidSales;
    }

    /**
     * @return number of diffferent products bought
     */
    @Override
    public int getNumberProductsBought() {
        return this.billing.getNumberOfProducts();
    }

    /**
     * @return number of products which weren't bought
     */
    @Override
    public int getNumberProductsNotBought() {
        return this.products.getNumberOfProducts() - this.getNumberProductsBought();
    }

    /**
     * Returns the number of products in the application
     *
     * @return number of products in the application
     */
    @Override
    public int getNumberOfClients() {
        return this.clients.getNumberOfClients();
    }


    /**
     * Returns the number of distinct clients which made purchases;
     *
     * @return number of distinct clients which made purchases
     */
    @Override
    public int getNumberOfClientsBuy() {
        return this.sales.getNumberClientsBuy();
    }

    /**
     * Returns the number of clients which didn't buy anything.
     *
     * @return number of clients which didn't buy
     */
    @Override
    public int getNumberOfClientsDidntBuy() {
        return getNumberOfClients() - getNumberOfClientsBuy();
    }

    /**
     * Returns the number of sales that costed 0
     *
     * @return number of sales which were free
     */
    @Override
    public int getNumberFreeSales() {
        return this.sales.getNumberFreeSales();
    }

    /**
     * @return total billed in the apllication
     */
    @Override
    public float getTotalBilling() {
        return this.sales.getTotalBilling();
    }


    /* statictical query  1.2 */
    @Override
    public Map<Integer, Long> getNumberSalesByMonth() {
        return this.sales.getNumberSalesByMonth();
    }

    @Override
    public Map<Integer, Map<Integer, Double>> getTotalExpenditure() {
        return this.billing.getTotalExpenditure();
    }

    @Override
    public Map<Integer, Map<Integer, Long>> getIndividualClientsBranch() {
        return this.sales.getIndividualClientsBranch();
    }


    /**
     * Lists the Ids of products which were never bought
     * @return Sorted list of users' IDs who never made a purchase
     */

    public List<String> listProductsNotBought() {
        return this.products.getProductsList()
                .stream()
                .filter(p -> !(this.billing.contains(p)))
                .sorted()
                .collect(Collectors.toList());
    }


    /**
     * Given a month, returns the number of sales in that month and the number of distinct clients who did buy.
     *
     * @param month month to filter by
     * @return Pair containig the number of sales in that month and the number of distinct clients who did buy.
     */
    @Override
    public Query2Pair salesByMonth(int month) {
        return this.sales.salesByMonth(month);
    }

    /**
     * Version that accepts a branch aswell
     *
     * @param month  month to filter by
     * @param branch branch to filter by
     * @return Pair containig the number of sales in that month and the number of distinct clients who did buy.
     */
    @Override
    public Query2Pair salesByMonth(int month, int branch) {
        return this.sales.query2(month, branch);
    }


    /**
     * Query 3
     * Given a clientID return, for each month, how many sales, how many distinct products and much was spent
     *
     * @param clientID ID of the client we are checking
     * @return Map associating each month with a structure containing the answers
     */
    @Override
    public Map<Integer, Query3Triple> distinctProductsByMonth(String clientID) {
        return this.branches.distinctProductsByMonth(clientID);
    }

    /**
     * Query 4
     * Given a product return, for each month, how many sales, how many distinct clients and much was spent
     *
     * @param productID ID of the product we are checking
     * @return Map associating each month with a structure containing the answers
     */
    @Override
    public Map<Integer, Query4Triple> distinctClientsByMonth(String productID) {
        return this.branches.distinctClientsByMonth(productID);
    }

    /**
     * Displays the products a client bought the most, in descending order.
     *
     * @param clientID Id of the client.
     * @return A map with the key being the number of times the clients bought each product show in the respective Set
     */
    @Override
    public Map<Integer, Set<String>> getClientMostBoughtProducts(String clientID) {
        return this.branches.getClientMostBoughtProducts(clientID);
    }

    /**
     * Query 6
     * Returns the n most sold products(in terms of quantity), indicating the total number of distinct clients which bought them
     * @param limit parameter deciding the size of the returned list
     * @return List of pairs (ProductID x Number of distinct clients)
     */
    @Override
    public List<Map.Entry<String, Long>> mostSoldProducts(int limit) {
        return this.sales.mostSoldProducts(limit);
    }


    /**
     * Query 7
     * Returns the list of the three biggest buyers
     *
     * @return list of IDs
     */
    @Override
    public Map<Integer, List<String>> listThreeBiggestBuyers() {
        return this.branches.listThreeBiggestBuyers();
    }

    /**
     * Query 8
     * Calculates the biggest buyers in therms of different number of products
     *
     * @param limit the number of buyers the answer should contain
     * @return ordered map correlating Users to the number of distinct products
     */
    @Override
    public List<Map.Entry<String, Long>> getBiggestDistinctBuyers(int limit) {
        return this.sales.getBiggestDistinctBuyers(limit);
    }

    /**
     * Query 9
     *
     * @return Map containing the products the client most bought, by descending order.
     * Each product is accompanied by the amount that client spent.
     */
    @Override
    public Map<Integer,Map<String,Float>> getNBiggestBuyers(String productID, int limite){
        return this.branches.getProductMostBoughtClients(productID,limite);

    }


    /**
     * Query 10
     * Get the total Expenditure of all Products by Branch and Month
     *
     * @return Two Dimensional Map with total Expenditure of all products by branch and month
     */
    @Override
    public Map<String, float[][]> getTotalExpenditureByBranchAndMonth() {
        return this.billing.getTotalExpenditureByProduct();
    }


    /**
     * Stores the current sgv object as a file
     * @param objectPath where to store the sgv
     * @throws IOException if there's a problem when storing the file
     */
    @Override
    public void saveSGVObject(String objectPath) throws IOException{
        FileOutputStream fos = new FileOutputStream(objectPath);
        BufferedOutputStream bos = new BufferedOutputStream(fos);
        ObjectOutputStream oos = new ObjectOutputStream(bos);
        oos.writeObject(this);
        oos.flush();
        oos.close();
    }
}

