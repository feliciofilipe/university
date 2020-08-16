package Model;

import Model.Exceptions.AuthenticationErrorException;
import Model.Exceptions.InvalidIDException;
import Utilities.Config;

import java.awt.geom.Point2D;
import java.io.*;
import java.lang.reflect.Constructor;
import java.lang.reflect.Field;
import java.lang.reflect.InvocationTargetException;


import java.time.LocalDateTime;
import java.time.LocalTime;

import java.util.*;
import java.util.stream.Collectors;

public class Model implements Serializable {

    /**
     * Map of entities on the system
     */
    private Map<String, Entitie> entities;

    /**
     * Map of records
     */
    private Map<String,List<Record>> records;

    /**
     * Map of orders on the system
     */
    private Map<String,Map<String,Order>> orders;


    /**
     * Default Constructor
     */
    public Model(){
        this.entities = new HashMap<>();
        this.records = new HashMap<>();
        this.orders = new HashMap<>();
    }

    /**
     * Parameterized Constructor
     * @param entities Entity of a system
     * @param records Records of a system
     * @param orders Orders of a system
     */
    public Model(Map<String,Entitie> entities,Map<String,List<Record>> records , Map<String,Map<String,Order>> orders){
        setEntities(entities);
        setRecords(records);
        setOrders(orders);
    }

    /**
     * Clone Constructor
     * @param model Class Model to be instantiated
     */
    public Model(Model model){
        this.entities = model.getEntities();
        this.records = model.getRecords();
        this.orders = model.getOrders();
    }


    /**
     * Function that gets all entities of the system
     * @return Entities of the system
     */
    public Map<String, Entitie> getEntities() {
        Map<String, Entitie> entities = new HashMap<>();
        this.entities.forEach((k,v) -> entities.put(k,v.clone()));
        return entities;
    }


    /**
     * Function that gets all records from the system
     * @return Records from the system
     */
    public Map<String, List<Record>> getRecords() {
        Map<String, List<Record>> records = new HashMap<>();
        for(Map.Entry<String, List<Record>> e : this.records.entrySet()){
            List<Record> aux = new ArrayList<>();
            e.getValue().forEach(v -> aux.add(v.clone()));
            records.put(e.getKey(),aux);
        }
        return records;
    }

    /**
     * Function that gets all orders from the system
     * @return Orders from the system
     */
    public Map<String, Map<String, Order>> getOrders() {
        Map<String, Map<String, Order>> orders = new HashMap<>();
        for(Map.Entry<String, Map<String, Order>> o : this.orders.entrySet()){
            Map<String,Order> aux = new HashMap<>();
            o.getValue().forEach((k,v) -> aux.put(k,v.clone()));
            orders.put(o.getKey(),aux);
        }
        return orders;
    }

    /**
     * Updates entities of the system
     * @param entities Entities
     */
    public void setEntities(Map<String, Entitie> entities) {
        this.entities = new HashMap<>();
        entities.forEach((k,v) -> this.entities.put(k,v.clone()));
    }

    /**
     * Updates Orders of the system
     * @param orders Orders
     */
    public void setOrders(Map<String, Map<String, Order>> orders) {
        this.orders = new HashMap<>();
        for(Map.Entry<String, Map<String, Order>> o : orders.entrySet()){
            Map<String,Order> aux = new HashMap<>();
            o.getValue().forEach((k,v) -> aux.put(k,v.clone()));
            this.orders.put(o.getKey(),aux);
        }
    }

    /**
     * Updates records of the system
     * @param records Records
     */
    public void setRecords(Map<String, List<Record>> records) {
        this.records = new HashMap<>();
        for(Map.Entry<String, List<Record>> e : records.entrySet()){
            List<Record> aux = new ArrayList<>();
            e.getValue().forEach(v -> v.clone());
            this.records.put(e.getKey(),aux);
        }
    }

    /**
     * Function that gets an specific entity
     * @param input Entity ID
     * @return Specific entity
     */
    public Entitie getEntitie(String input){
        if (this.entities.containsKey(input)) return this.entities.get(input);
        else return getEntitieFromEmail(input);
    }

