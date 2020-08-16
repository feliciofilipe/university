package Controller;

import Model.GuestVendasInterface;
import Utilities.*;
import View.ViewInterface;

import java.io.IOException;
import java.util.*;

import static java.lang.System.in;

public class Controller implements ControllerInterface {

    /**
     *
     */
    private GuestVendasInterface model;

    /**
     *
     */
    private ViewInterface view;

    /**
     * Instantiates a new Controller
     *
     * @param guestVendas Model Object
     * @param view View object
     */
    public Controller(GuestVendasInterface guestVendas, ViewInterface view) {
        this.model = guestVendas;
        this.view = view;
    }

    /**
     * Command line frame where the inputs are read and the functions are called accordingly
     */
    public void run() {
        int out = 1;
        view.typeHelp();
        while (out != 0) {
            Scanner scanner = new Scanner(in);
            view.prompt();
            String commandline = scanner.nextLine();
            String[] input = commandline.split(" ");
            if (input.length >= 1) {
                switch (input[0]) {
                    case "help": {
                        help(input);
                        break;
                    }
                    case "query1.1": {
                        query1_1(input);
                        break;
                    }
                    case "query1.2.1": {
                        query1_2_1(input);
                        break;
                    }
                    case "query1.2.2": {
                        query1_2_2(input);
                        break;
                    }
                    case "query1.2.3": {
                        query1_2_3(input);
                        break;
                    }
                    case "query1": {
                        query1(input);
                        break;
                    }
                    case "query2": {
                        query2(input);
                        break;
                    }
                    case "query3": {
                        query3(input);
                        break;
                    }
                    case "query4": {
                        query4(model, input);
                        break;
                    }
                    case "query5": {
                        query5(input);
                        break;
                    }
                    case "query6": {
                        query6(input);
                        break;
                    }
                    case "query7": {
                        query7(input);
                        break;
                    }
                    case "query8": {
                        query8(input);
                        break;
                    }
                    case "query9": {
                        query9(model, input);
                        break;
                    }
                    case "query10": {
                        query10(input);
                        break;
                    }
                    case "load": {
                        load(input);
                        break;
                    }
                    case "loadFromObject": {
                        loadFromObject(input);
                        break;
                    }
                    case "save": {
                        save(input);
                        break;
                    }
                    case "clear": {
                        clear();
                        break;
                    }
                    case "quit": {
                        out = 0;
                        break;
                    }
                }
            }
        }
    }

    /**
     * Function that clears the screen
     */
    private void clear() {
        view.clear();
    }

    /**
     * Function that controls the help information
     *
     * @param input User input
     */
    private void help(String[] input) {
        if (input.length == 1)
            view.help();
        else if (input.length == 2) {
            view.helpFunction(input[1]);
        } else {
            view.usageErrorHelp();
        }
    }

    /**
     * Function that controls the query1_1 information
     *
     * @param input User input
     */
    private void query1_1(String[] input) {
        if (input.length == 1) {
            Crono.start();
            view.query1_1(model.getSalesPath(),
                    model.getInvalidSales(),
                    model.getNumberOfProducts(),
                    model.getNumberProductsBought(),
                    model.getNumberProductsNotBought(),
                    model.getNumberOfClients(),
                    model.getNumberOfClientsBuy(),
                    model.getNumberOfClientsDidntBuy(),
                    model.getNumberFreeSales(),
                    model.getTotalBilling(),
                    Crono.getTime());
            Crono.stop();
        } else {
            view.usageErrorQ1_1();
        }
    }

    /**
     * Function that controls the query1_2_1 information
     *
     * @param input User input
     */
    private void query1_2_1(String[] input) {
        if (input.length == 1) {
            Crono.start();
            Map<Integer, Long> mapQuery1_2_1 = model.getNumberSalesByMonth();
            Crono.stop();
            view.query1_2_1(mapQuery1_2_1, Crono.getTime());
        } else {
            view.usageErrorQ1_2_1();
        }
    }

