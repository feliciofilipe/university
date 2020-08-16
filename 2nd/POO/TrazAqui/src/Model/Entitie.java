package Model;

import Model.Model;
import java.awt.geom.Point2D;

public abstract class Entitie implements java.io.Serializable{

    /**
     * ID of the entity
     */
    private String ID_;

    /**
     * Name of the entitie
     */
    private String name;

    /**
     * Email of the entity
     */
    private String email;

    /**
     * Email of the entity
     */
    private String password;

    /**
     * Position X of the GPS location
     */
    private Double x;

    /**
     * Position Y of the GPS location
     */
    private Double y;


    /**
     * Default Constructor
     */
    public Entitie(){
        this.ID_ = "n/a";
        this.name = "n/a";
        this.email = "n/a";
        this.password = "n/a";
        this.x  = 0.0;
        this.y  = 0.0;
    }

    /**
     * Parameterized Constructor
     * @param ID ID of the entity
     * @param name Name of the entity
     * @param email Name of the entity
     * @param password Name of the entitie
     * @param x Coordinate X of the GPS
     * @param y Coordinate Y of the GPS
     */
    public Entitie(String ID,String name,String email,String password,Double x,Double y){
        this.ID_ = ID;
        this.name = name;
        this.email = email;
        this.password = password;
        this.x  = x;
        this.y  = y;
    }


    /**
     * Clone Constructor
     * @param entitie Class Entitie to be instantiated
     */
    public Entitie(Entitie entitie){
        this.ID_ = entitie.getID();
        this.name = entitie.getName();
        this.email = entitie.getEmail();
        this.password = entitie.getPassword();
        this.x  = entitie.getX();
        this.y  = entitie.getY();
    }

    /**
     * Returns the ID of the entity
     * @return ID of the entity
     */
    public String getID(){
        return this.ID_;
    }

    /**
     * Returns the name of the entitie
     * @return Name of the entitie
     */
    public String getName(){
        return this.name;
    }

    /**
     * Function that return the email of an entity
     * @return Email of the entity
     */
    public String getEmail() {
        return this.email;
    }

    /**
     * Function that return the password of an entity
     * @return Password of the entity
     */
    public String getPassword() {
        return this.password;
    }

    /**
     * Function that return the x position of an entity
     * @return X position of the entity
     */
    public Double getX() {return this.x;}

    /**
     * Function that return the y position of an entity
     * @return Y position of the entity
     */
    public Double getY() {return this.y;}


    /**
     * Returns coordinates of the entity
     * @return Coordinates of the entity
     */
    public Point2D getGPS(){
        return new Point2D.Double(this.x,this.y);
    }


    /**
     * Updates the ID of the entity
     * @param ID New ID of the entity
     */
    public void setID(String ID){
        this.ID_ = ID;
    }

    /**
     * Updates the name of the entity
     * @param name New name of the entity
     */
    public void setName(String name){
        this.name = name;
    }

    /**
     * Updates the email of the entity
     * @param email New email of the entity
     */
    public void setEmail(String email) {
        this.email = email;
    }

    /**
     * Updates the password of the entity
     * @param password New password of the entity
     */
    public void setPassword(String password) {
        this.password = password;
    }

    /**
     * Updates the x position of the entity
     * @param x New x position of the entity
     */
    public void setX(Double x){
        this.x = x;
    }

    /**
     * Updates the y position of the entite
     * @param y New y position of the entity
     */
    public void setY(Double y){
        this.y = y;
    }

    /**
     * Compares an object to the Entitie
     * @param obj Object to compare to
     * @return Whether the object and the Entitie are equal
     */
    @Override
    public boolean equals(Object obj){
        if(this == obj) return true;
        if(obj == null || this.getClass() != obj.getClass()) return false;
        Entitie entitie = (Entitie) obj;
        return this.ID_.equals(entitie.getID())
               && this.name.equals(entitie.getName())
               && this.x.equals(entitie.getX())
               && this.y.equals(entitie.getY());
    }


    /**
     * Turns the Entitie information to a String
     * @return String with the Entitie information
     */
    @Override
    public String toString(){
        StringBuilder sb = new StringBuilder();
        sb.append("\n")
          .append("ID: ").append(this.ID_).append("\n")
          .append("Name: ").append(this.name).append("\n")
          .append("Email: ").append(this.email).append("\n")
          .append("Password: ").append(this.password).append("\n")
          .append("X: ").append(this.x).append("\n")
          .append("Y: ").append(this.y).append("\n");

        return sb.toString();
    }

    /**
     * Clones an entity
     * @return Returns an Entitie cloned
     */
    public abstract Entitie clone();
}