    /**
     * Function that gets an specific entity from his email
     * @param email Entity ID
     * @return Specific entity
     */
    public Entitie getEntitieFromEmail(String email){
        for(Entitie e : this.entities.values())
            if(Objects.equals(e.getEmail(),email)) return e;
        return null;
    }

    /**
     * Function that creates and adds an entity to the system
     * @param className Class Name of the entity
     * @param args Arguments of the entity
     * @param fields Fields of the entity
     * @throws ClassNotFoundException e
     * @throws NoSuchMethodException e
     * @throws IllegalAccessException e
     * @throws InvocationTargetException e
     * @throws InstantiationException e
     */
    public void add(String className, Object[] args, Field[] fields) throws ClassNotFoundException, NoSuchMethodException, IllegalAccessException, InvocationTargetException, InstantiationException {
        Class clazz = Class.forName(className);
        Constructor constructor = clazz.getConstructor(fieldTypes(fields));
        Entitie e = (Entitie) constructor.newInstance(args);
        this.entities.put(e.getID(),e);
    }

    /**
     * Adds an entity to the system
     * @param e Entity ID
     */
    public void add(Entitie e) {
        this.entities.put(e.getID(),e);
    }


    /**
     * Function that gets a array of class
     * @param fields Fields
     * @return Array of classes
     */
    private Class[] fieldTypes(Field[] fields) {
        Class[] types = new Class[fields.length];
        for (int i = 0; i < fields.length; i++) {
            types[i] = fields[i].getType();
        }
        return types;
    }

    /**
     * Function that verifies if a entity can make the login
     * @param input Email or ID of the entity
     * @param password Password of the entity
     * @return Whether the entity make the login of not
     */
    public boolean login(String input, String password){
        return (this.entities.containsKey(input) && Objects.equals(this.entities.get(input).getPassword(),password) ||
               (!isValidEmail(input) && validateEmailPass(input,password)));
    }

    /**
     * Function that saves a file of objects
     * @param objectPath Path to save the file
     * @throws IOException e
     */
    public void saveObject(String objectPath) throws IOException {
        FileOutputStream fos = new FileOutputStream(objectPath);
        BufferedOutputStream bos = new BufferedOutputStream(fos);
        ObjectOutputStream oos = new ObjectOutputStream(bos);
        oos.writeObject(this);
        oos.flush();
        oos.close();
    }

    /**
     * Function that reads a file of objects
     * @param filename Path to rread the file
     * @return The model of the system
     * @throws IOException e
     * @throws ClassNotFoundException e
     */
    public Model readObject(String filename) throws IOException, ClassNotFoundException {
        ObjectInputStream o = new ObjectInputStream((new FileInputStream(filename)));
        Model t = (Model) o.readObject();
        o.close();
        return t;
    }

    /**
     * Function that verifies if an ID is on the system
     * @param ID ID to be verified
     * @return Whether the iD is on the system or not
     */
    public boolean contains(String ID){
        return this.entities.containsKey(ID);
    }

    /**
     * Function that verifies if the email is valid
     * @param email Email to ve verified
     * @return Whether the email is valid or not
     */
    public boolean isValidEmail(String email){
        return !containsEmail(email);
    }

    /**
     * Function that verifies if the email is on the system
     * @param email Email to ve verified
     * @return Whether the email is on the system on not
     */
    public boolean containsEmail(String email){
        return this.entities.values()
                            .stream()
                            .anyMatch(p -> Objects.equals(p.getEmail(),email));
    }

    /**
     * Function that verifies if the email correct with the password
     * @param input Email
     * @param password Password
     * @return Whether the email and pass are correct
     */
    public boolean validateEmailPass(String input, String password){
        return this.entities.values().stream().anyMatch(e -> Objects.equals(e.getEmail(),(input)) && Objects.equals(e.getPassword(),password));
    }

