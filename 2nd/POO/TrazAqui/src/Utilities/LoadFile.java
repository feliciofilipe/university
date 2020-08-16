package Utilities;

import Model.Model;
import Model.User;
import Model.Transporter;
import Model.Volunteer;
import Model.Store;
import Model.Order;
import Model.Product;


import java.io.BufferedReader;
import java.io.FileReader;
import java.io.IOException;
import java.util.*;

public class LoadFile {

    /**
     * Function that loads the data of a file to the system
     * @param file Path to the file
     * @return The model load
     * @throws ClassNotFoundException e
     */
    public static Model loadData(String file) throws ClassNotFoundException {
        Model model = new Model();
        List<String> lines = LoadFile.readFile(file);

        for(String line : lines){
            LoadFile.createData(line,model);
        }
        return model;
    }

    /**
     * Auxiliary function that passes all lines of a file to a list of strings
     * @param file Path to the file
     * @return List of string from a file
     */
    public static List<String> readFile(String file) {
        List<String> lines = new ArrayList<>();
        String line;

        try {
            BufferedReader inFile = new BufferedReader(new FileReader(file));
            while ((line = inFile.readLine()) != null) lines.add(line);
        } catch (IOException e) {
            System.out.println(e.getMessage());
        }

        return lines;
    }

    /**
     * Auxiliary function that create the objects of the system
     * @param line Line of a file
     * @param model Model to add the object
     * @throws ClassNotFoundException e
     */
    public static void createData(String line, Model model) throws ClassNotFoundException {
        String[] entitie = line.split(":");
        String[] args = entitie[1].split(",");;

        switch(entitie[0]){
            case "Utilizador":
                User user = LoadFile.buildUser(args);
                if(user != null) model.add(user);
                else System.out.print("Invalid User");
                break;

            case "Transportadora":
                Transporter transporter = LoadFile.buildTransporter(args);
                if(transporter != null) model.add(transporter);
                else System.out.print("Invalid Transporter");
                break;

            case "Voluntario":
                Volunteer volunteer = LoadFile.buildVolunteer(args);
                if(volunteer != null) model.add(volunteer);
                else System.out.print("Invalid Volunteer");
                break;

            case "Loja":
                Store store = LoadFile.buildStore(args);
                if(store != null) model.add(store);
                else System.out.print("Invalid Store");
                break;
            case "Encomenda":
                Order order = LoadFile.buildOrder(args);
                model.setStoreCatalog(order);
                if(order != null) model.addOrder(order.getUserID(),order);
                else System.out.print("Invalid Order");
                break;
            case "Aceite":
                break;
            default:
                break;
        }
    }


    /**
     * Auxiliary function that builds a user from a array of string
     * @param args Array of arguments of the user
     * @return User built
     */
    public static User buildUser(String[] args){
        String ID, name;
        double x,y;

        try{
            ID = args[0];
            name = args[1];
            x = Double.parseDouble(args[2]);
            y = Double.parseDouble(args[3]);
        }

        catch (InputMismatchException | NumberFormatException e){
            return null;
        }

        return new User(ID,name, null, null,x,y);
    }

    /**
     * Auxiliary function that builds a transport from a array of string
     * @param args Array of arguments of the transporter
     * @return Transporter built
     */
    public static Transporter buildTransporter(String[] args){
        String ID, name,TIN;
        double x,y,radius,fee;

        try{
            ID = args[0];
            name = args[1];
            x = Double.parseDouble(args[2]);
            y = Double.parseDouble(args[3]);
            TIN = args[4];
            radius = Double.parseDouble(args[5]);
            fee = Double.parseDouble(args[6]);
        }

        catch (InputMismatchException | NumberFormatException e){
            return null;
        }

        return new Transporter(ID,name, null, null,x,y,radius,TIN,fee,1);
    }


    /**
     * Auxiliary function that builds a volunteer from a array of string
     * @param args Array of arguments of the volunteer
     * @return Volunteer built
     */
    public static Volunteer buildVolunteer(String[] args){
        String ID, name;
        double x,y,radius;

        try{
            ID = args[0];
            name = args[1];
            x = Double.parseDouble(args[2]);
            y = Double.parseDouble(args[3]);
            radius = Double.parseDouble(args[4]);
        }

        catch (InputMismatchException | NumberFormatException e){
            return null;
        }

        return new Volunteer(ID,name, null, null,x,y,radius);
    }

    /**
     * Auxiliary function that builds a store from a array of string
     * @param args Array of arguments of the store
     * @return Store built
     */
    public static Store buildStore(String[] args){
        double x,y;

        try{
            x = Double.parseDouble(args[2]);
            y = Double.parseDouble(args[3]);
        }
        catch (InputMismatchException | NumberFormatException e){
            return null;
        }

        return new Store(args[0],args[1], null, null,x,y);
    }

    /**
     * Auxiliary function that builds a order from a array of string
     * @param args Array of arguments of the order
     * @return Order built
     */
    public static Order buildOrder(String[] args){
        String orderID, userID, storeID;
        Double weight;
        Map<String, Product> map = new HashMap<>();

        try{
            orderID = args[0];
            userID = args[1];
            storeID = args[2];
            weight = Double.parseDouble(args[3]);
            for(int i = 4; i < args.length;i+=4){
                Product product = new Product(args[i],args[i+1],Double.parseDouble(args[i+2]),Double.parseDouble(args[i+3]));
                map.put(product.getProductID(),product);
            }
        }

        catch (InputMismatchException | NumberFormatException e){
            return null;
        }

        return new Order(orderID,userID,storeID,weight,map);
    }

}