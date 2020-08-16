package Model;

import java.awt.geom.Point2D;

public abstract class Carrier extends Entitie implements java.io.Serializable{

    /**
     * Radius of a carrier
     */
    private Double radius;
    
    /**
     * Default Constructor
     */
    public Carrier(){
        super();
        this.radius = 0.0;
    }

    /**
     * Parameterized Constructor
     * @param ID
     * @param name
     * @param email Email of the user
     * @param password Password of the user
     * @param x
     * @param y
     * @param radius
     */
    public Carrier(String ID, String name, String email, String password, Double x, Double y, Double radius){
        super(ID,name,email,password,x,y);
        this.radius = radius;
    }

    /**
     * Clone Constructor
     * @param carrier
     */
    public Carrier(Carrier carrier){
        super(carrier);
        this.radius = carrier.getRadius();
    }

    /**
     * Function that gives the radius of a carrier
     * @return rage of the carrier
     */
    public double getRadius(){
        return this.radius;
    }


    /**
     * Fuction that verifies if a point is in range of the carrier
     * @return If the point is inside of the range
     */
    public boolean isInRange(Point2D point){
        Point2D center = this.getGPS();
        return center.distance(point) <= this.radius;
    }

    /**
     * Sets num instance of the radius
     * @param radius
     */
    public void setRadius(double radius) {
        this.radius = radius;
    }
}