    /**
     * Function that the ID is on the system
     * @param ID ID
     * @return Whether the id is on the system or not
     */
    public boolean containsID(String ID){
        return this.entities.values()
                            .stream()
                            .anyMatch(p -> Objects.equals(p.getID(),ID));
    }

    /**
     * Function that verifies if the entity has password
     * @param input Entity ID
     * @return Whether the Entity has password
     */
    public boolean hasPassword(String input){
        return this.entities.get(input).getPassword() != null;
    }

    /**
     * Function that generates Entities ID's
     * @param chr Type of entity
     * @return ID of the entity
     */
    public String generateID(char chr){
        String ID = null;
        int n = (int) this.entities.keySet().stream().filter(k -> k.charAt(0) == chr).count();
        ID = chr + Integer.toString(n);
        while (this.entities.containsKey(ID))
            ID = chr + Integer.toString(n++);
        return ID;
    }

    /**
     * Function that adds a record to the system
     * @param ID ID of the Entity
     * @param record Record to be saved
     */
    private void addRecord(String ID,Record record){
        if(this.records.containsKey(ID)){
            List<Record> list = this.records.get(ID);
            list.add(record);
            this.records.put(ID,list);
        }else {
            List<Record> list = new ArrayList<Record>();
            list.add(record);
            this.records.put(ID,list);
        }
    }

    /* QUERIES E FUNCOES A SER USADAS PARA AS QUERIES */
    //indicar o total facturado por uma empresa transportadora num determinado período;
    public Double getTotalIncome(String ID, LocalDateTime start, LocalDateTime end) throws AuthenticationErrorException{
        Entitie m = getEntitie(ID);
        if (m == null || !(m instanceof Transporter))
            throw new AuthenticationErrorException(Config.InvalidTransporter);
        List<Record> records = this.records.get(ID);
        if (this.records.get(ID) == null)
            return 0.0;
        return records.stream().filter(p -> (p.getDate().isAfter(start) && (p.getDate().isBefore(end))))
                .map(p -> p.getTransporterPrice()).reduce(0.0, Double::sum);
    }

    //determinar a listagens dos 10 utilizadores que mais utilizam o sistema (em número de encomendas transportadas);
    public Map<Integer,List<User>> mostActiveUsers(){
        Map<Integer,List<User>> ret = new TreeMap<>(Collections.reverseOrder());
        for (Entitie e: this.entities.values().stream().filter(p -> p instanceof User).collect(Collectors.toList())){
            User f = (User) e; // garantIDo por causa do filter
            int num = 0;
            if (this.records.containsKey(f.getID()))
                num = this.records.get(f.getID()).size();
            List<User> l = ret.computeIfAbsent(num, k -> new ArrayList<>());
            l.add(f);
        }
        return ret;
    }

   // determinar a listagens das 10 empresas transportadoras que mais utilizam o sistema (em número de kms percorridos);
   public Map<Double,List<Transporter>> mostActiveTransporters(){
        Map<Double,List<Transporter>> ret = new TreeMap<>(Collections.reverseOrder());
        for (Entitie e: this.entities.values().stream().filter(p -> p instanceof Transporter).collect(Collectors.toList())){
            double totalMileage = 0.0;
            Transporter f = (Transporter) e; // garantido por causa do filter
            if (this.records.containsKey(f.getID())){
                Map<String, String> userAndStore = this.records.get(f.getID())
                        .stream().collect(Collectors.toMap(p -> p.getUserID(), p -> p.getStoreID())); // (Id do utilisador, Id da loja)
                for (Map.Entry<String, String> entry : userAndStore.entrySet()) {
                    totalMileage += ((e.getGPS().distance(((Store) this.entities.get(entry.getKey())).getGPS())));
                    totalMileage += (((Store) this.entities.get(entry.getValue())).getGPS()).distance(((User) this.entities.get(entry.getKey())).getGPS());
                }
            }
            List<Transporter> l = ret.computeIfAbsent(totalMileage, k -> new ArrayList<>());
            l.add(f);
        }
        return ret;
    }

    //ORDERS

