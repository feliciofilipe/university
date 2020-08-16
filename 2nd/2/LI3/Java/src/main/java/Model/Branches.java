package Model;

import Model.Exceptions.InexistentClientException;
import Model.Exceptions.InexistentProductException;
import Utilities.Query4Triple;
import Utilities.Query3Triple;
import Utilities.Config;

import java.io.Serializable;
import java.util.*;
import java.util.stream.Collectors;

import static java.util.stream.Collectors.*;


public class Branches implements BranchesInterface, Serializable {
    private static final long serialVersionUID = 2666225771545986413L;

    private BranchInterface[] branches;

    public Branches(int initialCapacity) {
        this.branches = new Branch[initialCapacity];
        for(int i=0; i<initialCapacity;i++){
            branches[i] = new Branch();
        }
        /*this.branches = new ArrayList<>();
        int i;
        for (i = 0; i < initialCapacity; i++) {
            BranchInterface b = new Branch();
            branches.add(b);
        }*/
    }

    /**
     * Updates structure with sale record.
     *
     * @param clientID  Id of the client in the sale.
     * @param productID Id of the product in the sale.
     * @param sale      Sale to be processed.
     */
    //TODO: mudar para receber branch
    public void update(String clientID, String productID, int branch, SaleInterface sale) {
        this.branches[branch - 1].updateBranch(clientID,productID,sale);
    }

    /**
     * // TORNAR PRIVADO
     * Merges the sales of a client in the multiple branches to a single list
     *
     * @param clientID The client of whom belong the sales being looked up
     * @return List of a client sales
     */
    private List<SaleInterface> mergeClientSales(String clientID) {
        Collection<List<SaleInterface>> col = new ArrayList<>();
        for (int branchNumber = 0; branchNumber < Config.numberOfBranches; branchNumber++) {
            try {
                col.add(this.branches[branchNumber].getSalesClient(clientID)); // if the client never bought there
            } catch (InexistentClientException ignored) {
            }
        }
        return col.stream().flatMap(List::stream).collect(Collectors.toList());
    }

    /**
     * Merges the sales of a product in the multiple branches to a single list
     *
     * @param productID The product of which belong the sales being looked up
     * @return List of a products' sales
     */
    public List<SaleInterface> mergeProductSales(String productID) {
        Collection<List<SaleInterface>> col = new ArrayList<>();
        for (int branchNumber = 0; branchNumber < Config.numberOfBranches; branchNumber++) {
            try {
                col.add(this.branches[branchNumber].getSalesProduct(productID)); // if the client never bought there
            } catch (InexistentProductException ignored) {
            }
        }
        return col.stream().flatMap(List::stream).collect(Collectors.toList());
    }



    /**
     * Query 3
     * Given a clientID return, for each month, how many sales, how many distinct products and much was spent
     *
     * @param clientID ID of the client we are checking
     * @return Map associating each month with a structure containing the answers
     */
    public Map<Integer, Query3Triple> distinctProductsByMonth(String clientID) {
        List<SaleInterface> salesList = mergeClientSales(clientID);
        // Creates a single list contraining all the sales
        Map<Integer, List<SaleInterface>> mapMonthSales = salesList.stream()
                .collect(groupingBy(SaleInterface::getMonth));

        Map<Integer, Query3Triple> mapMonthTriple = new HashMap<>();

        for(Map.Entry<Integer,List<SaleInterface>> e : mapMonthSales.entrySet()){
            int month = e.getKey();
            List<SaleInterface> listSales = e.getValue();
            int numberOfSales = listSales.size();
            int numberOfDistinctProducts = (int)listSales.stream().map(SaleInterface::getProductID).distinct().count();
            float totalExpenditure = listSales.stream()
                    .map(SaleInterface::getTotalValue).reduce((float) 0, Float::sum);
            Query3Triple q3 = new Query3Triple(numberOfSales,numberOfDistinctProducts,totalExpenditure);
            mapMonthTriple.put(month,q3);
        }
        return mapMonthTriple;
    }

