package Model;

import java.io.Serializable;
import java.util.Arrays;

public class Product implements ProductInterface, Serializable {
    private static final long serialVersionUID = 4118048158171269803L;
    /**
     * Id of the product
     */
    private final String id;

    /**
     * Instantiates a product with the given ID
     * @param id ID of the product
     */
    public Product(String id) {
        this.id = id;
    }

    /**
     *  Returns the ID of the product
     * @return Id of the product
     */
    public String getId() {
        return id;
    }


    @Override
    public int hashCode(){
        return Arrays.hashCode(new Object[]{id});
    }

}
