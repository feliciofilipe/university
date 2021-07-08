import org.junit.*;
import static org.junit.Assert.*;

import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
import java.io.PrintStream;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;

public class TestsA1Task1 {

    VendingMachine vm;
    
    Map<String,Double> prices;

    @Before
    public void setVendingMachine(){
        this.vm = new VendingMachine();
        this.prices = new HashMap<String, Double>();
        prices.put("COLA", vm.colaPrice);
        prices.put("COFFEE", vm.colaPrice);
        prices.put("FANTA", vm.colaPrice);
    }
    
    @Test
    public void testGetColaCount() {
    	assertEquals(5,vm.getColaCount());
    }
    
    @Test
    public void testGetCoffeeCount() {
    	assertEquals(5,vm.getCoffeeCount());
    }

    
    @Test
    public void testGetFantaCount() {
    	assertEquals(5,vm.getFantaCount());
    }


    @Test
    public void testCalculateReturningCoins(){
        assertArrayEquals(vm.calculateReturningCoins(0.2),new int[]{0,0,0,1});
        assertArrayEquals(vm.calculateReturningCoins(0.4),new int[]{0,0,0,2});
        assertArrayEquals(vm.calculateReturningCoins(0.5),new int[]{0,0,1,0});
        assertArrayEquals(vm.calculateReturningCoins(0.6),new int[]{0,0,0,3});
        assertArrayEquals(vm.calculateReturningCoins(0.7),new int[]{0,0,1,1});
        assertArrayEquals(vm.calculateReturningCoins(0.8),new int[]{0,0,0,4});
        assertArrayEquals(vm.calculateReturningCoins(0.9),new int[]{0,0,1,2});
        assertArrayEquals(vm.calculateReturningCoins(1.0),new int[]{0,1,0,0});
        assertArrayEquals(vm.calculateReturningCoins(1.1),new int[]{0,0,1,3});
        assertArrayEquals(vm.calculateReturningCoins(1.2),new int[]{0,1,0,1});
        assertArrayEquals(vm.calculateReturningCoins(1.3),new int[]{0,0,1,4});
        assertArrayEquals(vm.calculateReturningCoins(1.4),new int[]{0,0,0,1});
        assertArrayEquals(vm.calculateReturningCoins(1.5),new int[]{0,1,1,0});
        assertArrayEquals(vm.calculateReturningCoins(1.6),new int[]{0,1,0,3});
        assertArrayEquals(vm.calculateReturningCoins(1.7),new int[]{0,1,1,1});
        assertArrayEquals(vm.calculateReturningCoins(1.8),new int[]{0,1,0,4});
        assertArrayEquals(vm.calculateReturningCoins(1.9),new int[]{0,1,1,2});
        assertArrayEquals(vm.calculateReturningCoins(2.0),new int[]{1,0,0,0});
        assertArrayEquals(vm.calculateReturningCoins(2.1),new int[]{0,1,1,3});
        assertArrayEquals(vm.calculateReturningCoins(2.2),new int[]{1,0,0,1});
        assertArrayEquals(vm.calculateReturningCoins(2.3),new int[]{0,1,1,4});
        assertArrayEquals(vm.calculateReturningCoins(2.4),new int[]{1,0,0,2});
        assertArrayEquals(vm.calculateReturningCoins(2.5),new int[]{1,0,1,0});
        assertArrayEquals(vm.calculateReturningCoins(2.6),new int[]{1,0,0,3});
        assertArrayEquals(vm.calculateReturningCoins(2.7),new int[]{1,0,1,1});
        assertArrayEquals(vm.calculateReturningCoins(2.8),new int[]{1,0,0,4});
        assertArrayEquals(vm.calculateReturningCoins(2.9),new int[]{1,0,1,2});
        assertArrayEquals(vm.calculateReturningCoins(3.0),new int[]{2,1,0,0});
        assertArrayEquals(vm.calculateReturningCoins(4.0),new int[]{2,0,0,0});
        assertArrayEquals(vm.calculateReturningCoins(5.0),new int[]{2,1,0,0});
    }

    @Test
    public void testCalculateChange(){
        assertEquals(vm.calculateChange(vm.colaPrice,"TE TE"), 1.5,0);
        assertEquals(vm.calculateChange(vm.coffeePrice,"TE TE"),1,0);
        assertEquals(vm.calculateChange(vm.fantaPrice,"TE TE TE"),1,0);
    }

    @Test
    public void testProcessSelection() {
        String NLC = System.getProperty("line.separator");
        ArrayList<String> drinks = new ArrayList<>();
        drinks.add("COLA");
        drinks.add("COLA");
        drinks.add("COLA");
        drinks.add("COLA");
        drinks.add("COFFEE");
        drinks.add("COFFEE");
        drinks.add("COFFEE");
        drinks.add("COFFEE");
        drinks.add("FANTA");
        drinks.add("FANTA");
        drinks.add("FANTA");
        drinks.add("FANTA");
        drinks.forEach(drink -> auxTestProcessSelection(drink,"DRINK DELIVERED, Thank you for your business, see you again!"+NLC+NLC+NLC+NLC));
        auxTestProcessSelection("COLA", "We ran out of COLA. Please order a different drink \n \n");
        auxTestProcessSelection("COFFEE", "We ran out of COFFEE. Please order a different drink \n \n");
        auxTestProcessSelection("FANTA", "We ran out of FANTA. Please order a different drink \n \n");
    }

    private void auxTestProcessSelection(String drink, String desiredOutput){
        ByteArrayOutputStream newout = new ByteArrayOutputStream();
        System.setOut(new PrintStream(newout));

        ByteArrayInputStream input = new ByteArrayInputStream(("TE TE TE TE TE TE").getBytes());

        System.setIn(input);
        vm.processSelection(drink);
        String realOutput = newout.toString();

        System.setIn(System.in);
        System.setOut(System.out);
        assertTrue(realOutput.contains(desiredOutput));
    }
    
    @Test
    public void testCaptureMoney() {
    	auxTestCaptureMoney("COLA","TE TE TE TE TE",true);
    	auxTestCaptureMoney("COFFEE","TE TE TE TE TE",true);
    	auxTestCaptureMoney("FANTA","TE TE TE TE TE",true);
    	auxTestCaptureMoney("COLA","CANCEL",false);
    	auxTestCaptureMoney("COFFEE","CANCEL",false);
    	auxTestCaptureMoney("FANTA","CANCEL",false);
    }
    
    private void auxTestCaptureMoney(String drink, String coins, boolean desiredOutput){
        ByteArrayInputStream input = new ByteArrayInputStream((coins).getBytes());
        System.setIn(input);
        boolean realOutput = vm.captureMoney(drink,prices.get(drink));
        assertEquals(desiredOutput, realOutput);
    }
}
