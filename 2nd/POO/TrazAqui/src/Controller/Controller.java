package Controller;

import Model.*;
import Model.Exceptions.AuthenticationErrorException;
import Utilities.*;
import View.*;

import java.io.IOException;
import java.lang.reflect.*;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.time.DateTimeException;
import java.time.LocalDateTime;
import java.util.*;
import java.util.List;
import java.util.stream.Collectors;
import java.util.stream.Stream;


public class Controller {

    /**
     * Model of the system
     */
    private Model model;

    /**
     * View of the system
     */
    private final View view;

    /**
     * Parameterized Constructor
     * @param model Class Model to be instantiated
     * @param view Class view to ve instantiated
     */
    public Controller(Model model, View view){
        this.model = model;
        this.view = view;
    }

    /**
     * Function that start the program and puts the system running
     */
    public void run() {
        try { load(Config.ObjectsFile); }
        catch (IOException | ClassNotFoundException e) {}

        Scanner scanner = new Scanner(System.in);
        boolean in = true;
        while (in) {
            this.view.showln(Resources.greeter);
            this.view.prompt("Menu","TrazAqui");
            String commandline = scanner.nextLine();
            String[] input = commandline.split(" ");
            if (input.length > 0) {
                switch (input[0]) {
                    case "Login":
                        try{
                        if (input.length == 3 || input.length == 2) login(input);
                        }catch (AuthenticationErrorException e) {
                            view.error(e.getMessage());
                        }
                        break;

                    case "SignUp":
                        try {
                            if (input.length == 1) signUp();
                        }
                        catch (ClassNotFoundException e){
                            view.error(e.getMessage());
                        }
                        break;
                    case "Exit":
                        if (input.length == 1) in = false;
                        break;
                    case "TransporterTotalIncome":
                        if (input.length == 4) getTotalIncome(input);
                            break;
                    case "MostActiveUsers":
                        if (input.length == 1) view.show(model.mostActiveUsers());
                        break;
                    case "MostActiveTransporters":
                        if (input.length == 1) view.show(model.mostActiveTransporters());
                            break;
                    case "Load":
                        try {
                            if (input.length == 2) load(input[1]);
                        }
                        catch (IOException | ClassNotFoundException e){
                            view.error(e.getMessage());
                        }
                        break;

                    case "Save":
                        try {
                            if (input.length == 2) save(input[1]);
                        }
                        catch (IOException e) {
                            view.error(e.getMessage());
                        }
                        break;

                    case "Logs":
                        try {
                            if (input.length == 1) logs(input);
                        }
                        catch (ClassNotFoundException e) {view.error("Error while trying to load file");}
                        break;
                }
            }
        }
        try{ save(Config.ObjectsFile);}
        catch (IOException e){view.error("Error Saving File");}

    }

    /**
     * Function that interfaces the User input to show the Total Income System Query
     * @param input user input
     */
    public void getTotalIncome(String[] input) {
        try {
            Integer[] date1 = Arrays.stream(input[2].split("/")).map(Integer::parseInt).toArray(Integer[]::new);
            Integer[] date2 = Arrays.stream(input[3].split("/")).map(Integer::parseInt).toArray(Integer[]::new);
            LocalDateTime localDate1 = LocalDateTime.of(date1[2], date1[1], date1[0],0,0,0);
            LocalDateTime localDate2 = LocalDateTime.of(date2[2], date2[1], date2[0],23,59,59);
            view.show(model.getTotalIncome(input[1], localDate1, localDate2));
        } catch (DateTimeException e){
            view.show("Invalid inputs - remember we use the metric system");
        }
        catch (AuthenticationErrorException e){
            view.error(Config.ErrorSetting("Non-existant entity."));

        }
    }

    /**
     * Function that loads the system from a file
     * @param input Array of inputs that contains the file to read from
     * @throws ClassNotFoundException e
     */
    public void logs(String[] input) throws ClassNotFoundException {
        if(input.length == 1)
            this.model = LoadFile.loadData(Config.logsFile);
        else
            this.model = LoadFile.loadData(input[1]);
    }