   public void cleanStoreOrder(String storeID,String userID){
        if(this.entities.containsKey(storeID)){
            Store store = (Store) this.entities.get(storeID);
            store.cleanStoreOrder(userID);
            this.entities.put(storeID,store);
        }
   }

    public void addOrder(String userID,Order order) throws ClassNotFoundException {
        User user = (User) this.entities.get(userID);
        if(user.get_carrier() != null){
            if(this.orders.containsKey(user.get_carrier())) {
                Map<String, Order> inner_map = this.orders.get(user.get_carrier());
                inner_map.put(order.getOrderID(),order);
                this.orders.put(user.get_carrier(), inner_map);
            }else{
                Map<String, Order> inner_map = new HashMap<String, Order>();
                inner_map.put(order.getOrderID(),order);
                this.orders.put(user.get_carrier(), inner_map);
            }
        }else {
            if(this.orders.containsKey(Config.Carrier)) {
                Map<String, Order> inner_map = this.orders.get(Config.Carrier);
                inner_map.put(order.getOrderID(),order);
                this.orders.put(Config.Carrier, inner_map);
            }else{
                Map<String, Order> inner_map = new HashMap<String, Order>();
                inner_map.put(order.getOrderID(),order);
                this.orders.put(Config.Carrier, inner_map);
            }
        }
    }

    public String generateOrderID(){
        Integer n = this.orders.values().stream().map(Map::size).reduce(0, Integer::sum);
        return "o" + n;
    }

    private boolean containsOrder(String orderID){
        return this.orders.values().stream().anyMatch(m -> m.containsKey(orderID));
    }

    private void updateOrderWithCarrier(String orderID,String carrierID){
        Optional<Map<String, Order>> map = this.orders.values().stream().filter(m -> m.containsKey(orderID)).findFirst();
        if(map.isPresent()) {
            if (map.get().containsKey(orderID)) {
                Order order = map.get().get(orderID);
                order.setCarrierID(carrierID);
                Carrier carrier = (Carrier) this.entities.get(carrierID);
                map.get().put(orderID,order);
                this.orders.put(carrier.getClass().getName(),map.get());
            }
        }
    }

    //STORES

    public List<Store> getStoreList(){
        List<Store> res = new ArrayList<>();
        for (Entitie e : this.getEntities().values())
            if (e instanceof Store) res.add((Store) e);
        return res;
    }

    public boolean validateStoreId(String storeID){
        Entitie test = this.entities.get(storeID);
        return  (test != null && (test instanceof Store));
    }


    public String storeAddProduct(String storeID,Product product){
        if(this.entities.containsKey(storeID)){
            Store store = (Store) this.entities.get(storeID);
            if(store.productDoesNotExit(product.getDescription())) {
                store.addProduct(product);
                return Config.ProductAdded(product.getProductID(),product.getDescription());
            }
            return Config.ProductAlreadyExists;
        }
        return Config.StoreDoesntExists(storeID);
    }

    public void setStoreCatalog(Order order){
        if(this.entities.containsKey(order.getStoreID())){
            Store store = (Store) this.entities.get(order.getStoreID());
            store.setProductCatalog(order.getProductList());
        }
    }

    public Map<String,Product> storeSeeCatalog(String storeID){
        if(this.entities.containsKey(storeID)){
            Store store = (Store) this.entities.get(storeID);
            return store.getProductCatalog();
        }
        return new HashMap<String,Product>();
    }

    public String removeStoreProduct(String storeID,String productID){
        if(this.entities.containsKey(storeID)){
            Store store = (Store) this.entities.get(storeID);
            return store.removeProduct(productID);
        }
        return Config.StoreDoesntExists(storeID);
    }

    //USER

    public void setUserStoreID(String userID,String storeID){
        if(this.entities.containsKey(userID)){
            User user = (User) this.entities.get(userID);
            user.set_storeToBuyFromID(storeID);
            this.entities.put(userID,user);
        }
    }

