package model;

public class Admin extends User {

    public Admin(
            String id,
            String firstName,
            String lastName,
            String salt,
            String password,
            Boolean active) {
        super(id, firstName, lastName, salt, password, active);
    }
}
