package controller;

import model.IWMS;

public abstract class UserController {

    protected String id;
    protected IWMS wms;

    public UserController(String id, IWMS wms) {
        this.id = id;
        this.wms = wms;
    }
}
