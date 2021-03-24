package gui_controller;

import javafx.collections.FXCollections;
import javafx.collections.ObservableList;

import javafx.fxml.FXML;
import javafx.fxml.FXMLLoader;
import javafx.fxml.Initializable;

import javafx.scene.chart.BarChart;
import javafx.scene.chart.PieChart;
import javafx.scene.chart.XYChart;
import javafx.scene.control.Label;
import javafx.scene.layout.HBox;
import javafx.scene.layout.VBox;
import model.Admin;
import model.FloorWorker;
import model.Robot;
import model.TruckDriver;

import java.io.IOException;

import java.net.URL;

import java.util.List;
import java.util.ResourceBundle;

public class DashboardController extends UserController implements Initializable {

  @FXML
  private Label percentageLabel,
      totalCapacityLabel,
      welcomeLabel,
      robotCountLabel,
      floorWorkerCountLabel,
      truckDriverCountLabel,
      adminCountLabel;

  @FXML private VBox productsTable;

  @FXML private ObservableList<PieChart.Data> capacityChartData;

  @FXML private PieChart capacityChart;

  @FXML private XYChart.Series chartSeries;

  @FXML private BarChart<String, Integer> weeklyShipmentsChart;

  public void populate() {
    changeImage(wms.getPicture());
    changeUserName(wms.getName());
    changeWelcomeName(wms.getName());
    lastProductsTable(wms.getLastPallet());
    changeBarChart(wms.getWeeklyShipments());
    changePieChart(wms.getNumberOfPallets(), wms.getWarehouseCapacity());
    changeRobotValue(wms.getNumberOf(Robot.class));
    changeFloorWorkerValue(wms.getNumberOf(FloorWorker.class));
    changeTruckDriverValue(wms.getNumberOf(TruckDriver.class));
    changeAdminValue(wms.getNumberOf(Admin.class));
  }

  @FXML
  private void changeWelcomeName(String name) {
    welcomeLabel.setText("Welcome aboard, " + name);
  }

  @FXML
  private void lastProductsTable(List<List<String>> pallets) {
    pallets.forEach(this::changeLastProductsTable);
  }

  @FXML
  private void changeLastProductsTable(List<String> pallet) {

    FXMLLoader fxmlLoader = new FXMLLoader();
    fxmlLoader.setLocation(getClass().getResource("../views/dashboardTableRow.fxml"));

    try {
      HBox hbox = fxmlLoader.load();
      DashboardTableRowController dtrc = fxmlLoader.getController();
      dtrc.setData(pallet);
      productsTable.getChildren().add(hbox);

    } catch (IOException e) {
      e.printStackTrace();
    }
  }

  @FXML
  private void changePieChart(int pallets, int maximum) {
    capacityChartData.get(0).setPieValue(pallets);
    capacityChartData.get(1).setPieValue(maximum - pallets);
    capacityChart.setData(capacityChartData);

    percentageLabel.setText((int) (((double) pallets / maximum) * 100) + "%");

    totalCapacityLabel.setText(pallets + "/" + maximum);
  }

  @FXML
  private void changeBarChart(List<Integer> dataList) {
    int i = 0;

    for (XYChart.Series<String, Integer> series : weeklyShipmentsChart.getData()) {
      for (XYChart.Data<String, Integer> data : series.getData()) {
        data.setYValue(dataList.get(i));
        i++;
      }
    }
  }

  @FXML
  private void changeRobotValue(int value) {
    robotCountLabel.setText(String.valueOf(value));
  }

  @FXML
  private void changeFloorWorkerValue(int value) {
    floorWorkerCountLabel.setText(String.valueOf(value));
  }

  @FXML
  private void changeTruckDriverValue(int value) {
    truckDriverCountLabel.setText(String.valueOf(value));
  }

  @FXML
  private void changeAdminValue(int value) {
    adminCountLabel.setText(String.valueOf(value));
  }

  @Override
  public void initialize(URL url, ResourceBundle resourceBundle) {

    capacityChart.setClockwise(true);
    capacityChart.setStartAngle(91);

    capacityChartData = FXCollections.observableArrayList();
    capacityChartData.add(new PieChart.Data("Pallets", 0));
    capacityChartData.add(new PieChart.Data("Pallets", 0));

    // BARCHART

    chartSeries = new XYChart.Series<>();

    chartSeries.getData().add(new XYChart.Data("Mon", 0));
    chartSeries.getData().add(new XYChart.Data("Tue", 0));
    chartSeries.getData().add(new XYChart.Data("Wed", 0));
    chartSeries.getData().add(new XYChart.Data("Thu", 0));
    chartSeries.getData().add(new XYChart.Data("Fri", 0));
    chartSeries.getData().add(new XYChart.Data("Sat", 0));
    chartSeries.getData().add(new XYChart.Data("Sun", 0));

    weeklyShipmentsChart.getData().addAll(chartSeries);
  }
}