    /**
     * Function that saves the state of the system in a file
     * @param input Path to the file to be saved
     * @throws IOException e
     */
    public void save(String input) throws IOException {
        model.saveObject(input);
    }

    /**
     * Function that loads the system from a file
     * @param input Path to the file to read
     * @throws IOException e
     * @throws ClassNotFoundException e
     */
    public void load(String input) throws IOException, ClassNotFoundException {
        this.setModel(model.readObject(input));
    }

    /**
     * Updates the model
     * @param model Model to be set
     */
    public void setModel(Model model) {
        this.model = model.clone();
    }


    /**
     * Function that makes the login and invokes the methods of an entity
     * @param input Array of inputs from the user
     * @throws IndexOutOfBoundsException e
     * @throws AuthenticationErrorException e
     */
    public void login(String[] input) throws AuthenticationErrorException {
        String[] real_input = new String[3];
        Scanner scanner = new Scanner(System.in);
        boolean boool = false,bool = true;

        try{

        if(this.model.contains(input[1]) || !this.model.isValidEmail(input[1])) {
            if (input.length == 2 && !model.hasPassword(input[1])) {
                String name_ = this.model.getEntitie(input[1]).getName();
                view.showTitle(name_);
                view.showln("Imported from log (transition from previous app version)");
                view.showln("Please set a new password");
                view.prompt(input[1], "setPassword");
                String newPassword = scanner.nextLine();
                model.setPassword(input[1],newPassword);
                real_input[2] = newPassword;
                bool = false;
            }
            real_input[0] = input[0];
            real_input[1] = input[1];
            if(bool) real_input[2] = input[2];
            if (model.login(real_input[1], real_input[2])){
                boolean in = true;
                while (in) {
                    String name = this.model.getEntitie(real_input[1]).getName();
                    String ID = this.model.getEntitie(real_input[1]).getID();
                    String clazzName = this.model.getEntitie(real_input[1]).getClass().getName().replace("Model.", "");
                    view.showTitle(name);
                    Class interfac3 = Class.forName("Controller." + clazzName + "Interface");
                    Method[] methods = interfac3.getMethods();
                    for (int i = 0; i < methods.length; i++) {
                        view.show(methods[i].getName());
                        Parameter[] parameters = methods[i].getParameters();
                        for (int j = 0; j < parameters.length; j++) {
                            view.show(",");
                            view.show(parameters[j].getType().getName().replace("java.lang.", ""));
                        }
                        view.showln(" ");
                    }
                    view.showln("Quit");
                    view.prompt(ID, model.getEntitie(ID).getClass().getName().replace("Model.", "") + "Prompt");

                    Class clazz = Class.forName("Controller." + clazzName + "InteractiveController");
                    try{
                        Class[] constructorArgsClasses = {Model.class, View.class ,String.class};
                        Object interactiveController = clazz.getConstructor(constructorArgsClasses).newInstance(this.model, this.view ,ID);

                        String commandline = scanner.nextLine();
                        String[] real_input2 = commandline.split(",");
                        if (real_input2[0].equals("Quit") && real_input2.length == 1) {
                            in = false;
                        } else {
                            boool = false;
                            for (int i = 0; i < methods.length; i++) {
                                if (methods[i].getName().equals(real_input2[0])){
                                    view.showln(methods[i].invoke(interactiveController, argsGenerator(real_input2, methods[i].getParameterTypes())));
                                    view.showln(Config.EnterToContinue);
                                    scanner.nextLine();
                                    boool = true;
                                    }
                                }
                            }
                            if(!boool && in) view.error(Config.InvalidOption);
                        }
                    catch (IndexOutOfBoundsException | NoSuchMethodException | SecurityException | IllegalAccessException | InstantiationException | IllegalArgumentException | InvocationTargetException e ){
                        view.error(Config.InvalidOption);
                        }
                    }
                }
                else throw new AuthenticationErrorException("Not Enought Inputs");
            }
        }
        catch (IndexOutOfBoundsException | ClassNotFoundException e) {
            view.error("Someting Went Wrong With The Login");
        }
    }

