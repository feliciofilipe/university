package controller;

import model.IWMS;
import util.Config;
import view.Output;

import java.lang.reflect.InvocationTargetException;

public class AdminController extends UserController implements IAdminController {

    /**
     * View of the system
     *
     * @param wms
     */
    public AdminController(String id, IWMS wms) {
        super(id, wms);
    }

    @Override
    public void acceptUser(String id)
            throws InvocationTargetException, NoSuchMethodException, InstantiationException,
                    IllegalAccessException {
        this.wms.acceptUser(id);
        Output.showln(Config.UserAccepted);
    }

    @Override
    public void denyUser(String id) {
        this.wms.removeUser(id);
        Output.showln("Removed");
    }

    @Override
    public void getNumberOf(String clazz) throws ClassNotFoundException {
        Output.showln(this.wms.getNumberOf(Class.forName("model." + clazz)));
    }

    @Override
    public void getWarehouseCapacity() {
        // TODO
    }

    @Override
    public void getNumberOfPallets() {
        // TODO
    }

    @Override
    public void getPendingUsers() {
        Output.showln(this.wms.getPendingUsers().toString());
    }

    @Override
    public void getEntryRequests() {
        Output.showln(this.wms.getEntryRequests().toString());
    }

    @Override
    public void acceptEntryRequest(String id) {
        try {
            this.wms.acceptEntryRequest(id);
            Output.showln(Config.EntryRequestAccepted);
        } catch (Exception e /*TODO*/) {
            e.printStackTrace(); // TODO
        }
    }

    @Override
    public void denyEntryRequest(String id) {
        this.wms.denyEntryRequest(id);
        Output.showln(Config.EntryRequestDenied);
    }

    @Override
    public void getPalletsLocations() {
        Output.showln(this.wms.getPalletsLocations().toString());
    }

    @Override
    public void assignJobs() {
        this.wms.assignJobs();
    }

    @Override
    public void getNotifications() {
        Output.showln(this.wms.getNotifications());
    }

    @Override
    public void deleteAllNotifications() {
        this.wms.deleteAllNotifications();
        Output.showln(Config.AllNotificationsRemoved);
    }

    @Override
    public void removeNotification(String s) {
        this.wms.removeNotification(s);
        Output.showln(Config.NotificationRemoved);
    }
}