    /**
     * Function that controls the query1_2_2 information
     *
     * @param input User input
     */
    private void query1_2_2(String[] input) {
        if (input.length == 1) {
            Crono.start();
            Map<Integer, Map<Integer, Double>> mapQuery1_2_2 = model.getTotalExpenditure();
            Crono.stop();
            view.query1_2_2(mapQuery1_2_2, Crono.getTime());
        } else {
            view.usageErrorQ1_2_2();
        }
    }

    /**
     * Function that controls the query1_2_3 information
     *
     * @param input User input
     */
    private void query1_2_3(String[] input) {
        if (input.length == 1) {
            Crono.start();
            Map<Integer, Map<Integer, Long>> mapQuery1_2_3 = model.getIndividualClientsBranch();
            Crono.stop();
            view.query1_2_3(mapQuery1_2_3, Crono.getTime());
        } else {
            view.usageErrorQ1_2_3();
        }
    }

    /**
     * Function that controls the query1 information
     *
     * @param input User input
     */
    private void query1(String[] input) {
        if (input.length == 1) {
            Crono.start();
            List<String> listProductsNotBought = model.listProductsNotBought();
            Crono.stop();
            String time = Crono.getTime();
            Scanner scanner = new Scanner(in);
            String option = "";
            int page = 0;
            while (!option.equals("quit")) {
                view.query1(listProductsNotBought, page, time);
                option = scanner.nextLine();
                if (option.equals("less")) {
                    if (page - Config.pageSize < 0)
                        page = 0;
                    else page -= Config.pageSize;
                } else if (option.equals("more"))
                    if (page + Config.pageSize < model.getNumberOfProducts())
                        page += Config.pageSize;
            }
        } else {
            view.usageErrorQ1();
        }
    }

    /**
     * Function that controls the query2 information
     *
     * @param input User input
     */
    private void query2(String[] input) {
        if (QueryProcessor.validateQuery2(input)) {
            if (input.length == 2) {
                Crono.start();
                Query2Pair pair = model.salesByMonth(Integer.parseInt(input[1]));
                Crono.stop();
                view.query2(pair.getNumberSales(), pair.getNumberDistinctClients(), Crono.getTime());
            } else if (input.length == 3) {
                Crono.start();
                Query2Pair pair = model.salesByMonth(Integer.parseInt(input[1]), Integer.parseInt(input[2]));
                Crono.stop();
                view.query2(pair.getNumberSales(), pair.getNumberDistinctClients(), Crono.getTime());
            }
        } else {
            view.usageErrorQ2();
        }
    }

    /**
     * Function that controls the query3 information
     *
     * @param input User input
     */
    private void query3(String[] input) {
        if (QueryProcessor.validateQuery3(input)) {
            Crono.start();
            Map<Integer, Query3Triple> mapQuery3 = this.model.distinctProductsByMonth(input[1]);
            Crono.stop();
            view.query3(mapQuery3, Crono.getTime());
        } else {
            view.usageErrorQ3();
        }
    }

    /**
     * Function that controls the query4 information
     *
     * @param input User input
     */
    private void query4(GuestVendasInterface g, String[] input) {
        if (QueryProcessor.validateQuery4(g, input)) {
            Crono.start();
            Map<Integer, Query4Triple> mapQuery4 = model.distinctClientsByMonth(input[1]);
            Crono.stop();
            view.query4(mapQuery4, Crono.getTime());
        } else {
            view.usageErrorQ4();
        }
    }

    /**
     * Function that controls the query5 information
     *
     * @param input User input
     */
    private void query5(String[] input) {
        if (QueryProcessor.validateQuery5(input)) {
            Crono.start();
            Map<Integer, Set<String>> mapQuery5 = model.getClientMostBoughtProducts(input[1]);
            Crono.stop();
            view.query5(mapQuery5, Crono.getTime());
        } else {
            view.usageErrorQ5();
        }
    }

    /**
     * Function that controls the query6 information
     *
     * @param input User input
     */
    private void query6(String[] input) {
        if (QueryProcessor.validateQuery6(input)) {
            Crono.start();
            List<Map.Entry<String, Long>> listQuery6 = model.mostSoldProducts(Integer.parseInt(input[1]));
            Crono.stop();
            view.query6(listQuery6, Crono.getTime());
        } else {
            view.usageErrorQ6();
        }
    }

