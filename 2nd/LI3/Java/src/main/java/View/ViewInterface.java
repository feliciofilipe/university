package View;

import Utilities.Query3Triple;
import Utilities.Query4Triple;

import java.util.List;
import java.util.Map;
import java.util.Set;

public interface ViewInterface {

     void load(String time);
     void typeHelp();
     void help();
     void helpFunction(String function);
     void prompt();
     void query1(List<String> products,int page,String time);
     void query1_1(String salesPath,int invalidSales, int numberOfProducts,int numberProductsBought, int numberProductsNotBought,
                         int numberOfClients, int numberOfClientsBuy, int numberOfClientsDidntBuy,int numberFreeSales,
                         float totalBilling, String time);
     void query1_2_1(Map<Integer,Long> map,String time);
     void query1_2_2(Map<Integer,Map<Integer,Double>> map,String time);
     void query1_2_3(Map<Integer,Map<Integer,Long>> map,String time);
     void query2(int numberSales, int distinctClients,String time);
     void query3(Map<Integer, Query3Triple> map,String time);
     void query4(Map<Integer, Query4Triple> map,String time);
     void query5(Map<Integer, Set<String>> map,String time);
     void query6(List<Map.Entry<String, Long>> list,String time);
     void query7(Map<Integer,List<String>> map,String time);
     void query8(List<Map.Entry<String, Long>> list,String time);
     void query9(Map<Integer,Map<String,Float>> map,String time);
     void query10(String key, float[][] value, String time);
     void loadFilesDoesNotExist();
     void loadObjectDoesNotExist();
     void invalidSaveFormat();
     void usageErrorSave();
     void usageErrorLoad();
     void usageErrorHelp();
     void usageErrorQ1_1();
     void usageErrorQ1_2_1();
     void usageErrorQ1_2_2();
     void usageErrorQ1_2_3();
     void usageErrorQ1();
     void usageErrorQ2();
     void usageErrorQ3();
     void usageErrorQ4();
     void usageErrorQ5();
     void usageErrorQ6();
     void usageErrorQ7();
     void usageErrorQ8();
     void usageErrorQ9();
     void usageErrorQ10();
     void clear();
}
