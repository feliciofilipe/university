package Model;

import java.io.IOException;
import java.util.List;

public interface ProductsInterface {

    /**
     * Reads a file containing products's IDs and adds them
     * @param filePath path to the file
     * @throws IOException  If there's a problem when reading the file
     */
    void readProductsFile(String filePath) throws IOException;

    /**
     *
     * @return List of all the products' IDs
     */
     List<String> getProductsList();

    /**
     * Returns the number of products in the application
     *
     * @return number of products in the application
     */
    int getNumberOfProducts();

    /**
     * Checks if a product exists.
     * @param productID Id of product to be searched.
     * @return Boolean value indicating if product exists.
     */
    boolean constainsProduct(String productID);
}