    public String addToUserCart(String userID,String productID,Double quantity){
        if(this.entities.containsKey(userID)) {
            User user = (User) this.entities.get(userID);
            if(this.entities.containsKey(user.get_storeToBuyFromID())) {
                Store store = (Store) this.entities.get(user.get_storeToBuyFromID());
                if (store.isProductValid(productID)) {
                    user.addToCart(productID, quantity);
                    this.entities.put(userID, user);
                    return Config.AddToCart(quantity, productID);
                }
                return Config.ProductDoesntExists(productID);
            }
            return Config.StoreDoesntExists(user.get_storeToBuyFromID());
        }
        return Config.UserIDDoesntExists(userID);
    }

    public String userMakeOrder(String userID){
        if(this.entities.containsKey(userID)){
            User user = (User) this.entities.get(userID);
            if(user.get_cart().size() != 0) {
                Store store = (Store) this.entities.get(user.get_storeToBuyFromID());
                store.addUserRequest(userID, user.get_cart());
                user.set_cart(new HashMap<>());//reset the cart
                this.entities.put(store.getID(), store);
                this.entities.put(userID, user);
            }
            return Config.CartIsEmpty;
        }
        return Config.UserIDDoesntExists(userID);
    }

    public void setTypeOfOrder(String userID,String carrier){
        if(this.entities.containsKey(userID)){
            User user = (User) this.entities.get(userID);
            user.set_carrier(carrier);
            this.entities.put(userID,user);
        }
    }

    public Map<String,Double> getUserCart(String userID){
        if(this.entities.containsKey(userID)){
            User user = (User) this.entities.get(userID);
            return user.get_cart();
        }
        return null;
    }

    public Map<String,Map<String,Double>> getStoreUserRequests(String storeID){
        if(this.entities.containsKey(storeID)){
            Store store = (Store) this.entities.get(storeID);
            return store.getUserRequests();
        }
        return null;
    }

    public boolean userRequestExists(String storeID, String userID){
        if(this.entities.containsKey(storeID)){
            Store store = (Store) this.entities.get(storeID);
            return store.userRequestExists(userID);
        }
        return false;
    }

    public String getUserTransportOffers(String userID){
        if(this.entities.containsKey(userID)){
            User user = (User) this.entities.get(userID);
            return user.get_transportOffers().toString();
        }
        return null;
    }

    public String acceptUserTransportOfferOnOrder(String userID,String orderID,String transporterID){
        if(this.entities.containsKey(userID)){
            User user = (User) this.entities.get(userID);
            if(user.containsTransportOffer(transporterID,orderID)) {
                user.cleanTransporterOffersOnOrder(orderID);
                user.addToBeRated(orderID);
                updateOrderWithCarrier(orderID,transporterID);
                return Config.TransporterOfferAccepted;
            }
            return Config.OrderDoesntHaveOffer(orderID,transporterID);
        }
        return Config.UserIDDoesntExists(userID);
    }


    public String userRatesOrder(String userID,String orderID,Double rating){
        if(this.entities.containsKey(userID)) {
            User user = (User) this.entities.get(userID);
            if(rating >= 0.0 && rating <= 10.0) {
                if (containsOrder(orderID)) {
                    if(user.isToBeRated(orderID)) {
                        Optional<Map.Entry<String, Map<String, Order>>> maybeEntry = this.orders.entrySet().stream().filter(e -> e.getValue().containsKey(orderID)).findFirst();
                        if (maybeEntry.isPresent()) {
                            if (maybeEntry.get().getValue().containsKey(orderID)) {
                                Order order = maybeEntry.get().getValue().get(orderID);
                                Record record = new Record(order, rating, order.getOrderTotalValue());
                                addRecord(order.getUserID(), record);
                                addRecord(order.getStoreID(), record);
                                addRecord(order.getCarrierID(), record);
                                //Remover do Order do Sistema
                                Map<String, Order> map = maybeEntry.get().getValue();
                                map.remove(orderID);
                                this.orders.put(maybeEntry.get().getKey(), map);
                                return Config.ThanksForFeedback;
                            }
                            return Config.OrderDoesntExists(orderID);
                        }
                    }
                    return "This order is not completed";
                }
                return Config.OrderWaitingForRating(orderID);
            }
            return Config.PleaseRateBetween;
        }
        return Config.UserIDDoesntExists(userID);
    }