    /**
     * Given a product return, for each month, how many sales, how many distinct clients and much was spent
     * @param productID ID of the product we are checking
     * @return Map associating each month with a structure containing the answers
     */
    public Map<Integer, Query4Triple> distinctClientsByMonth(String productID) {
        List<SaleInterface> salesList = mergeProductSales(productID);

        Map<Integer, List<SaleInterface>> mapMonthSales = salesList.stream()
                .collect(groupingBy(SaleInterface::getMonth));

        Map<Integer, Query4Triple> mapMonthTriple = new HashMap<>();

        for (Map.Entry<Integer, List<SaleInterface>> e : mapMonthSales.entrySet()) {
            int month = e.getKey();
            List<SaleInterface> listSales = e.getValue();
            int numberOfSales = listSales.size();
            int numberOfDistinctClients = (int) listSales.stream().map(SaleInterface::getClientID).distinct().count();
            float totalExpenditure = listSales.stream()
                    .map(SaleInterface::getTotalValue).reduce((float) 0, Float::sum);
            Query4Triple q4 = new Query4Triple(numberOfSales, numberOfDistinctClients, totalExpenditure);
            mapMonthTriple.put(month, q4);
        }
        return mapMonthTriple;
    }


    /** Query 9
     * @return Map containing the products the client most bought, by descending order.
     * Each product is accompanied by the amount that client spent.
     */
    public Map<Integer,Map<String,Float>> getProductMostBoughtClients(String productID, int x){
        List<SaleInterface> productSales = mergeProductSales(productID);
        Map<String,List<SaleInterface>> productClients =
                productSales.stream().collect(groupingBy(SaleInterface::getClientID));
        Map<Integer, Map<String,Float>> ret = new TreeMap<>(Collections.reverseOrder());
        for(Map.Entry<String,List<SaleInterface>> e : productClients.entrySet()) {
            Map<String,Float> l =
                    ret.computeIfAbsent(e.getValue().stream().
                            mapToInt(SaleInterface::getQuantity).sum(), k -> new TreeMap<>());
            for(SaleInterface e2 : e.getValue()) {
                if (l.containsKey(e2.getClientID())) l.compute(e2.getClientID(),(k,v) -> v + e2.getTotalValue());
                else l.put(e2.getClientID(),e2.getTotalValue());
            }

        }
        return ret.entrySet().stream().limit(x)
                .collect(Collectors.toMap(Map.Entry::getKey, Map.Entry::getValue,
                        (oldValue,newValue) -> oldValue, LinkedHashMap::new));
        }
    /**
     * Query 5
     * Displays the products a client bought the most, in descending order.
     * @param clientId Id of the client.
     * @return A map with the key being the number of times the clients bought each product show in the respective Set
     */
    public Map<Integer, Set<String>> getClientMostBoughtProducts(String clientId){
        List<SaleInterface> clientSales = mergeClientSales(clientId);
        Map<String,List<SaleInterface>> clientProducts = clientSales.stream()
                .collect(groupingBy(SaleInterface::getProductID));
        Map<Integer, Set<String>> ret = new TreeMap<>(Collections.reverseOrder());
        for(Map.Entry<String,List<SaleInterface>> e : clientProducts.entrySet()) {
            Set<String> products =
                    ret.computeIfAbsent(e.getValue().stream()
                                    .mapToInt(SaleInterface::getQuantity)
                                    .sum(), k -> new TreeSet<>());
            for(SaleInterface e2 : e.getValue())
                products.add(e2.getProductID());
        }
        return ret;
    }

    /*
     * Query 7
     * Returns the list of the three biggest buyers
     * @return list of IDs
     */
    public Map<Integer,List<String>> listThreeBiggestBuyers(){
        Map<Integer,List<String>> res = new HashMap<>();
        for(int branchNumber = 0; branchNumber<Config.numberOfBranches;branchNumber++){
            res.put(branchNumber,this.branches[branchNumber].listThreeBiggestBuyers());
        }
        return res;
    }
}
