package Model;

import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.*;

class SaleTest {

    @Test
    void getProductID() {
        Sale sale = new Sale("AA1234","A1234",1,2,"N", 1,1);
        assertEquals("AA1234",sale.getProductID());
    }

    @Test
    void getClientID() {
        Sale sale = new Sale("AA1234","A1234",1,2,"N", 1,1);
        assertEquals("A1234",sale.getClientID());
    }

    @Test
    void getCost() {
        Sale sale = new Sale("AA1234","A1234",1,2,"N", 1,1);
        assertEquals(1,sale.getCost());
    }

    @Test
    void getQuantity() {
        Sale sale = new Sale("AA1234","A1234",1,2,"N", 1,1);
        assertEquals(2,sale.getQuantity());
    }

    @Test
    void getType() {
        Sale sale = new Sale("AA1234","A1234",1,2,"N", 1,1);
        assertEquals("N",sale.getType());
    }

    @Test
    void getMonth() {
        Sale sale = new Sale("AA1234","A1234",1,2,"N", 1,1);
        assertEquals(1,sale.getMonth());
    }

    @Test
    void getBranch() {
        Sale sale = new Sale("AA1234","A1234",1,2,"N", 1,1);
        assertEquals(1,sale.getBranch());
    }

    @Test
    void getTotalValue() {
        Sale sale = new Sale("AA1234","A1234",1,2,"N", 1,1);
        assertEquals(1*2,sale.getTotalValue());
    }
}