    /**
     * Function that generates the arguments of an function to be invoked
     * @param input Array of inputs from the user of the program
     * @param types Type of the inputs
     * @return Array of objects that can be used to invoke a method
     * @throws InvocationTargetException e
     * @throws NoSuchMethodException e
     * @throws InstantiationException e
     * @throws IllegalAccessException e
     */
    private Object[] argsGenerator(String[] input, Class<?>[] types) throws InvocationTargetException, NoSuchMethodException, InstantiationException, IllegalAccessException {

        Object[] args = new Object[types.length];
        for(int i = 0; i < types.length; i++){
            args[i] = parseObjectFromString(input[i+1],types[i]);
        }
        return args;
    }

    /**
     * Function that allows the user to make a Signup to the program
     * @throws ClassNotFoundException e
     */
    public void signUp() throws ClassNotFoundException {
        boolean in = true;
        while (in) {
            view.showTitle("SignUp");
            view.showln("OPTIONS:");
            Scanner scanner = new Scanner(System.in);
            List<String> classesNames = getClasses("src/Model");
            assert classesNames != null;
            Object[] classes = sortClassesByHierarchicalOrder(toArray(classesNames, "src/"));
            Map<String, Field[]> fields = toFieldMap(classes);
            for (int i = 0; i < classes.length; i++) {
                if (!Modifier.isAbstract(Class.forName(classes[i].toString()).getModifiers())) {
                    String clazz = classes[i].toString();
                    Field[] array = Arrays.stream(fields.get(clazz)).filter(s -> !(s.getName().startsWith("_") || s.getName().endsWith("_"))).toArray(Field[]::new);
                    view.show(clazz.replace("Model.", "") + ",");
                    for (int j = 0; j < array.length; j++) {
                        if(j != array.length-1){
                            view.show(array[j].getName() + ",");
                        }else{
                            view.show(array[j].getName());
                        }
                    }
                    view.showln("");
                }
            }
            view.showln("Quit");
            view.prompt("SignUp", "TrazAqui");
            String commandline = scanner.nextLine();
            String[] input_aux = commandline.split(",");
            String[] input = new String[input_aux.length + 1];
            input[0] = input_aux[0];
            for(int i = 1 ; i < input_aux.length ; i++) input[i+1] = input_aux[i];
            if(input_aux.length > 1) input[1] = model.generateID(Character.toLowerCase(input_aux[0].charAt(0)));

            if (input_aux.length == 1 && input_aux[0].equals("Quit")) {
                in = false;
            } else if(input.length > 4 && fields.containsKey("Model."+input[0])) {
                if (model.isValidEmail(input[3])){
                    in = register(input, Arrays.stream(fields.get("Model." + input[0])).filter(f -> !f.getName().startsWith("_")).toArray(Field[]::new));
                } else {
                    view.show("An account with this email already exists within this application");
                }
            } else view.error(Config.InvalidOption);
        }
    }

    /**
     * Auxiliary function that register an user
     * @param input e
     * @param fields e
     * @return Whether the register was accomplished or not
     */
    private boolean register(String[] input,Field[] fields){
        Scanner scanner = new Scanner(System.in);
        try {
            model.add("Model." + input[0], argsGenerator(input, fields), fields);
            view.showln(input[0] + ": " + model.getEntitie(input[3]).getID() + " added with success");
        } catch (Exception e) {
            view.showln("Invalid inputs - Try Again");
            view.showln("Press \"ENTER\" To Continue");
            scanner.nextLine();
        }
        return true;
    }

    /**
     * Function that generates the arguments of an function to be invoked
     * @param input Array of inputs from the user of the program
     * @param fields Fields of the inputs
     * @return Array of objects that can be used to invoke a method
     * @throws InvocationTargetException e
     * @throws NoSuchMethodException e
     * @throws InstantiationException e
     * @throws IllegalAccessException e
     */
    private Object[] argsGenerator(String[] input,Field[] fields) throws InvocationTargetException, NoSuchMethodException, InstantiationException, IllegalAccessException {
        Object[] args = new Object[fields.length];
        for(int i = 0; i < fields.length; i++){
            args[i] = parseObjectFromString(input[i+1],fields[i].getType());
        }
        return args;
    }

