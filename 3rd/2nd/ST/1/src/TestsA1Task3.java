import static org.junit.Assert.assertEquals;

import org.junit.*;
import static org.junit.Assert.*;

public class TestsA1Task3 {
	VendingMachine vm;

    @Before
    public void setVendingMachine(){
        this.vm = new VendingMachine();
    }
    
    @Test
    public void testCalculateChange(){
        assertEquals(vm.calculateChange(vm.colaPrice,"TE TE OE FC"), 3,0);
    }
    
    @Test
    public void testCalculateChange1(){
        assertEquals(vm.calculateChange(vm.coffeePrice,"TE TE TC"),1,2);
    }
    
    @Test
    public void testCalculateChange2(){
        assertEquals(vm.calculateChange(vm.fantaPrice,"TE TE TE"),1,0);
    }
    
    @Test
    public void testCalculateChange3(){
        //assertEquals(vm.calculateChange(vm.fantaPrice,"PE"),0.0);
    }
}