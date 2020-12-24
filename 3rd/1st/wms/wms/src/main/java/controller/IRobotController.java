package controller;


public interface IRobotController {

    void notifyPickUp(String RobotId, String idJob);

    void notifyDelivery(String RobotId, String idJob);
}
