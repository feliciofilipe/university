package model;

public class FloorWorker extends User {

    public FloorWorker(
            String id,
            String firstName,
            String lastName,
            String salt,
            String password,
            Boolean active) {
        super(id, firstName, lastName, salt, password, active);
    }

    @Override
    public String toString() {
        return super.toString();
    }
}
