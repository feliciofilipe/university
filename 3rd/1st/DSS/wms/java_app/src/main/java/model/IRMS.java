package model;

import database.JobRobotDAO;
import database.PalletDAO;
import database.RobotDAO;
import database.StationDAO;
import javafx.util.Pair;

import java.util.List;
import java.util.Map;

public interface IRMS {

  RobotDAO getRobotDAO();

  void setRobotDAO(RobotDAO robotDAO);

  JobRobotDAO getJobDAO();

  void setJobDAO(JobRobotDAO jobDAO);

  Integer getNumberOfRobots();

  Map<String, String> getNotifications();

  void setJobs(Map<String, Pair<Station, Station>> jobs);

  void setRobots(List<Robot> robots);

  void assignJobs(StationDAO stationDao);

  void deleteAllNotifications();

  void removeNotification(String s);

  void robotNotifiesPickUp(String robotId, String idJob, PalletDAO palletDAO);

  void robotNotifiesDelivery(String robotId, String idJob, PalletDAO palletDAO);
}
