import org.junit.Before;
import org.junit.Test;

import static org.junit.Assert.assertEquals;

public class Task2 {

    private VendingMachine vm;
    private final String NLC = System.getProperty("line.separator"); //New line character form OS properties.

    @Before
    public void Task2(){
        vm = new VendingMachine();
    }

    @Test
    public void testPaths(){
        assertEquals(coinsToString(new int[]{1,0,0,0}),vm.displayReturningCoins(2));
        assertEquals(coinsToString(new int[]{0,1,0,0}),vm.displayReturningCoins(1));
        assertEquals(coinsToString(new int[]{0,0,1,0}),vm.displayReturningCoins(0.5));
        assertEquals(coinsToString(new int[]{0,0,0,1}),vm.displayReturningCoins(0.2));
        assertEquals(coinsToString(new int[]{1,1,0,0}),vm.displayReturningCoins(3));
        assertEquals(coinsToString(new int[]{1,1,1,0}),vm.displayReturningCoins(3.5));
        assertEquals(coinsToString(new int[]{1,1,1,1}),vm.displayReturningCoins(3.7));
        assertEquals(coinsToString(new int[]{3,0,0,0}),vm.displayReturningCoins(6));
        assertEquals(coinsToString(new int[]{3,1,1,0}),vm.displayReturningCoins(7.5));
        //assertEquals(coinsToString(new int[]{0,1,0,1}),vm.displayReturningCoins(1.2));
        assertEquals(coinsToString(new int[]{3,1,0,0}),vm.displayReturningCoins(7));
        //assertEquals(coinsToString(new int[]{0,0,1,1}),vm.displayReturningCoins(0.7));
        assertEquals(coinsToString(new int[]{0,0,1,0}),vm.displayReturningCoins(0.5));
        assertEquals(coinsToString(new int[]{0,0,0,1}),vm.displayReturningCoins(0.2));
    }

    private String coinsToString(int[] coins){
        StringBuilder sb = new StringBuilder();
        sb.append("Your Change is ");sb.append(NLC);
        sb.append("\t" + coins[0] +" x 2Euro" );sb.append(NLC);
        sb.append("\t" + coins[1] +" x 1Euro" );sb.append(NLC);
        sb.append("\t" + coins[2] +" x 50Cent" );sb.append(NLC);
        sb.append("\t" + coins[3] +" x 20Cent" );sb.append(NLC);
        return sb.toString();
    }

}
