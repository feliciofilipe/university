/* DISCLAIMER: THIS CODE IS A MODIFIED VERSION OF THE ONE PROVIDED AT 
 * https://code.google.com/a/eclipselabs.org/p/vending-machine/ under
 * Eclipse Public Licence 1.0
 */


import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.util.*;

/**
 * 
 * 
 * {@inheritDoc}
 * Vending Machine
 */

public class VendingMachine {
	
		int colaCount, coffeeCount, fantaCount;
		double coffeePrice = 3;
		double colaPrice = 2.5;
		double fantaPrice = 5;
		
		public int getColaCount() {
			return colaCount;
		}
		
		public int getCoffeeCount() {
			return coffeeCount;
		}
		
		public int getFantaCount() {
			return fantaCount;
		}
		
		
		
		int DEFAULT_ITEMS = 5;
		    
		    /**
		     * 
		     * This method load the Drinks into Drink Chamber with default quantity
		     */
		 private void loadInventory(int default_items) {
		            colaCount = default_items;
		            coffeeCount = default_items;
		            fantaCount = default_items;
		    }
		
       
        private enum Coin {
            //TC = 20 cent, FC = 50 cent, OE = 1 euro, TE = 2 Euro
        	TC(0.2), FC(0.5), OE(1.0), TE(2.0);
        	
        	/**
        	 * @param value  double 
        	 * Method to return Enumerator double value
        	 */
        	Coin(double value) { this.value = value; }
            private final double value;
       //     public double value() { return value; }
        }
        
    	private final String NLC = System.getProperty("line.separator"); //New line character form OS properties.
        
        /**
         * @author jiqbal
         *
         * Enumerators for Drink types and Quit command
         */
        private enum SelectionMenu {
                COLA,
                FANTA,
                COFFEE,
        }
        
        private static final String EXIT = "Exit"; 
        
        //private DrinkChamber drinkChamber;
        
        /**
         *  Represents total amount paid during a drink dispensing session. 
         */
        private double amountPaid; 
        
       
        /**
         * @param amountPaid Double
         *
         * Setter for amountPaid 
         */
        private void setAmountPaid(double amountPaid) {
                this.amountPaid = amountPaid;
        }
        
        /**
        *
        * 
        * This method is responsible for creation of a drink chamber and loading it with default number of drinks.
        */
        public VendingMachine() {
        	this.amountPaid = 0;
            this.loadInventory(DEFAULT_ITEMS);
             System.out.println("Vending machine is up and running!");
        }
        
       
           
        /**
         * Displays Menu on console.
         */
       public void DisplayMenu() {
        	
			StringBuilder sb = new StringBuilder();
			
			 sb.append("************************************************");sb.append(NLC);
			 sb.append("Please select your drink from the menu:");sb.append(NLC);
			 sb.append("\t" + SelectionMenu.COLA + "\t\tprice: [" + colaPrice + "] euro" + "\tstill have: [" + colaCount + "]can"); sb.append(NLC);
			 sb.append( "\t" + SelectionMenu.COFFEE + "\t\tprice: [" + coffeePrice + "] euro" + "\tstill have: [" + coffeeCount + "]can"); sb.append(NLC);
			 sb.append( "\t" + SelectionMenu.FANTA + "\t\tprice: [" + fantaPrice + "] euro" + "\tstill have: [" +  fantaCount + "]can"); sb.append(NLC);
			 //sb.append("\t" + "QUIT");sb.append(NLC);sb.append(NLC);
					 sb.append( "Enter:");sb.append(NLC);
			
			
			System.out.println(sb.toString());
			//return(displayMenu);
        }
		
		
        /**
         * @param change Double the amount to returns in terms of Coins 
         * @return int[]  list of coins to be returned corresponding to TE OE FC TC 
         */
        public int[] calculateReturningCoins(double change) {
        	   //calculates the change in coins, assumes unlimited coins available
        	
        		int[] coinList = new int[4];//number of coins corresponding to TE OE FC TC 
        	
                //System.out.print("Returning coin for change: "+ change );
                
                if ( change / Coin.TE.value >= 1 ) { 
                        int twoEuro = (int)(change / Coin.TE.value);
                        change = change - (twoEuro * Coin.TE.value);
                        coinList[0] = (int)twoEuro;
                        //System.out.println(twoEuro + " 2 Euro "); 
                }
                if ( change / Coin.OE.value >= 1 ) { 
                        int oneEuro = (int)(change / Coin.OE.value);
                        change = change - (oneEuro * Coin.OE.value);
                        coinList[1] = (int)oneEuro;
                        //System.out.println(oneEuro + " 1 Euro "); 
                } 
                if ( change / Coin.FC.value >= 1 ) {        
                		int fiftyCent = (int)(change / Coin.FC.value);
                        change = change - (fiftyCent * Coin.FC.value);
                        coinList[2] = (int)fiftyCent;
                        //System.out.println(fiftyCent + " 50 cents "); 
                } 
                if ( change / Coin.TC.value >= 1 ) { 
                	    int twentyCent = (int)(change / Coin.TC.value);
                        change = change - (twentyCent * Coin.TC.value);
                        coinList[3] = (int)twentyCent;
                        //System.out.println(twentyCent + " 20 cents "); 
                }      
            return coinList;
        }
        
     