    /**
     * Function that controls the query7 information
     *
     * @param input User input
     */
    private void query7(String[] input) {
        if (input.length == 1) {
            Crono.start();
            Map<Integer, List<String>> mapQuery7 = model.listThreeBiggestBuyers();
            Crono.stop();
            view.query7(mapQuery7, Crono.getTime());
        } else {
            view.usageErrorQ7();
        }
    }

    /**
     * Function that controls the query8 information
     *
     * @param input User input
     */
    private void query8(String[] input) {
        if (QueryProcessor.validateQuery8(input)) {
            Crono.start();
            List<Map.Entry<String, Long>> listQuery8 = model.getBiggestDistinctBuyers(Integer.parseInt(input[1]));
            Crono.stop();
            view.query8(listQuery8, Crono.getTime());
        } else {
            view.usageErrorQ8();
        }
    }

    /**
     * Function that controls the query9 information
     *
     * @param input User input
     */
    private void query9(GuestVendasInterface g, String[] input) {
        if (QueryProcessor.validateQuery9(g, input)) {
            Crono.start();
            Map<Integer, Map<String, Float>> mapQuery9 = model.getNBiggestBuyers(input[1], Integer.parseInt(input[2]));
            Crono.stop();
            view.query9(mapQuery9, Crono.getTime());
        } else {
            view.usageErrorQ9();
        }
    }

    /**
     * Function that controls the query10 information
     *
     * @param input User input
     */
    private void query10(String[] input) {
        Scanner scanner = new Scanner(System.in);
        if (input.length == 1) {
            String option = "";
            Crono.start();
            Map<String, float[][]> mapQuery10 = model.getTotalExpenditureByBranchAndMonth();
            Crono.stop();
            String time = Crono.getTime();
            int i = 0;
            String[] keys = mapQuery10.keySet().toArray(String[]::new);
            if (keys.length != 0) {
                while (!option.equals("quit")) {
                    view.query10(keys[i], mapQuery10.get(keys[i]), time);
                    option = scanner.nextLine();
                    if (option.equals("next") && i + 1 < keys.length) i++;
                }
            }
        } else {
            view.usageErrorQ10();
        }
    }

    /**
     * Function that controls the load
     *
     * @param input User input
     */
    private void load(String[] input) {
        try {
            Utilities.Crono.start();
            if (input.length == 2) {
                this.model.readClientsFile(Config.clientsPath);
                this.model.readProductsFile(Config.productsPath);
                this.model.readSalesFile(input[1]);
            } else if (input.length == 1) {
                this.model.readClientsFile(Config.clientsPath);
                this.model.readProductsFile(Config.productsPath);
                this.model.readSalesFile(Config.salesFile1M);
            } else {
                view.usageErrorLoad();
            }
            Utilities.Crono.stop();
            view.load(Utilities.Crono.getTime());
        } catch (IOException e) {
            view.loadFilesDoesNotExist();
        }
    }

    /**
     * Function that controls the load From Object
     *
     * @param input User input
     */
    private void loadFromObject(String[] input) {
        try {
            Crono.start();
            if (input.length == 1) {
                this.model = GuestVendasInterface.loadSGVObject(Utilities.Config.objectsFolder + Utilities.Config.objectName);
            } else if (input.length == 2) {
                this.model = GuestVendasInterface.loadSGVObject(Utilities.Config.objectsFolder + input[1]);
            } else {
                view.usageErrorLoad();
            }
            Crono.stop();
            view.load(Crono.getTime());
        } catch (IOException | ClassNotFoundException e) {
            view.loadObjectDoesNotExist();
        }
    }

    /**
     * Function that controls the save
     *
     * @param input User input
     */
    private void save(String[] input) {
        Crono.start();
        try {
            if (input.length == 1) {
                model.saveSGVObject(Config.objectsFolder + Config.objectName);
            } else if (input.length == 2) {
                model.saveSGVObject(Config.objectsFolder + input[1]);
            } else {
                view.usageErrorSave();
            }
            Crono.stop();
        } catch (IOException e) {
            view.invalidSaveFormat();
        }
    }
}