    /**
     * Parses a String to any type of Object
     * @param s String to be parsed
     * @param clazz Class to be parsed to
     * @param <T> Abstract return type
     * @return Object parsed from String
     * @throws NoSuchMethodException
     * @throws IllegalAccessException
     * @throws InvocationTargetException
     * @throws InstantiationException
     */
    public static <T> T parseObjectFromString(String s, Class<T> clazz) throws NoSuchMethodException, IllegalAccessException, InvocationTargetException, InstantiationException {
        return clazz.getConstructor(new Class[] {String.class }).newInstance(s);
    }

    /**
     * Constructs a map with the Fields of Classes
     * @param classes Array of Classes
     * @return map with the Fields of Classes
     * @throws ClassNotFoundException
     */
    private Map<String,Field[]> toFieldMap(Object[] classes) throws ClassNotFoundException {
        Map<String,Field[]> map = new HashMap<>();
        Field[] aux;
        for(int i = 0; i < classes.length; i++) {
            if (!Modifier.isAbstract(Class.forName(classes[i].toString()).getModifiers())) {
                List<Field> fields = new ArrayList<>();
                for (int j = 0; j < classes.length; j++) {
                    if(Class.forName(classes[j].toString()).isAssignableFrom(Class.forName(classes[i].toString()))) {
                        aux = Class.forName(classes[j].toString()).getDeclaredFields();
                        for (int k = 0; k < aux.length; k++) {
                            fields.add(aux[k]);
                        }
                    }
                }
                map.put(classes[i].toString(), fields.toArray(Field[]::new));
            }
        }
        return map;
    }

    /**
     * Sort the classes according to their hierarchy
     * @param old - Array of Classes
     * @return Array of Classes by order
     * @throws ClassNotFoundException
     */
    private Object[] sortClassesByHierarchicalOrder(Object[] old) throws ClassNotFoundException {
        Object[] classes = new Object[old.length];
        int[] noSubClasses = new int[old.length];
        boolean[] visited = new boolean[old.length];
        for(int i = 0; i < old.length; i++) {
            for (int j = 0; j < old.length; j++) {
                if(Class.forName(old[i].toString()).isAssignableFrom(Class.forName(old[j].toString()))){
                    noSubClasses[i]++;
                }
            }
        }
        int index = 0;
        boolean flag;
        for(int k = 0; k < noSubClasses.length; k++){
            flag = true;

            for(int m = 0; m < noSubClasses.length && flag ; m++)
                if(!visited[m]){
                    index = m;
                    flag = false;
                }
            for(int l = 0; l < noSubClasses.length; l++) {
                if ((!visited[l]) && noSubClasses[l] > noSubClasses[index]) index = l;
            }
            classes[k] = old[index];
            visited[index] = true;
        }
        return classes;
    }

    /**
     * Transform a List of String to an Array of Classes
     * @param list List with Strings
     * @param path path to remove from Strings
     * @return Array of Classes
     */
    private Object[] toArray(List<String> list, String path){
        return list.stream().map(s -> s.replace(path, ""))
                .map(s -> s.replace("/","."))
                .map(s -> s.replace(".java", ""))
                .filter(s -> isSubclass(s,Entitie.class))
                .toArray();
    }

    /**
     * Test if a String is the name of a subclass of a given Class
     * @param subClass String with the name of the subclass
     * @param clazz Class to be tested against
     * @return boolean value asserting if a String is the name of a subclass of a given Class
     */
    private boolean isSubclass(String subClass,Class clazz){
        try {
            return clazz.isAssignableFrom(Class.forName(subClass));
        } catch (ClassNotFoundException ignored) {

        }
        return false;
    }

    /**
     * Gets all the files names ending in .java in a given path
     * @param path given path
     * @return the files names
     */
    public static List<String> getClasses(String path){
        try (Stream<Path> walk = Files.walk(Paths.get(path))) {
            return walk.filter(Files::isRegularFile)
                       .map(Path::toString)
                       .filter(s -> s.endsWith(".java"))
                       .collect(Collectors.toList());
        } catch (IOException ignored) {

        }
        return null;
    }
}