import org.junit.*;
import static org.junit.Assert.*;

import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.io.PrintStream;

public class TestsA1Task2 {

    VendingMachine vm;

    @Before
    public void setVendingMachine(){
        this.vm = new VendingMachine();
    }

    @Test
    public void testScenario(){
    	String NLC = System.getProperty("line.separator");
        String[] coins = {"TE FC TE", "TE TE FC", "TE OE FC", "OE OE OE TE", "TE OE TE", "OE OE FC TE","TE TE TE TE"};
        
        for(int i = 0; i < 4; i++) {
        	auxTestProcessSelection("COLA", coins[i], "DRINK DELIVERED, Thank you for your business, see you again!"+ NLC+NLC+NLC+NLC);
        }
        auxTestProcessSelection("COLA", coins[5], "We ran out of COLA. Please order a different drink \n \n");
        auxTestProcessSelection("COFFEE", coins[6], "DRINK DELIVERED, Thank you for your business, see you again!"+ NLC+NLC+NLC+NLC);

    }
    
    public void auxTestProcessSelection(String drink, String coins, String desiredOutput){
        ByteArrayOutputStream newout = new ByteArrayOutputStream();
        System.setOut(new PrintStream(newout));

        ByteArrayInputStream input = new ByteArrayInputStream((coins).getBytes());

        System.setIn(input);
        vm.processSelection(drink);
        String realOutput = newout.toString();

        System.setIn(System.in);
        System.setOut(System.out);
        System.out.println(realOutput);
        assertTrue(realOutput.contains(desiredOutput));
    }


}
