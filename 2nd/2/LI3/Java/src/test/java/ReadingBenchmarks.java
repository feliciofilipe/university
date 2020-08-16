import Model.Sale;
import Model.SaleInterface;
import Utilities.Crono;

import java.io.BufferedReader;
import java.io.FileReader;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;


public class ReadingBenchmarks {

    /**
     * Default path of the sales file 1M lines
     */
    public static String salesPath1M = "data/Vendas_1M.txt";

    /**
     * Default path of the sales file 3M lines
     */
    public static String salesPath3M = "data/Vendas_3M.txt";

    /**
     * Default path of the sales file 5M lines
     */
    public static String salesPath5M = "data/Vendas_5M.txt";


    public static void testReading1M(){
        System.out.println("-----READING ONLY-----");
        System.out.println("1M lines");
        Crono.start();
        onlyReadUsingBufferedReader(salesPath1M);
        Crono.stop();
        System.out.println("\tBufferedReader: "+Crono.getTime());

        Crono.start();
        onlyReadUsingFiles(salesPath1M);
        Crono.stop();
        System.out.println("\tFiles: "+Crono.getTime());


        System.out.println("-----READING AND PARSING-----");
        System.out.println("1M lines");
        Crono.start();
        List<String> l1Buffered =  onlyReadUsingBufferedReader(salesPath1M);
        parseLines(l1Buffered);
        Crono.stop();
        System.out.println("\tBufferedReader: "+Crono.getTime());

        Crono.start();
        List<String> l1Files = onlyReadUsingFiles(salesPath1M);
        parseLines(l1Files);
        Crono.stop();
        System.out.println("\tFiles: "+Crono.getTime());



        System.out.println("-----READING, PARSING AND VALIDATING-----");
        System.out.println("1M lines");
        Crono.start();
        List<String> l1BufferedV =  onlyReadUsingBufferedReader(salesPath1M);
        parseLines(l1BufferedV);
        Crono.stop();
        System.out.println("\tBufferedReader: "+Crono.getTime());

        Crono.start();
        List<String> l1FilesV = onlyReadUsingFiles(salesPath1M);
        parseLines(l1FilesV);
        Crono.stop();
        System.out.println("\tFiles: "+Crono.getTime());





    }

    public static void testReading3M(){

        System.out.println("-----READING ONLY-----");
        System.out.println("3M lines");
        Crono.start();
        onlyReadUsingBufferedReader(salesPath3M);
        Crono.stop();
        System.out.println("\tBufferedReader: "+Crono.getTime());

        Crono.start();
        onlyReadUsingFiles(salesPath3M);
        Crono.stop();
        System.out.println("\tLines: "+Crono.getTime());


        System.out.println("-----READING AND PARSING-----");
        System.out.println("3M lines");
        Crono.start();
        List<String> l3Buffered = onlyReadUsingBufferedReader(salesPath3M);
        parseLines(l3Buffered);
        Crono.stop();
        System.out.println("\tBufferedReader: "+Crono.getTime());

        Crono.start();
        List<String> l3Files = onlyReadUsingFiles(salesPath3M);
        parseLines(l3Files);
        Crono.stop();
        System.out.println("\tLines: "+Crono.getTime());


        System.out.println("-----READING, PARSING AND VALIDATING-----");
        System.out.println("3M lines");
        Crono.start();
        List<String> l3BufferedV = onlyReadUsingBufferedReader(salesPath3M);
        parseLines(l3BufferedV);
        Crono.stop();
        System.out.println("\tBufferedReader: "+Crono.getTime());

        Crono.start();
        List<String> l3FilesV = onlyReadUsingFiles(salesPath3M);
        parseLines(l3FilesV);
        Crono.stop();
        System.out.println("\tLines: "+Crono.getTime());

    }

