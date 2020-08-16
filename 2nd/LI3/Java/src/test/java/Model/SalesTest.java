package Model;

import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.*;

class SalesTest {

    @Test
    void getNumberOfSales() {
        Sales sales = new Sales();
        Sale sale = new Sale("AA1234","A1234",1,2,"N", 1,1);
        sales.addSale(sale);
        assertEquals(sales.getNumberOfSales(),1);
    }

    @Test
    void getNumberClientsBuy() {
        Sales sales = new Sales();
        Sale sale = new Sale("AA1234","A1234",1,2,"N", 1,1);
        sales.addSale(sale);
        assertEquals(sales.getNumberClientsBuy(),1);
    }

    @Test
    void getNumberFreeSales() {
        Sales sales = new Sales();
        Sale sale = new Sale("AA1234","A1234",0,2,"N", 1,1);
        sales.addSale(sale);
        assertEquals(sales.getNumberFreeSales(),1);
    }
}