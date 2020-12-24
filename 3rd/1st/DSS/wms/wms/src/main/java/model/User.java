package model;

import util.Passwords;

public abstract class User extends SystemEntity {

    private String firstName;
    private String lastName;
    private String salt;
    private String password;
    private Boolean active;

    public User(
            final String id,
            final String firstName,
            final String lastName,
            final String salt,
            final String password,
            final Boolean active) {
        super(id);
        this.firstName = firstName;
        this.lastName = lastName;
        this.salt = salt;
        this.password = password;
        this.active = active;
    }

    public User(User user) {
        super(user.getId());
        this.firstName = user.getFirstName();
        this.lastName = user.getLastName();
        this.salt = user.getSalt();
        this.password = user.getPassword();
        this.active = user.getActive();
    }

    public String getFirstName() {
        return firstName;
    }

    public void setFirstName(String firstName) {
        this.firstName = firstName;
    }

    public String getLastName() {
        return lastName;
    }

    public void setLastName(String lastName) {
        this.lastName = lastName;
    }

    public String getSalt() {
        return salt;
    }

    public void setSalt(String salt) {
        this.salt = salt;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public Boolean getActive() {
        return active;
    }

    public void setActive(Boolean active) {
        this.active = active;
    }

    public User setActiveAndReturnUser(Boolean active) {
        this.active = active;
        return this;
    }

    public boolean authenticate(final String input) {

        return Passwords.authenticate(input, this.getSalt(), this.getPassword());
    }

    @Override
    public String toString() {
        return "User{"
                + "firstName='"
                + firstName
                + '\''
                + ", lastName='"
                + lastName
                + '\''
                + ", salt='"
                + salt
                + '\''
                + ", password='"
                + password
                + '\''
                + ", active="
                + active
                + '}';
    }
}
