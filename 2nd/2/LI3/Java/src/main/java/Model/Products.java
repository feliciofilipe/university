package Model;

import java.io.*;

import java.util.*;

public class Products implements ProductsInterface, Serializable {

    private static final long serialVersionUID = 638386610450805964L;

    /**
     * Map structure which stores Product objects where the key is their ID
     */
    public Map<String, ProductInterface> productsCatalog;


    public Products(){
        this.productsCatalog = new Hashtable<>();
    }

    /**
     * @param filePath Path to the folder containing the Clients information
     * @throws FileNotFoundException If the given file is not found
     */
    public void readProductsFile(String filePath) throws IOException{
        BufferedReader inFile = new BufferedReader(new FileReader(filePath));
        String productID;
        while ((productID = inFile.readLine()) != null) {
            if (ProductInterface.verifyId(productID)) {
                ProductInterface product = new Product(productID);
                productsCatalog.put(productID, product);
            }
        }
    }


    /**
     *
     */
    public List<String> getProductsList() {
        return new ArrayList<>(this.productsCatalog.keySet());
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
        return this.productsCatalog.containsKey(productID);
    }

}