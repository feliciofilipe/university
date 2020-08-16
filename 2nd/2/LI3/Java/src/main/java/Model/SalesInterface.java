package Model;

import Utilities.Query2Pair;

import java.util.List;
import java.util.Map;

public interface SalesInterface {


    /**
     * @param sale sale to be added
     */
    void addSale(SaleInterface sale);

    /**
     * Returns the number of sales.
     *
     * @return Number of sales.
     */
    int getNumberOfSales();

    /**
     * query 1.1
     * @return number of distinct clients which made purchases
     */
     int getNumberClientsBuy();

    /**
     *  query 1.1
     * Returns the number of sales that costed 0
     *
     * @return number of sales which were free
     */
     int getNumberFreeSales();

    /**
     *
     * @return total billed in the apllication
     */
     float getTotalBilling();


    /**
     * Returns the number of sales which ocorred in each month
     *
     * @return map correlating the month with the number of sales
     */
    Map<Integer, Long> getNumberSalesByMonth();

    /**
     * Returns the distinct number of clients which bought in each branch, and by each month
     *
     * @return a map where the key is a number of the branch and the value is another map,
     * relating a month with the number of unique buyers
     */
     Map<Integer, Map<Integer, Long>> getIndividualClientsBranch();

    /**
     * Query 2
     * Given a month, returns the number of sales in that month and the number of distinct clients who did buy.
     * @param month month to filter by
     * @return Pair containig the number of sales in that month and the number of distinct clients who did buy.
     */
     Query2Pair salesByMonth(int month);

    /**
     * Version that accepts a branch aswell
     * @param month month to filter by
     * @param branch branch to filter by
     * @return Pair containig the number of sales in that month and the number of distinct clients who did buy.
     */
     Query2Pair query2(int month, int branch);

    /**
     * Query 6
     * Returns the n most sold products(in terms of quantity), indicating the total number of distinct clients which bought them
     * @param limit parameter deciding the size of the returned list
     * @return List of pairs (ProductID x Number of distinct clients)
     */
    List<Map.Entry<String, Long>> mostSoldProducts(int limit);

    /**
     * Query 8
     * Calculates the biggest buyers in therms of different number of products
     * @param limit the number of buyers the answer should contain
     * @return list of pairs Id x number of products Bought
     */
        List<Map.Entry<String, Long>> getBiggestDistinctBuyers(int limit);
}