    public static void testReading5M(){

        System.out.println("-----READING ONLY-----");
        System.out.println("5M lines");
        Crono.start();
        onlyReadUsingBufferedReader(salesPath5M);
        Crono.stop();
        System.out.println("\tBufferedReader: "+Crono.getTime());

        Crono.start();
        onlyReadUsingFiles(salesPath5M);
        Crono.stop();
        System.out.println("\tLines: "+Crono.getTime());

        System.out.println("-----READING AND PARSING-----");
        System.out.println("5M lines");
        Crono.start();
        List<String> l5Buffered = onlyReadUsingBufferedReader(salesPath5M);
        parseLines(l5Buffered);
        Crono.stop();
        System.out.println("\tBufferedReader: "+Crono.getTime());

        Crono.start();
        List<String> l5Files =onlyReadUsingFiles(salesPath5M);
        parseLines(l5Files);
        Crono.stop();
        System.out.println("\tLines: "+Crono.getTime());


        System.out.println("-----READING, PARSING AND VALIDATING-----");
        System.out.println("5M lines");
        Crono.start();
        List<String> l5BufferedV = onlyReadUsingBufferedReader(salesPath5M);
        parseLines(l5BufferedV);
        Crono.stop();
        System.out.println("\tBufferedReader: "+Crono.getTime());

        Crono.start();
        List<String> l5FilesV =onlyReadUsingFiles(salesPath5M);
        parseLines(l5FilesV);
        Crono.stop();
        System.out.println("\tLines: "+Crono.getTime());
    }

    /**
     * Reads all the lines from a given file using BufferedReader
     * @param salesPath path of the file
     * @return list of the Strings
     */
    private static List<String>  onlyReadUsingBufferedReader(String salesPath){
        List<String> l = new ArrayList<>();
        try {
            BufferedReader buf = new BufferedReader(new FileReader(salesPath));
            String saleLine;
            while ((saleLine = buf.readLine()) != null) {
                l.add(saleLine);
            }
        } catch (IOException e) {
            e.printStackTrace();
        }
        return l;
    }


        /**
     * Reads all the lines from a given file using Files
     * @param salesPath path of the file
     * @return list of the Strings
     */
    private static List<String>  onlyReadUsingFiles(String salesPath) {
        List<String> l = new ArrayList<>();
        try {
            l = Files.lines(Paths.get(salesPath)).collect(Collectors.toList());
        } catch (IOException e) {
            e.printStackTrace();
        }
        return l;
    }


    /**
     * Parses all lines and creates a list of sales
     * @param listLines path of the file
     * @return list of the Strings
     */
    private static List<SaleInterface>  parseLines(List<String> listLines) {
        List<SaleInterface> l = new ArrayList<>();
        for(String saleLine : listLines){
            String[] saleLineSplit = saleLine.split(" ");
            if (saleLineSplit.length == 7) {
                String productID = saleLineSplit[0];
                float cost = Float.parseFloat(saleLineSplit[1]);
                int quantity = Integer.parseInt(saleLineSplit[2]);
                String type = saleLineSplit[3];
                String clientID = saleLineSplit[4];
                int month = Integer.parseInt(saleLineSplit[5]);
                int branch = Integer.parseInt(saleLineSplit[6]);
                SaleInterface sale = new Sale(productID, clientID, cost, quantity, type, month, branch);
                l.add(sale);
            }
        }
        return l;
    }

    /**
     * Parses and validades all lines and creates a list of sales
     * @param listLines path of the file
     * @return list of the Strings
     */
    private static List<SaleInterface>  parseAndValidateLines(List<String> listLines) {
        List<SaleInterface> l = new ArrayList<>();
        for(String saleLine : listLines){
            String[] saleLineSplit = saleLine.split(" ");
            if (saleLineSplit.length == 7) {
                String productID = saleLineSplit[0];
                float cost = Float.parseFloat(saleLineSplit[1]);
                int quantity = Integer.parseInt(saleLineSplit[2]);
                String type = saleLineSplit[3];
                String clientID = saleLineSplit[4];
                int month = Integer.parseInt(saleLineSplit[5]);
                int branch = Integer.parseInt(saleLineSplit[6]);
                SaleInterface sale = new Sale(productID, clientID, cost, quantity, type, month, branch);
                if(SaleInterface.validateSale(cost, quantity, type, month, branch)) {
                    l.add(sale);
                }
            }
        }
        return l;
    }

}
