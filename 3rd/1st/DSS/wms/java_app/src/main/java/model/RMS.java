package model;

import database.*;
import javafx.util.Pair;
import util.Matrix;
import util.PathFinder;

import java.util.*;
import java.util.stream.Collectors;

public class RMS implements IRMS {

  private Map<String, Notification> notifications;
  private RobotDAO robotDAO;
  private JobRobotDAO jobDAO;
  private NotificationDAO notificationDAO;

  private Map<String, Pair<Station, Station>> jobs;

  private List<Pair<Robot, String>> ongoing;
  private List<Robot> robots;
  PathFinder pathFinder;

  public RMS() {
    this.notifications = new NotificationDAO();
    this.jobs = new HashMap<>();
    this.ongoing = new ArrayList<>();
    this.robots = new ArrayList<>();

    this.robotDAO = new RobotDAO();
    this.jobDAO = new JobRobotDAO();
    this.notificationDAO = new NotificationDAO();

    Matrix matrix = new Matrix(20, 20);

    this.pathFinder = new PathFinder(matrix);
  }

  public RMS(List<Pair<Integer, Integer>> shelfCoordenates) {
    this.notifications = new NotificationDAO();
    this.jobs = new HashMap<>();
    this.ongoing = new ArrayList<>();
    this.robots = new ArrayList<>();

    this.robotDAO = new RobotDAO();
    this.jobDAO = new JobRobotDAO();
    this.notificationDAO = new NotificationDAO();

    Matrix matrix = new Matrix(20, 20);
    matrix.setShelvesCoords(shelfCoordenates);

    this.pathFinder = new PathFinder(matrix);
  }

  public RobotDAO getRobotDAO() {
    return robotDAO;
  }

  public void setRobotDAO(RobotDAO robotDAO) {
    this.robotDAO = robotDAO;
  }

  public JobRobotDAO getJobDAO() {
    return jobDAO;
  }

  public void setJobDAO(JobRobotDAO jobDAO) {
    this.jobDAO = jobDAO;
  }

  private double robotPalletHeuristic(Robot robot, Station station) {
    return Math.sqrt(
        Math.pow(station.getCoordinates().getKey() - robot.getCoordinates().getKey(), 2)
            + Math.pow(station.getCoordinates().getValue() - robot.getCoordinates().getValue(), 2));
  }

  @Override
  public void setJobs(Map<String, Pair<Station, Station>> jobs) {
    this.jobs = jobs;
  }

  @Override
  public void setRobots(List<Robot> robots) {
    this.robots = robots;
  }

  public void notifyRobot(Robot robot, String idJob, Pair<Station, Station> job) {
    System.out.println("");
    System.out.println("Assigned Robot #" + robot.getId() + " to job #" + idJob);
    System.out.println("Primeira rota: ");
    this.pathFinder.printPath(
        this.pathFinder.search(robot.getCoordinates(), job.getKey().getCoordinates()));
    System.out.println("Segunda rota: ");
    this.pathFinder.printPath(
        this.pathFinder.search(job.getKey().getCoordinates(), job.getValue().getCoordinates()));
  }

  @Override
  public Integer getNumberOfRobots() {
    return this.robotDAO.size();
  }

  public Map<String, String> getNotifications() {
    Map<String, String> notifications = new HashMap();
    this.notifications.values().stream()
        .forEach(n -> notifications.put(n.getId().toString(), n.getText()));
    return notifications;
  }

  @Override
  public void assignJobs(StationDAO stationDAO) {
    Map<String, Pair<Station, Station>> jobs = new HashMap<>();
    List<Robot> robots = new ArrayList<>();

    Map<String, Pair<String, String>> temp1 = this.jobDAO.generateJobs();

    temp1.forEach(
        (k, v) ->
            jobs.put(
                k,
                new Pair<>(
                    (new Shelf(v.getKey(), stationDAO.getCoords(v.getKey()), 0)),
                    (new Shelf(v.getValue(), stationDAO.getCoords(v.getValue()), 0)))));

    setJobs(jobs);
    Map<String, List<String>> temp2 = this.robotDAO.allRobots();
    temp2.forEach(
        (k, v) ->
            robots.add(
                new Robot(
                    k,
                    Integer.parseInt(v.get(0)),
                    Integer.parseInt(v.get(1)),
                    Integer.parseInt(v.get(2)),
                    fromStatus(v.get(4)))));

    setRobots(robots);

    Pair<List<String>, List<String>> res = assignJobs_aux();
    res.getKey()
        .forEach(
            id -> {
              this.robotDAO.changeRobotStatus(id, "BUSY");
            });
    res.getValue()
        .forEach(
            id -> {
              this.jobDAO.changeJobStatus(id, "EXECUTING");
            });
  }