        /**
         * @param change: double  value of returning amount to show in coins.
         * @return String message printed on console for returning the coins.
         */
        public String displayReturningCoins(double change){
        	// displays the change
        	
        	int[] coins = calculateReturningCoins(change);
        	
        	StringBuilder sb = new StringBuilder();
        	
        	sb.append("Your Change is ");sb.append(NLC);
        	sb.append("\t" + coins[0] +" x 2Euro" );sb.append(NLC);
        	sb.append("\t" + coins[1] +" x 1Euro" );sb.append(NLC);
        	sb.append("\t" + coins[2] +" x 50Cent" );sb.append(NLC);
        	sb.append("\t" + coins[3] +" x 20Cent" );sb.append(NLC);
        	
        	System.out.println(sb.toString());
        	
             return(sb.toString());
                    	
        }
        
        
        
        /**
         * @param price Double price of the drink
         * @param insertedCoins String of coins. insertedCoins is tokenized using spaces, e.g., OE OE OE for 3 Euro.
         * @return double the amount to be paid back.
         */
        public double calculateChange(double price, String insertedCoins) {
        	//calculates the change to be returned based on user input
        	//insertedCoins is tokenized using spaces, eg OE OE OE for 3 Euros
        	    
                StringTokenizer st = new StringTokenizer(insertedCoins);
                
                while(st.hasMoreElements()) {
                        String coin = st.nextToken();
                        
                        if (coin.equals("TC")) { amountPaid += Coin.TC.value; }
                        else if (coin.equals("FC")) { amountPaid += Coin.FC.value;}
                        else if (coin.equals("OE")) { amountPaid += Coin.OE.value; }
                        else if (coin.equals("TE")) { amountPaid += Coin.TE.value; }
                        else {System.out.printf("Wrong coin type!"); }
                      
                }
                System.out.println("You have paid " + amountPaid + " Euro");
                return amountPaid - price;
        }
        
        
        
        /**
         * @param selection String drink selected 
         * @param price double price of the drink
         * @return boolean return true if user gets the drink and change if any.
         */
       
