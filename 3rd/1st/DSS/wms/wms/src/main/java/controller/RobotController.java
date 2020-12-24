package controller;

import model.IWMS;

public class RobotController extends UserController implements IRobotController {

    public RobotController(String id, IWMS wms) {
        super(id, wms);
    }

    @Override
    public void notifyPickUp(String RobotId, String idJob) {
        this.wms.robotNotifiesPickUp(RobotId, idJob);
    }

    @Override
    public void notifyDelivery(String RobotId, String idJob) {
        this.wms.robotNotifiesDelivery(RobotId, idJob);
    }
}
