package Products;

import Model.Product;
import Model.ProductInterface;
import Model.ProductsInterface;

import java.io.*;
import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;

public class ProductsList implements ProductsInterface, Serializable {


    private static final long serialVersionUID = 4013253435623188854L;
    /**
     * Map structure which stores Product objects where the key is their ID
     */
    public List<ProductInterface> productsCatalog;

    public ProductsList(){
        this.productsCatalog = new ArrayList<>(0);
    }

    /**
     * @param filePath Path to the folder containing the Clients information
     * @throws IOException           If there's a problem when reading the file
     */
    public void readProductsFile(String filePath)  throws IOException {
        BufferedReader inFile = new BufferedReader(new FileReader(filePath));
        String productID;
        while ((productID = inFile.readLine()) != null) {
            if (ProductInterface.verifyId(productID)) {
                ProductInterface product = new Product(productID);
                productsCatalog.add(product);
            }
        }
    }


    /**
     *  Returns the list of the products IDs
     */
    public List<String> getProductsList() {
        return this.productsCatalog.stream().map(ProductInterface::getId).collect(Collectors.toList());
    }

    /**
     * Returns the number of products in the application
     *
     * @return number of products in the application
     */
    public int getNumberOfProducts() {
        return this.productsCatalog.size();
    }


    /**
     * Checks if a product exists.
     * @param productID Id of product to be searched.
     * @return Boolean value indicating if product exists.
     */
    public boolean constainsProduct(String productID){
        for(ProductInterface p: this.productsCatalog){
            if(p.getId().equals(productID)) return true;
        }
        return false;
    }
}
