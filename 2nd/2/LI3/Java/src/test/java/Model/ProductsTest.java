package Model;

import Utilities.Config;
import org.junit.jupiter.api.Test;

import java.io.IOException;

import static org.junit.jupiter.api.Assertions.*;

class ProductsTest {

    @Test
    void constainsProduct() throws IOException {
        Products products = new Products();
        products.readProductsFile(Config.productsPath);
        assert products.constainsProduct("AF1184");
    }
}