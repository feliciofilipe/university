package Model;

import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.*;

class ProductTest {

    @Test
    void getId() {
        String expected = "AA1234";
        Product product = new Product(expected);
        String actual = product.getId();
        assertEquals(expected,actual);
    }
}