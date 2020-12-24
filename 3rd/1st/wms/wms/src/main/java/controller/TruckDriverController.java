package controller;

import model.IWMS;
import util.Config;
import view.Output;

import java.lang.reflect.InvocationTargetException;
import java.security.NoSuchAlgorithmException;

public class TruckDriverController extends UserController implements ITruckDriverController {

    public TruckDriverController(String id, IWMS wms) {
        super(id, wms);
    }

    @Override
    public void addPallet(String product, Integer quantity, String company, String type)
            throws NoSuchMethodException, IllegalAccessException, InvocationTargetException,
                    NoSuchAlgorithmException {
        this.wms.addUserPallet(
                this.id, this.wms.generatePalletID(), product, quantity, company, type);
        Output.showln(Config.palletAddedSuccessfully);
    }

    @Override
    public void removePallet(String id)
            throws NoSuchMethodException, IllegalAccessException, InvocationTargetException {
        this.wms.removeUserPallet(this.id, id);
        Output.showln(Config.palletRemovedSuccessfully);
    }

    @Override
    public void removeAllPallets()
            throws NoSuchMethodException, IllegalAccessException, InvocationTargetException {
        this.wms.removeAllUserPallets(this.id);
    }

    @Override
    public void getPallets()
            throws NoSuchMethodException, IllegalAccessException, InvocationTargetException {
        Output.showln(this.wms.getUserPallets(this.id).toString());
    }

    @Override
    public void makeEntryRequest()
            throws NoSuchMethodException, IllegalAccessException, InvocationTargetException {
        this.wms.makeEntryRequest(this.id);
        Output.showln(Config.EntryRequestSubmitted);
    }
}