        public Boolean captureMoney(String selection, double price){ //throws Exception {
        	    
        		//receives coins from the user or CANCEL
        	    BufferedReader coins = new BufferedReader(new InputStreamReader(System.in));
        	            	        	               
                while(true){
	                String amount= null;
	                
	                
	                try {
	                        amount = coins.readLine();
	                        System.out.println(" Amount: "+amount);
	                        if (amount != null) {
	                        	
	                        		//CANCEL pressed we abort payment
	                        		//TODO return the coins inserted so far
	                        		if (amount.contentEquals("CANCEL")){
	                        			//Cancelling order, returning to the main menu
	                        			System.out.println("Order cancelled, return coins");
	                        			return false;
	                        		}
	                        		else {
	                        			double change = calculateChange(price, amount);
	                                                             
		                                if ( change >= 0.0) {
		                                        //processSelection(selection, true);
		                                        if (change > 0.0) {
		                                                System.out.println("Your change is: " + change + " EURO");
		                                                displayReturningCoins(change);
		                                                System.out.println("DRINK DELIVERED, Thank you for your business, see you again!"+ NLC+NLC+NLC+NLC);
		                                                change = 0;
		                                         }
		                                        break; 
		                                }
	                        		}
	                        }	                                
	                        else {
	                              System.out.println("You did not put enough money, please put in more coins.");
	                           	}		
	                } catch (IOException e) {
	                        System.out.println("Error in reading input.");
	                        System.exit(1);
	                }       
              }
                
                return true;  
        }
        
   
              
        /**
         * @param selection String drink selected
         * @param paymentOK boolean represents that payment is okay.
         */
        public void processSelection(String selection) {     
            String coinList = " TC = 20 cent, FC = 50 cent, OE = 1 euro, TE = 2 Euro";
            amountPaid= 0;
            
            switch (SelectionMenu.valueOf(selection)) {
                    case COLA: 
                            if (colaCount > 0) {
                            	System.out.printf("The price is %.2f Euro, please insert a coin."+coinList+NLC, colaPrice);
                            	if (captureMoney(selection, colaPrice)) 
                               		colaCount--;
                          	    }
                            else 
                            	System.out.println("We ran out of COLA. Please order a different drink \n \n");
                            break;
                    case COFFEE:                     	 	
                    	 	if (coffeeCount > 0) {
                    	 		System.out.printf("The price is %.2f Euro, please insert a coin."+coinList+NLC, colaPrice);
                    	 		if (captureMoney(selection, colaPrice)) {
                    	 			coffeeCount--;
                    	 		}
                    	 	}
                    	 	else 
                    	 		System.out.println("We ran out of COFFEE. Please order a different drink \n \n");
                    	 	break;
                    case FANTA: 
                       	 	if (colaCount > 0) {
                       	 		System.out.printf("The price is %.2f Euro, please insert a coin."+coinList+NLC, fantaPrice);
                    	 		if (captureMoney(selection, colaPrice)) {
                    	 			fantaCount--;
                    	 		}
                    	 	}
                    	 	else 
                    	 		System.out.println("We ran out of FANTA. Please order a different drink \n \n");
                    	 	break;
        	}
        }
            
        
        
        
        /**
         * @return EXIT: String 
         */
        public String captureInputAndRespond(){
        	//select a drink
        	        	    	
        	BufferedReader choosen = new BufferedReader(new InputStreamReader(System.in));
        	for (int i = 0; i < 10; i++){
        		this.DisplayMenu();
        		String selection = null;
        		
        		try {
                    selection = choosen.readLine();    
                
                    
        		} catch (IOException e) {
                    System.out.println("Error in reading input.");
                    System.exit(1);
        		}
        		
        		 //check if valid options
        		 if (selection.equals("QUIT") || selection.equals("COLA") || selection.equals("COFFEE") || selection.equals("FANTA")){
        			 if (!selection.equals("QUIT")) {
	         			 System.out.printf("You have selected " + selection + NLC);        		
	        			 processSelection(selection); 
	        			 //reseting the amount paid
	        			 amountPaid=0;
	        		 }
	        		 else {
	        			 System.out.println("Exiting...BYE!");   
	        			 System.exit(1); 
	        		 }
        		 }
        		 else { System.out.println("Wrong input try again!!!"+NLC+NLC);}   
        	}
        	return EXIT;
         }
        	
        //main should not be called for testing purposes.
        public static void main(String[] args) {
                VendingMachine vm = new VendingMachine();
                while(true) {
                        
                        if (vm.captureInputAndRespond().equals("Exit"))
                                break;
                }
        }
	
}
