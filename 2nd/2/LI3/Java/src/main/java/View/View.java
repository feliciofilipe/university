package View;

import Utilities.Config;
import Utilities.Query3Triple;
import Utilities.Query4Triple;

import java.util.List;
import java.util.Map;
import java.util.Set;

import static java.lang.System.out;

public class View implements ViewInterface{

    public View(){

    }

    public void typeHelp() {
        System.out.println("type `help` to see the commands avaliable.");
    }

    public void help() {
        System.out.println("These commands are defined internally. Type `help' to see this list.");
        System.out.println("Type `help name` to find out more about the function `name`.\n");
        System.out.println(" load [sales filepath]      loadFromObject [sales filepath]");
        System.out.println(" query1.1                   query1.2.1");
        System.out.println(" query1.2.2                 query1.2.3");
        System.out.println(" query1                     query2 month [branch]");
        System.out.println(" query3 clientID            query4 productID");
        System.out.println(" query4 productID           query5 clientID");
        System.out.println(" query6 limit               query7");
        System.out.println(" query8 limit               query9 productID limit");
        System.out.println(" query10                    clear");
        System.out.println(" save [Object's name]       quit");
        System.out.println();
    }

    public void helpFunction(String function){
        switch (function){
            case "query1":{
                helpQuery1();
                break;
            }
            case "query2":{
                helpQuery2();
                break;
            }
            case "query3":{
                helpQuery3();
                break;
            }
            case "query4":{
                helpQuery4();
                break;
            }
            case "query5":{
                helpQuery5();
                break;
            }
            case "query6":{
                helpQuery6();
                break;
            }
            case "query7":{
                helpQuery7();
                break;
            }
            case "query8":{
                helpQuery8();
                break;
            }
            case "query9":{
                helpQuery9();
                break;
            }
            case "query10":{
                helpQuery10();
                break;
            }
            case "load":{
                helpLoad();
                break;
            }
            case "clear":{
                helpClear();
                break;
            }
            case "quit":{
                System.out.println("Exit the system");
                break;
            }
            default:{
                usageErrorHelp();
                break;
            }
        }
    }

    private void helpQuery1(){
        helpHeadline("Query1","");
        System.out.println("    Sorted list of users' IDs who never made a purchase");
    }

    private void helpQuery2(){
        helpHeadline("Query2"," month [branch]");
        System.out.println("    Given a month, returns the number of sales in that month and the number of distinct clients who did buy.");
        System.out.println("    Accepts a branch aswell");
    }

    private void helpQuery3(){
        helpHeadline("Query3"," clientID");
        System.out.println("    Given a clientID, return, for each month, how many sales, how many distinct products and much was spent.");
    }

    private void helpQuery4(){
        helpHeadline("Query4"," productID");
        System.out.println("    Given an EXISTENT product, return, for each month, how many sales, how many distinct clients and much was spent.");
    }

    private void helpQuery5(){
        helpHeadline("Query5"," clientID");
        System.out.println("    Displays the products a client bought the most, in descending order.");
    }

    private void helpQuery6(){
        helpHeadline("Query6"," limit");
        System.out.println("    Returns the <limit> most sold products(in terms of quantity), indicating the total number of distinct clients which bought them.");
    }

    private void helpQuery7(){
        helpHeadline("Query7","");
        System.out.println("    Returns the list of the three biggest buyers.");
    }

    private void helpQuery8(){
        helpHeadline("Query8"," limit");
        System.out.println("    Calculates the <limit> biggest buyers in terms of different number of products.");
    }

    private void helpQuery9(){
        helpHeadline("Query9"," limit");
        System.out.println("    Given a products's ID returns the <limit> biggest buyers.");
    }

    private void helpQuery10(){
        helpHeadline("Query10","");
        System.out.println("    Get the total Expenditure of all Products by Branch and Month.");
    }

    private void helpLoad(){
        helpHeadline("Load"," [sales filepath]");
        System.out.println("    Load information into the system from a given or default file.");
    }

    private void helpClear(){
        helpHeadline("Clear","");
        System.out.println("    Clears the terminal.");
    }

