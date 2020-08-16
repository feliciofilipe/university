package Model;

import java.io.Serializable;
import java.util.*;
import java.util.stream.Collectors;

import Model.Exceptions.InexistentClientException;
import Model.Exceptions.InexistentProductException;

public class Branch implements BranchInterface, Serializable {
    private static final long serialVersionUID = -1404815402460814237L;

    /**
     * Map correlating each product with the sales in which it is envolved
     */
    private Map<String, List<SaleInterface>> products;
    /**
     * Map correlating each client with the number of sales in which it is envolved
     */
    private Map<String, List<SaleInterface>> clients;


    public Branch() {
        this.products = new HashMap<>();
        this.clients = new HashMap<>();
    }


    /**
     * Given a sale, updates the branch structure.
     *
     * @param sale Sale.
     */
    public void updateBranch(String clientID, String productID, SaleInterface sale) {
        //adicionar a hash dos products
        //cria um novo registo caso nao existir ainda a key
        List<SaleInterface> productSales = this.products.computeIfAbsent(productID, k -> new ArrayList<>());
        //adiciona Sale a lista das sales
        productSales.add(sale);
        List<SaleInterface> clientSales = this.clients.computeIfAbsent(clientID, k -> new ArrayList<>());
        //adiciona Sale a lista das sales
        clientSales.add(sale);
    }

    /**
     * Returns the list of sales of a given client in the current branch
     *
     * @param clientID The client of whom belong the sales being looked up
     * @return The list of sales of the given client
     * @throws InexistentClientException if the client never bought in this branch
     */

    public List<SaleInterface> getSalesClient(String clientID) throws InexistentClientException {
        if (this.clients.containsKey(clientID)) {
            return new ArrayList<>(clients.get(clientID));
        } else {
            throw new InexistentClientException(clientID);
        }
    }

    /**
     * Returns the list of sales of a given product in the current branch
     *
     * @param productID The product of which belong the sales being looked up
     * @return The list of sales of the given product
     * @throws InexistentProductException if the product was never bought in this branch
     */
    public List<SaleInterface> getSalesProduct(String productID) throws InexistentProductException {
        if (this.products.containsKey(productID)) {
            return new ArrayList<>(products.get(productID));
        } else {
            throw new InexistentProductException(productID);
        }
    }
        /*
         * Query 7
         * Returns the list of the three biggest buyers
         * @return list of IDs
         */
        public List<String> listThreeBiggestBuyers () {
            return this.clients.entrySet().stream()
                    .map(e -> new AbstractMap
                            .SimpleEntry<>(e.getKey(),
                            e.getValue()
                                    .stream()
                                    .map(SaleInterface::getTotalValue)
                                    .reduce((float) 0, Float::sum))
                    )
                    .sorted((e1, e2) -> (int) (e2.getValue() - e1.getValue()))
                    .map(Map.Entry::getKey)
                    .limit(3)
                    .collect(Collectors.toList());
        }

}

