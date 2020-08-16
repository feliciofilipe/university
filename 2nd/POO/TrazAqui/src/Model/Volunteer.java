package Model;

public class Volunteer extends Carrier implements java.io.Serializable {

    /**
     * Default Constructor
     */
    public Volunteer(){
        super();
    }

    /**
     * Parameterized Constructor
     * @param ID ID of the volunteer
     * @param name Name of the volunteer
     * @param email Email of the user
     * @param password Password of the user
     * @param x Coordinate X of the GPS
     * @param y Coordinate Y of the GPS
     */
    public Volunteer(String ID, String name, String email, String password, Double x, Double y,Double radius){
        super(ID,name,email,password,x,y,radius);
    }

    /**
     * Clone Constructor
     * @param volunteer Class Volunteer to be instantiated
     */
    public Volunteer(Volunteer volunteer){
        super(volunteer);
    }


    /**
     * Compares an object to the Volunteer
     * @param obj Object to compare to
     * @return Whether the object and the Volunteer are equal
     */
    @Override
    public boolean equals(Object obj){
        if(this == obj) return true;
        if(obj == null || this.getClass() != obj.getClass()) return false;
        Volunteer volunteer = (Volunteer) obj;
        return super.equals(volunteer);
    }

    /**
     * Turns the Volunteer information to a String
     * @return String with the Volunteer information
     */
    @Override
    public String toString(){
        return super.toString();
    }

    /**
     * Clones the Volunteer
     * @return Copie of the Volunteer
     */
    @Override
    public Volunteer clone(){
        return new Volunteer(this);
    }
}
