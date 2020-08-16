package Controller;

import Model.ClientInterface;
import Model.GuestVendasInterface;
import Model.ProductInterface;
import Utilities.Config;

public class QueryProcessor {
    //Inclui o proprio nome da instruçao como argumento
    private static boolean validateMonth(String queryField){
        int month;
        try {
            month = Integer.parseInt(queryField);
        } catch (NumberFormatException e) {
            return false;
        }
        return (month <= 12 && month > 0);
    }

    private static boolean validateBranch(String queryField){
        int branch;
        try {
            branch = Integer.parseInt(queryField);
        } catch (NumberFormatException e) {
            return false;
        }
        return (branch < Config.numberOfBranches && branch >= 0);
    }

    private static boolean validateLimit(String queryfield) {
        try {
            Integer.parseInt(queryfield);
        } catch (NumberFormatException e) {
            return false;
        }
        return true;
    }
    private static boolean validateClient(String queryfield){
       return ClientInterface.verifyId(queryfield);
    }

    //Query 2 -> salesByMonth month [branch]
    public static boolean validateQuery2(String [] args){
        if (args.length > 3 || args.length <= 1) return false;
        boolean ret = true;
        if (args.length == 3) ret = (validateBranch(args[2]));
        return ret && (validateMonth(args[1]));
    }
    //Query 3 distintProductsByMonth clientID
    public static boolean validateQuery3(String [] args){
        if (args.length != 2) return false;
        return validateClient(args[1]);
    }
    //Query 4 distintClientsByMonth productID
    public static boolean validateQuery4(GuestVendasInterface g, String[] args){
        if (args.length != 2) return false;
        return g.containsProduct(args[1]);
    }
    //Query 5 getClientMostBoughtProducts clientID
    public static boolean validateQuery5(String [] args){
        if (args.length != 2) return false;
        return validateClient(args[1]);
    }
    //Query 6 mostSoldProductsLimit limit
    public static boolean validateQuery6(String [] args) {
        if (args.length != 2) return false;

        try {
           Integer.parseInt(args[1]);
        } catch (NumberFormatException e) {
            return false;
        }
        return true;
    }
    //Query 7 listThreeBiggestBuyers

    //Query 8 * limit
    public static boolean validateQuery8(String [] args) {
        if (args.length != 2) return false;
        return validateLimit(args[1]);
    }
    //Query 9  * product limit
        public static boolean validateQuery9(GuestVendasInterface g,  String [] args) {
            if (args.length != 3) return false;
            return (g.containsProduct(args[1]) && validateLimit(args[2]));
        }


        }
