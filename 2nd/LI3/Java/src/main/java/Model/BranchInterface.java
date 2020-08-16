package Model;

import Model.Exceptions.InexistentClientException;
import Model.Exceptions.InexistentProductException;

import java.util.List;

public interface BranchInterface {
    /**
     * Given a sale, updates the branch structure.
     * @param sale Sale.
     */
     void updateBranch(String clientID, String productID, SaleInterface sale) ;

    /**
     * Returns the list of sales of a given client in the current branch
     * @param clientID The client of whom belong the sales being looked up
     * @return The list of sales of the given client
     */
     List<SaleInterface> getSalesClient(String clientID) throws InexistentClientException;

    /**
     * Returns the list of sales of a given product in the current branch
     * @param productID The product of which belong the sales being looked up
     * @return The list of sales of the given product
     * @throws InexistentProductException if the product was never bought in this branch
     */
     List<SaleInterface> getSalesProduct(String productID) throws InexistentProductException;

     /* Query 7
     * Returns the list of the three biggest buyers
     * @return list of IDs
     */
     List<String> listThreeBiggestBuyers();
}





