import org.junit.*;

import static org.junit.Assert.*;

public class Task1 {

    private VendingMachine vm;

    @Before
    public void Task1(){
        vm = new VendingMachine();
    }

    @Test
    public void testNodes(){
        assertArrayEquals(new int[]{2,1,1,1},vm.calculateReturningCoins(5.7));
    }

    @Test
    public void testEdges(){
        assertArrayEquals(new int[]{0,0,0,0},vm.calculateReturningCoins(0));
        assertArrayEquals(new int[]{2,1,1,1},vm.calculateReturningCoins(5.7));
    }

    @Test
    public void testEdgesPairs(){
        assertArrayEquals(new int[]{1,1,1,1},vm.calculateReturningCoins(3.7));
        assertArrayEquals(new int[]{0,1,0,0},vm.calculateReturningCoins(1));
        assertArrayEquals(new int[]{1,0,1,0},vm.calculateReturningCoins(2.5));
        assertArrayEquals(new int[]{0,0,0,1},vm.calculateReturningCoins(0.2));
    }

}