    public Set<String> seeUserOrdersNeedingRating(String userID){
        if(this.entities.containsKey(userID)){
            User user = (User) this.entities.get(userID);
            return user.get_toBeRated();
        }
        return new HashSet<>();
    }

    public Map<String,Product> userSeeStoreCatalog(String userID){
        if(this.entities.containsKey(userID)){
            User user = (User) this.entities.get(userID);
            if(this.entities.containsKey(user.get_storeToBuyFromID())){
                Store store = (Store) this.entities.get(user.get_storeToBuyFromID());
                return store.getProductCatalog();
            }
        }
        return new HashMap<String, Product>();
    }

    //CARRIER
    public List<Order> getPossibleOrders(String carrierID){
        if(this.entities.containsKey(carrierID)){
            Carrier carrier = (Carrier) this.entities.get(carrierID);
            List<Order> orders = new ArrayList<Order>();
            if(this.orders.containsKey(carrier.getClass().getName().replace("Model.",""))) {
                this.orders.get(carrier.getClass().getName())
                        .values()
                        .stream()
                        .filter(o -> isInRange(carrier,o))
                        .filter(o -> o.getCarrierID() == null)
                        .map(Order::clone)
                        .forEach(orders::add);
            }
            if(this.orders.containsKey(Config.Carrier)){
                this.orders.get(Config.Carrier)
                        .values()
                        .stream()
                        .filter(o -> isInRange(carrier,o))
                        .filter(o -> o.getCarrierID() == null)
                        .map(Order::clone)
                        .forEach(orders::add);
            }
            return orders;
        }
        return new ArrayList<Order>();
    }

    public Product getProductFromCatalog(String storeID,String productID){
        if(this.entities.containsKey(storeID)){
            Store store = (Store) this.entities.get(storeID);
            return store.getProductCatalog().get(productID);
        }
        return null;
    }

    private boolean isInRange(Carrier carrier,Order order){
        return carrier.isInRange(this.entities.get(order.getUserID()).getGPS())
                && carrier.isInRange(this.entities.get(order.getStoreID()).getGPS());
    }

    //TRANSPORTER
    public String makeOfferOnOrderTransporter(String transporterID,String orderID) {
        if (this.entities.containsKey(transporterID)) {
            Transporter transporter = (Transporter) this.entities.get(transporterID);
            if(transporter.get_noDeliveringOrders() < transporter.getMaxOrders()) {
                Map<String, Order> carrierOrders = new HashMap<String, Order>();
                if (this.orders.containsKey(Config.Carrier)) {
                    carrierOrders = getOrders().get(Config.Carrier);
                }
                if (carrierOrders.containsKey(orderID)) {
                    Order order = carrierOrders.get(orderID);
                    User user = (User) this.entities.get(order.getUserID());
                    Store store = (Store) this.entities.get(order.getStoreID());
                    Double price = transporter.getPriceForOrder(user.getGPS(), store.getGPS());
                    LocalTime waitingTimeStore = getWatingTime(store.getID());
                    LocalTime timeDistance = getDistanceTime(transporter.getGPS(),user.getGPS(),store.getGPS());
                    LocalDateTime totalTime = getTotalTime(waitingTimeStore,timeDistance);
                    user.addTransportOffer(new Offer(orderID, transporterID, price, order.getOrderTotalValue(),totalTime));
                    return Config.OfferSuccess;
                }


                Map<String, Order> transporterOrders = new HashMap<String, Order>();
                if (this.orders.containsKey(transporter.getClass().getName())) {
                    transporterOrders = getOrders().get(Config.Carrier);
                }
                if (transporterOrders.containsKey(orderID)) {
                    Order order = transporterOrders.get(orderID);
                    User user = (User) this.entities.get(order.getUserID());
                    Store store = (Store) this.entities.get(order.getStoreID());
                    Double price = transporter.getPriceForOrder(user.getGPS(), store.getGPS());
                    LocalTime waitingTimeStore = getWatingTime(store.getID());
                    LocalTime timeDistance = getDistanceTime(transporter.getGPS(),user.getGPS(),store.getGPS());
                    LocalDateTime totalTime = getTotalTime(waitingTimeStore,timeDistance);
                    user.addTransportOffer(new Offer(orderID, transporterID, price, order.getOrderTotalValue(),totalTime));
                    return Config.OfferSuccess;
                }
                return Config.MaxNumberOfOrders;
            }
            return Config.OrderDoesntExists(orderID);
        }
        return Config.TransporterDoesntExists(transporterID);
    }

