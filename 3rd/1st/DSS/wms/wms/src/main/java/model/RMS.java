package model;

import database.JobRobotDAO;
import database.NotificationDAO;
import database.RobotDAO;
import database.StationDAO;
import javafx.util.Pair;
import util.Matrix;
import util.PathFinder;

import java.util.*;
import java.util.stream.Collectors;

public class RMS implements IRMS {

    private Map<String, Notification> notifications;
    private RobotDAO robotDAO;
    private JobRobotDAO jobDAO;

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

        Matrix matrix = new Matrix(10, 10);
        matrix.setShelves(Arrays.asList(new Shelf("1", 0, 2, 10)));

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
                        + Math.pow(
                                station.getCoordinates().getValue()
                                        - robot.getCoordinates().getValue(),
                                2));
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
                this.pathFinder.search(
                        job.getKey().getCoordinates(), job.getValue().getCoordinates()));
    }

    @Override
    public Integer getNumberOfRobots() {
        return this.robotDAO.size();
    }

    public Map<String, String> getNotifications() {
        Map<String, String> notifications = new HashMap();
        this.notifications.values().stream().forEach(n -> notifications.put(n.getId().toString(),n.getText()));
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
                                        (new Shelf(
                                                v.getKey(), stationDAO.getCoords(v.getKey()), 0)),
                                        (new Shelf(
                                                v.getValue(),
                                                stationDAO.getCoords(v.getValue()),
                                                0)))));

        setJobs(jobs);
        Map<String, List<String>> temp2 = this.robotDAO.allRobots();
        temp2.forEach(
                (k, v) -> {
                    robots.add(
                            new Robot(
                                    k,
                                    Integer.parseInt(v.get(0)),
                                    Integer.parseInt(v.get(1)),
                                    Integer.parseInt(v.get(2)),
                                    fromStatus(v.get(4))));
                });

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

    @Override
    public void deleteAllNotifications() {
        this.notifications.clear();
    }

    @Override
    public void removeNotification(String s) {
        this.notifications.remove(s);
    }

    private Pair<List<String>, List<String>> assignJobs_aux() {
        this.ongoing = new ArrayList<>();
        List<Robot> available =
                this.robots.stream().filter(Robot::isAvailable).collect(Collectors.toList());
        List<Pair<Robot, String>> assignedJobs = new ArrayList<>();

        for (Robot r : available) {
            Map.Entry<String, Pair<Station, Station>> job =
                    jobs.entrySet().stream()
                            .sorted(
                                    (e1, e2) -> {
                                        return (int)
                                                (robotPalletHeuristic(r, e1.getValue().getKey())
                                                        - robotPalletHeuristic(
                                                                r, e2.getValue().getValue()));
                                    })
                            .findFirst()
                            .orElse(null);

            if (job != null) {
                assignedJobs.add(new Pair<>(r, job.getKey()));
            }
        }

        assignedJobs.forEach(
                p -> {
                    notifyRobot(p.getKey(), p.getValue(), jobs.get(p.getValue()));
                    this.ongoing.add(new Pair<>(p.getKey(), p.getValue()));
                    this.jobs.remove(p.getValue());
                });

        return new Pair<>(
                this.ongoing.stream().map(p -> p.getKey().getId()).collect(Collectors.toList()),
                this.ongoing.stream().map(p -> p.getValue()).collect(Collectors.toList()));
    }

    private boolean fromStatus(String status) {
        return status.equals("AVAILABLE");
    }
}
