package Sales;

import Model.SaleInterface;
import Model.SalesInterface;
import Utilities.Query2Pair;

import java.io.Serializable;
import java.util.*;
import java.util.stream.Collectors;

public class SalesLinkedList implements SalesInterface, Serializable {


    private static final long serialVersionUID = 1475871832758514231L;
    /**
     * List of all the application's sales
     */
    public List<SaleInterface> salesList;

    /**
     * Instanciates a new sales structure
     */
    public SalesLinkedList() {
        this.salesList = new LinkedList<>();
    }

    /**
     * @param sale sale to be added
     */
    public void addSale(SaleInterface sale) {
        this.salesList.add(sale);
    }

    /**
     * Returns the number of sales.
     *
     * @return Number of sales.
     */
    public int getNumberOfSales() {
        return salesList.size();
    }


    /**
     *
     * @return number of distinct clients which made purchases
     */
    public int getNumberClientsBuy(){
        return  (int)this.salesList.stream()
                .map(SaleInterface::getClientID)
                .distinct()
                .count();
    }

    /**
     * Returns the number of sales that costed 0
     *
     * @return number of sales which were free
     */
    public int getNumberFreeSales(){
        return (int)this.salesList.stream()
                .filter(s-> s.getCost()==0).count();
    }

    /**
     *
     * @return total billed in the apllication
     */
    public float getTotalBilling(){
        return this.salesList.stream()
                .map(SaleInterface::getTotalValue)
                .reduce((float) 1, Float::sum);
    }

    /**
     * Returns the number of sales which ocorred in each month
     *
     * @return map correlating the month with the number of sales
     */
    public Map<Integer, Long> getNumberSalesByMonth() {
        return this.salesList.stream()
                .collect(Collectors.groupingBy(SaleInterface::getMonth, Collectors.counting()));
    }

    /**
     * Returns the distinct number of clients which bought in each branch, and by each month
     *
     * @return a map where the key is a number of the branch and the value is another map,
     * relating a month with the number of unique buyers
     */
    public Map<Integer, Map<Integer, Long>> getIndividualClientsBranch() {
        return this.salesList.stream()
                // collects to a Map<BranchId,List of sales in that branch> (Map<Integer,List<SaleInterface>)
                .collect(Collectors.groupingBy(SaleInterface::getBranch))
                .entrySet()
                .stream()
                //collects to a map where the key is the branch
                .collect(Collectors.toMap(
                        Map.Entry::getKey,
                        //List of sales in a given branch
                        e1 -> e1.getValue()
                                .stream()
                                // collects to a map where the key is the month and the value is the list of sales in that month (and in that branch)
                                .collect(Collectors.groupingBy(SaleInterface::getMonth))
                                .entrySet()
                                .stream()
                                .collect(Collectors.toMap(
                                        Map.Entry::getKey,
                                        e2 -> e2.getValue()
                                                .stream()
                                                .map(SaleInterface::getClientID)
                                                .distinct()
                                                .count()
                                        )
                                )
                        )
                );
    }


    /**
     * Query 2
     * Given a month, returns the number of sales in that month and the number of distinct clients who did buy.
     * @param month month to filter by
     * @return Pair containig the number of sales in that month and the number of distinct clients who did buy.
     */
    public Query2Pair salesByMonth(int month){
        List<SaleInterface> listFilteredSales = this.salesList.stream()
                .filter(s->s.getMonth()==month).collect(Collectors.toList());

        return new Query2Pair(listFilteredSales.size(),
                (int)listFilteredSales.stream().map(SaleInterface::getClientID).distinct().count());
    }

    /**
     * Version that accepts a branch aswell
     * @param month month to filter by
     * @param branch branch to filter by
     * @return Pair containig the number of sales in that month and the number of distinct clients who did buy.
     */
    public Query2Pair query2(int month, int branch){
        List<SaleInterface> listFilteredSales = this.salesList.stream()
                .filter(s->s.getMonth()==month && s.getBranch()==branch).collect(Collectors.toList());

        return new Query2Pair(listFilteredSales.size(),
                (int)listFilteredSales.stream().map(SaleInterface::getClientID).distinct().count());
    }

    /**
     * Returns the n most sold products(in terms of quantity), indicating the total number of distinct clients which bought them
     * @param limit parameter deciding the size of the returned list
     * @return List of pairs (ProductID x Number of distinct clients)
     */
    public List<Map.Entry<String, Long>> mostSoldProducts(int limit){

        Map<String,List<SaleInterface>> mapByProduct = this.salesList.stream().collect(Collectors.groupingBy(SaleInterface::getProductID));

        Comparator<List<SaleInterface>> salesListQuantityComparator2 =
                (l1, l2) -> Integer.compare(l2.stream().mapToInt(SaleInterface::getQuantity).sum(),
                        l1.stream().mapToInt(SaleInterface::getQuantity).sum());

        List<Map.Entry<String,List<SaleInterface>>> l = new ArrayList<>(mapByProduct.entrySet());
        l.sort(Map.Entry.comparingByValue(salesListQuantityComparator2));

        return l.stream()
                //.map(e -> new Query6Pair(e.getKey(),(int)e.getValue().stream().map(SaleInterface::getClientID)
                .map(e -> new AbstractMap
                        .SimpleEntry<>(e.getKey(),
                        e.getValue()
                                .stream()
                                .map(SaleInterface::getClientID)
                                .distinct().count()))
                .limit(limit)
                .collect(Collectors.toList());

    }

    /**
     * Query 8
     * Calculates the biggest buyers in therms of different number of products
     * @param limit the number of buyers the answer should contain
     * @return List of pairs (ClientId x Number of different Products)
     */
    public List<Map.Entry<String, Long>> getBiggestDistinctBuyers(int limit){
        return this.salesList.stream()
                .collect(Collectors.groupingBy(SaleInterface::getClientID))
                .entrySet().stream()
                .map(e -> new AbstractMap
                        .SimpleEntry<>(e.getKey(),
                        e.getValue()
                                .stream()
                                .map(SaleInterface::getProductID)
                                .distinct()
                                .count()
                )).sorted((e1, e2) -> (e2.getValue().compareTo(e1.getValue())))
                .limit(limit)
                .collect(Collectors.toList());
    }
}
