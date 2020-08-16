import Model.GuestVendas;
import Model.GuestVendasInterface;
import View.*;
import Controller.*;

public class GuestVendasAppMVC {
    public static void main(String[] args) {
        GuestVendasInterface guestVendas = new GuestVendas();
        ViewInterface view = new View();
        ControllerInterface controller = new Controller(guestVendas,view);
        controller.run();
    }
}
