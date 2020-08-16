package Model;


public class MedicalSupliesVolunteer extends Volunteer implements java.io.Serializable{

    /**
     * Parameterized Constructor
     */
    public MedicalSupliesVolunteer(String ID,String name,String email,String password,Double x,Double y,Double radius){
        super(ID,name,email,password,x,y,radius);
    }

}
