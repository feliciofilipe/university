package Model;

public interface ProductInterface {

    /**
     * Returns the ID of the Product
     *
     * @return Id of the product
     */
    String getId();

    /**
     * Tests if a given ID follows the right stipulation for a product's ID
     *
     * @param id The ID to test
     * @return boolean indicating if the ID is valid
     */
     static boolean verifyId(String id) {
        return id.matches("[A-Z][A-Z][1-9][0-9][0-9][0-9]");
    }

     @Override
     int hashCode();
}