    public LocalDateTime getTotalTime(LocalTime storeWaitingTime, LocalTime distanceTime){
        LocalTime aux = LocalTime.of(storeWaitingTime.getHour(),storeWaitingTime.getMinute(),storeWaitingTime.getSecond(),0);
        aux = aux.plusHours(distanceTime.getHour()).plusMinutes(distanceTime.getMinute()).plusSeconds(distanceTime.getSecond());
        LocalDateTime total = LocalDateTime.now();
        return total.plusHours(aux.getHour()).plusMinutes(aux.getMinute()).plusSeconds(aux.getSecond());
    }

    public LocalTime getDistanceTime(Point2D transporterGPS, Point2D userGPS, Point2D storeGPS){
        LocalTime time = LocalTime.of(0,0,0,0);
        return time.plusMinutes((long) ((transporterGPS.distance(userGPS) * 0.5) + (transporterGPS.distance(storeGPS) * 0.5)));
    }

    public LocalTime getWatingTime(String storeID){
        LocalTime time = LocalTime.of(0,0,0,0);
        Set<Order> ordersFromStore = new HashSet<>();
        this.orders.values().forEach(m -> ordersFromStore.addAll(m.values().stream().filter(o -> o.getStoreID().equals(storeID)).collect(Collectors.toSet())));

        for(Order order : ordersFromStore){
            time = time.plusMinutes((long) (order.getWeight() * 0.1) + (long) (order.getProductList().size() * 0.4));
        }

        return time;
    }


    //VOLUNTEER

    public String acceptVolunteerOrder(String volunteerID,String orderID) {
        if (this.entities.containsKey(volunteerID)) {
            Volunteer volunteer = (Volunteer) this.entities.get(volunteerID);
            if (isValidOrderForThisClass(orderID, volunteer.getClass().getName())) {
                    Optional<Map.Entry<String, Map<String, Order>>> maybeEntry = this.orders.entrySet().stream().filter(e -> e.getValue().containsKey(orderID)).findFirst();
                    if (maybeEntry.isPresent()) {
                        if (maybeEntry.get().getValue().containsKey(orderID)) {
                            Order order = maybeEntry.get().getValue().get(orderID);
                            if (order.isAvailableForDelivery()){
                                if (this.entities.containsKey(order.getUserID())) {
                                    User user = (User) this.entities.get(order.getUserID());
                                    user.addToBeRated(orderID);
                                    updateOrderWithCarrier(orderID, volunteerID);
                                    return Config.ThanksFroAcceptingOffer;
                                }
                                return Config.BibleMessage;
                            }
                            return Config.OrderAlreadyOnDelivery;
                        }
                    }
                    return Config.OrderDoesntHaveOfferFromVolunteer(orderID,volunteerID);
                }
                return Config.NotAllowedToAcceptOffer;
            }
        return Config.VolunteerDoesntExists(volunteerID);
    }


    private boolean isValidOrderForThisClass(String orderID,String clazz){
        boolean bool = false;
        if(this.orders.containsKey(Config.Carrier)){
            bool = this.orders.get(Config.Carrier).containsKey(orderID);
        }
        if(this.orders.containsKey(clazz)){
            bool |= this.orders.get(clazz).containsKey(orderID);
        }
        return bool;
    }