    private void helpHeadline(String function,String args){
        System.out.println(function + ": "+ function + args);
    }

    public void prompt(){
        System.out.print("[SGV@Java]$ ");
    }

    public void load(String time){
        System.out.println("Load Time: " + time);
    }

    public void query1(List<String> products,int page,String time) {
            for(int j = 0; j < Math.min(products.size() - page,15); j++)
                System.out.println(products.get(page+j));
        if(page + Config.pageSize < products.size())
            System.out.println(page + "-" + (page+Config.pageSize) + " | " + products.size());
        else {
            System.out.println(page + "-" + products.size() + " | " + products.size());
        }
        navigator(time);
        queryPrompt(1);
    }

    private void queryPrompt(int i){
        System.out.print("[SGV@Query"+i+"]$ ");
    }

    private void navigator(String time){
        System.out.println("type `more` to see the next page");
        System.out.println("type `less` to see the previous page");
        System.out.println("type `quit` to exit");
        System.out.println("Query time: " + time);
    }

    public void query1_1(String salesPath,int invalidSales, int numberOfProducts,int numberProductsBought, int numberProductsNotBought,
                         int numberOfClients, int numberOfClientsBuy, int numberOfClientsDidntBuy,int numberFreeSales,
                         float totalBilling, String time) {
        System.out.println("Path: "+ salesPath);
        System.out.println("Number of wrong lines: "+ invalidSales);
        System.out.println("Number of products: "+ numberOfProducts);
        System.out.println("Number of distinct products bought: "+ numberProductsBought);
        System.out.println("Number of products not bought: "+ numberProductsNotBought);
        System.out.println("Number of clients: "+ numberOfClients);
        System.out.println("Number of clients who purchased: "+ numberOfClientsBuy);
        System.out.println("Number of clients who didn't purchase: "+ numberOfClientsDidntBuy);
        System.out.println("Number of free sales: "+ numberFreeSales);
        System.out.println("Total Billing: "+ totalBilling);
        System.out.println("Query time: " + time);
    }

    public void query1_2_1(Map<Integer,Long> map,String time) {
        for(Map.Entry<Integer,Long> e : map.entrySet()){
            System.out.println(e.getKey());
            System.out.println(e.getValue());
        }
        System.out.println("Query time: " + time);
    }

    public void query1_2_2(Map<Integer,Map<Integer,Double>> map,String time) {
        for(Map.Entry<Integer, Map<Integer, Double>> e1 : map.entrySet()) {
            System.out.println("Month: " + e1.getKey());
            for (Map.Entry<Integer, Double> e2 : e1.getValue().entrySet()) {
                System.out.println("Branch: " + e2.getKey() + " Valor: " + e2.getValue());
            }
        }
        System.out.println("Query time: " + time);
    }

    public void query1_2_3(Map<Integer,Map<Integer,Long>> map, String time) {
        for(Map.Entry<Integer, Map<Integer, Long>> e1 : map.entrySet()) {
            System.out.println("Branch: " + e1.getKey());
            for (Map.Entry<Integer, Long> e2 : e1.getValue().entrySet()) {
                System.out.println("Month: " + e2.getKey() + "Valor: " + e2.getValue());
            }
        }
        System.out.println("Query time: " + time);
    }

    public void query2(int numberSales, int distinctClients,String time) {
        System.out.println("Number of sales: " + numberSales);
        System.out.println("Number of distinct clients: " + distinctClients);
        System.out.println("time: " + time);
    }

    public void query3(Map<Integer, Query3Triple> map,String time) {
        for(int i = 1; i <= Config.maxMonth; i++) {
            System.out.println("Month: " + i);
            if (map.containsKey(i)) {
                System.out.print("    " + map.get(i));
            } else {
                System.out.println("    Number of sales: 0, Number of distinct clients: 0, Total Expenditure: 0");
            }
        }
        System.out.println("Query time: " + time);
    }

