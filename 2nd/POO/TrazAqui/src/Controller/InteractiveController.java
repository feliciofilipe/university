package Controller;

import Model.*;
import Model.Record;
import View.*;


import java.util.ArrayList;
import java.util.List;
import java.util.Map;

public abstract class InteractiveController {

    /**
     * Model of the system
     */
    private Model model;

    /**
     * View of the system
     */
    private View view;

    /**
     * ID of the entity
     */
    private String ID;

    /**
     * Default Constructor
     */
    public InteractiveController(){
        this.model = null;
        this.view = null;
    }

    /**
     * Parameterized Constructor
     * @param model Model to be set
     * @param view View to be set
     * @param ID ID of the entity to be set
     */
    public InteractiveController(Model model,View view, String ID){
        this.model = model;
        this.view = view;
        this.ID = ID;
    }

    /**
     * Return the model of the system
     * @return Model of the system
     */
    public Model getModel(){
        return model;
    }

    /**
     * Returns the ID of the entity
     * @return ID of the entity
     */
    public String getID(){ return ID;}

    /**
     * Return the view of the system
     * @return View of the system
     */
    public View getView(){return view;}

    /**
     * Updates the view of the system
     * @param view New view of the system
     */
    public void setView(View view) {
        this.view = view;
    }

    /**
     * Function that get all the stores in the system and puts in a list of strings
     * @return List of string with all stores
     */
    public List<String> getStoreList(){
        List<String> list = new ArrayList<>();
        list.add("Store List:");
        model.getStoreList().stream().map(s -> "ID: " + s.getID() +(" Name: ") +  s.getName()).forEach(list::add);
        return list;
    }

    /**
     * Function that validates the ID of an store
     * @param ID ID to be validated
     * @return Whether the ID is valid or not
     */
    public boolean validateStoreId(String ID){
        return this.model.validateStoreId(ID);
    }

    /**
     * Function that gets all records and puts in a list of strings
     * @return List of string with all records
     */
    public List<Record> getRecord(){
        return getModel().getRecord(getID());
    }

    /**
     * Function that adds an request of a user to the store request list
     * @param order Order to be added
     * @param storeId Store where the order while be added
     * @param userId User that's making the request
     */
    public void addUserOrder(Map<String,Double> order, String storeId, String userId){
        Store store = (Store) this.model.getEntitie(storeId);
        store.addUserRequest(userId,order);
    }


    public static <T> T parseObjectFromString(String s, Class<T> clazz) throws Exception {
        return clazz.getConstructor(new Class[] {String.class }).newInstance(s);
    }

    /**
     * Function that gets the profile of an entity
     * @return String with all information from the entity
     */
    public String getProfile() {
        return this.model.getEntitie(getID()).toString();
    }

    /**
     * Function that sets new name of an entity
     * @param name New name of the entity
     * @return A string with the information if the name was while set
     */
    public String setName(String name){
        return getModel().setName(getID(),name);
    }

    /**
     * Function that sets new email of an entity
     * @param email New email of the entity
     * @return A string with the information if the email was while set
     */
    public String setEmail(String email){
        return getModel().setEmail(getID(),email);
    }

    /**
     * Function that sets new password of an entity
     * @param password New name of the entity
     * @return A string with the information if the password was while set
     */
    public String setPassword(String password){
        return getModel().setPassword(getID(),password);
    }

    /**
     * Function that sets new x position of an entity
     * @param x New name of the entity
     * @return A string with the information if the x position was while set
     */
    public String setX(String x) {
        return getModel().setX(getID(),x);
    }

    /**
     * Function that sets new y position of an entity
     * @param y New name of the entity
     * @return A string with the information if the y position was while set
     */
    public String setY (String y){
        return getModel().setY(getID(),y);
    }

}