    //SETTERS WRAPPERS ON ENTITIES
    public List<Record> getRecord(String ID){
        return new ArrayList<>(this.records.get(ID));
    }


    public String setID(String input,String ID){
        if(this.entities.containsKey(input)) {
            this.entities.get(input).setID(ID);
            return Config.CorrectlySet("ID");
        }
        else return Config.ErrorSetting("ID");
    }

    public String setPassword(String input,String password){

        if(this.entities.containsKey(input)) {
            this.entities.get(input).setPassword(password);
            return Config.CorrectlySet("Password");
        }
        else return Config.ErrorSetting("Password");
    }

    public String setEmail(String input,String email){
        if(!email.equals("") && isValidEmail(email) && this.entities.containsKey(input)) {
            this.entities.get(input).setEmail(email);
            return Config.CorrectlySet("Email");
        }
        else return Config.ErrorSetting("Email");
    }

    public String setName(String input,String name){

        if(!name.equals("") && this.entities.containsKey(input)) {
            this.entities.get(input).setName(name);
            return Config.CorrectlySet("Name");
        }
        else return Config.ErrorSetting("Name");
    }

    public String setX(String input,String x){

        try {
            Double realX = Double.parseDouble(x);
            if(this.entities.containsKey(input)) {
                this.entities.get(input).setX(realX);
                return Config.CorrectlySet("X");
            }
            else return Config.InvalidInput;
        }
        catch (NullPointerException e){
            return Config.ErrorSetting("X");
        }
    }

    public String setY(String input,String y){

        try {
            Double realY = Double.parseDouble(y);
            if(this.entities.containsKey(input)) {
                this.entities.get(input).setY(realY);
                return Config.CorrectlySet("Y");
            }
            else return Config.InvalidInput;
        }
        catch (NullPointerException e){
            return Config.ErrorSetting("Y");
        }
    }


    public String setFee(String input,String fee)  {
        try {
            Double realFee = Double.parseDouble(fee);
            if (this.entities.get(input) instanceof Transporter){
                Transporter transporter = (Transporter) this.entities.get(input);
                transporter.setFee(realFee);
                return Config.CorrectlySet("Fee");
            }
            else return Config.ErrorValidating("Transporter");

        }
        catch (NumberFormatException e){
            return Config.ErrorSetting("Fee");
        }
    }

    public String setMaxOrders(String input,String maxOrders) {

        try {
            Integer realMaxOrders = Integer.parseInt(maxOrders);
            if (this.entities.get(input) instanceof Transporter){
                Transporter transporter = (Transporter) this.entities.get(input);
                transporter.setMaxOrders(realMaxOrders);
                return Config.CorrectlySet("MaxOrders");
            }
            else return Config.ErrorValidating("Transporter");

        }
        catch (NumberFormatException e){
            return Config.ErrorSetting("MaxOrders");
        }
    }


    public String setRadius(String entitie,String radius) throws InvalidIDException {

        try {
            Double realRadius = Double.parseDouble(radius);
            if (getEntitie(entitie) instanceof Carrier) {
                Carrier carrier = (Carrier) getEntitie(entitie);
                carrier.setRadius(realRadius);
                return Config.CorrectlySet("Radius");
            } else throw new InvalidIDException(Config.ErrorValidating("Transporter"));

        } catch (NumberFormatException e) {
            throw new InvalidIDException(Config.ErrorValidating("Radius"));
            // return Config.ErrorSetting("Radius");
        }

    }

    public String setTIN(String input,String tin) throws InvalidIDException {
        if(!tin.equals("") && this.entities.containsKey(input)) {

            if (this.entities.get(input) instanceof Transporter){
                Transporter transporter = (Transporter) this.entities.get(input);
                transporter.setTIN(tin);
                return Config.CorrectlySet("TIN");
            }

            else throw new InvalidIDException(Config.ErrorValidating("Transporter"));
        }

        else return Config.ErrorSetting("TIN");
    }

    @Override
    public Model clone(){
        return new Model(this);
    }

}