  private Pair<List<String>, List<String>> assignJobs_aux() {
    this.ongoing = new ArrayList<>();
    List<Robot> available =
        this.robots.stream().filter(Robot::isAvailable).collect(Collectors.toList());
    List<Pair<Robot, String>> assignedJobs = new ArrayList<>();
    Map<String, Pair<Station, Station>> jobs_aux = new HashMap<>(jobs);

    for (Robot r : available) {
      Map.Entry<String, Pair<Station, Station>> job =
          jobs_aux.entrySet().stream()
              .sorted(
                  (e1, e2) ->
                      (int)
                          (robotPalletHeuristic(r, e1.getValue().getKey())
                              - robotPalletHeuristic(r, e2.getValue().getValue())))
              .findFirst()
              .orElse(null);

      if (job != null) {
        assignedJobs.add(new Pair<>(r, job.getKey()));
        jobs_aux.remove(job.getKey());
      }
    }

    assignedJobs.forEach(
        p -> {
          notifyRobot(p.getKey(), p.getValue(), jobs.get(p.getValue()));
          this.ongoing.add(new Pair<>(p.getKey(), p.getValue()));
        });

    return new Pair<>(
        this.ongoing.stream().map(p -> p.getKey().getId()).collect(Collectors.toList()),
        this.ongoing.stream().map(p -> p.getValue()).collect(Collectors.toList()));
  }

  @Override
  public void deleteAllNotifications() {
    this.notifications.clear();
  }

  @Override
  public void removeNotification(String s) {
    this.notifications.remove(s);
  }

  private boolean fromStatus(String status) {
    return status.equals("AVAILABLE");
  }

  @Override
  public void robotNotifiesPickUp(String robotId, String idJob, PalletDAO palletDAO) {
    Pair<Integer, Integer> coords = getJobDAO().getFirstPosition(idJob);
    getRobotDAO().changeRobotCoords(robotId, coords.getKey(), coords.getValue());
    String idPallet = getJobDAO().getPallet(idJob);
    String idStation = palletDAO.getStation(idPallet);
    palletDAO.changePalletStation(idPallet, robotId);
    switch (idStation) {
      case "1":
        notificationDAO.putNotification(
            "ROBOT \"ROB"
                + robotId
                + "\" PICKED UP "
                + palletDAO.get(idPallet).getType().toUpperCase()
                + " PALLET \"PAL"
                + idPallet
                + "\" FROM RECEIVING STATION");
        break;

      case "2":
        notificationDAO.putNotification(
            "ROBOT \"ROB"
                + robotId
                + "\" PICKED UP "
                + palletDAO.get(idPallet).getType().toUpperCase()
                + " PALLET \"PAL"
                + idPallet
                + "\" FROM SHIPPING STATION");
        break;

      default:
        notificationDAO.putNotification(
            "ROBOT \"ROB"
                + robotId
                + "\" PICKED UP "
                + palletDAO.get(idPallet).getType().toUpperCase()
                + " PALLET \"PAL"
                + idPallet
                + "\" FROM SHELF \"SHE"
                + idStation
                + "\"");
    }
  }

  @Override
  public void robotNotifiesDelivery(String robotId, String idJob, PalletDAO palletDAO) {
    Pair<Integer, Integer> coords = getJobDAO().getSecondPosition(idJob);
    getRobotDAO().changeRobotCoords(robotId, coords.getKey(), coords.getValue());
    String idPallet = getJobDAO().getPallet(idJob);
    String idStation = getJobDAO().getStation(idJob);
    palletDAO.changePalletStation(idPallet, idStation);
    getRobotDAO().changeRobotStatus(robotId, "AVAILABLE");
    getJobDAO().changeJobStatus(idJob, "COMPLETED");

    switch (idStation) {
      case "1":
        notificationDAO.putNotification(
            "ROBOT \"ROB"
                + robotId
                + "\" DROPPED "
                + palletDAO.get(idPallet).getType().toUpperCase()
                + " PALLET \"PAL"
                + idPallet
                + "\" IN RECEIVING STATION");
        break;

      case "2":
        notificationDAO.putNotification(
            "ROBOT \"ROB"
                + robotId
                + "\" DROPPED "
                + palletDAO.get(idPallet).getType().toUpperCase()
                + " PALLET \"PAL"
                + idPallet
                + "\" IN SHIPPING STATION");
        break;

      default:
        notificationDAO.putNotification(
            "ROBOT \"ROB"
                + robotId
                + "\" DROPPED "
                + palletDAO.get(idPallet).getType().toUpperCase()
                + " PALLET \"PAL"
                + idPallet
                + "\" IN SHELF \"SHE"
                + idStation
                + "\"");
    }
  }
}