    public void query4(Map<Integer, Query4Triple> map,String time) {
        for(int i = 1; i <= Config.maxMonth; i++) {
            System.out.println("Month: " + i);
            if (map.containsKey(i)) {
                System.out.print("    " + map.get(i));
            } else {
                System.out.println("    Number of sales: 0, Number of distinct clients: 0, Total Expenditure: 0");
            }
        }
        System.out.println("Query time: " + time);
    }

    public void query5(Map<Integer, Set<String>> map,String time) {
        map.forEach((key, value) -> System.out.println("Product:" + value + " Quantity:" + key));
        System.out.println("Query time: " + time);
    }

    public void query6(List<Map.Entry<String, Long>> list,String time) {
        for(Map.Entry<String,Long> e: list) {
            System.out.println("Id: " + e.getKey() + ", Distinct clients: " + e.getValue());
        }
        System.out.println("Query time: " + time);
    }

    public void query7(Map<Integer,List<String>> map,String time) {
        for(Map.Entry<Integer,List<String>> e: map.entrySet()){
            System.out.println(e.getKey());
            System.out.println(e.getValue());
        }
        System.out.println("Query time: " + time);
    }

    public void query8(List<Map.Entry<String, Long>> list,String time) {
         for(Map.Entry<String,Long> e: list){
            System.out.println(e);
         }
         System.out.println("Query time: " + time);
    }

    public void query9(Map<Integer,Map<String,Float>> map,String time){
        map.forEach((key,value) -> value.forEach((key2,value2) -> System.out.println("Client:" + key2 + " Quantity:" + key + " Expenditure:" + value2)));
        System.out.println("Query time: " + time);
    }

    public void query10(String key, float[][] value, String time){
        System.out.println("Product: " + key);
        for (int month = 0; month < Config.maxMonth; month++) {
            System.out.println("    Month " + month);
            for (int branch = 0; branch < Config.numberOfBranches; branch++) {
                System.out.println("        Branch " + branch + ":" + value[month][branch]);
            }
        }
        System.out.println("type `quit` to exit");
        System.out.println("type `next` to see the next product");
        System.out.println("Query time: " + time);
        queryPrompt(10);
    }

    public void loadObjectDoesNotExist(){
        System.out.println("Error: Object does not exist");
    }

    public void loadFilesDoesNotExist(){
        System.out.println("Error: File does not exist");
    }

    public void invalidSaveFormat(){
        System.out.println("Error: File format not valid");
    }

    public void usageErrorHelp(){
        System.out.println("Usage: help [function].");
        System.out.println("Try `help` for more information.");
    }

    public void usageErrorSave(){
        usageErrorStd("save"," [Object's name]");
    }

    public void usageErrorLoad(){
        usageErrorStd("load"," [sales filepath]");
    }

    public void usageErrorQ1_1(){
        usageErrorStd("query1_1","");
    }

    public void usageErrorQ1_2_1(){
        usageErrorStd("query1_2_1","");
    }

    public void usageErrorQ1_2_2(){
        usageErrorStd("query1_2_2","");
    }

    public void usageErrorQ1_2_3(){
        usageErrorStd("query1_2_3","");
    }

    public void usageErrorQ1(){
        usageErrorStd("query1","");
    }

    public void usageErrorQ2(){
        usageErrorStd("query2"," month [branch]");
    }

    public void usageErrorQ3(){
        usageErrorStd("query3"," clientID");
    }

    public void usageErrorQ4(){
        usageErrorStd("query4"," productID");
    }

    public void usageErrorQ5(){
        usageErrorStd("query5"," clientID");
    }

    public void usageErrorQ6(){
        usageErrorStd("query6"," limit");
    }

    public void usageErrorQ7(){
        usageErrorStd("query7","");
    }

    public void usageErrorQ8() {
        usageErrorStd("query8"," limit");
    }

    public void usageErrorQ9() {
        usageErrorStd("query9"," productID limit");
    }

    @Override
    public void usageErrorQ10() {
        usageErrorStd("query10","");
    }

    private void usageErrorStd(String name,String args){
        System.out.println("Usage: " + name + args + ".");
        System.out.println("Try `help " + name +"` for more information.");
    }

    public void clear(){
        for(int i = 0; i < 100; i++) out.println();
    }
}
