package model;

import java.util.Map;

public class TruckDriver extends User {

    private Truck truck;
    // TODO: POR TRUCK NA BASE DE DADOS
    public TruckDriver(
            String id,
            String firstName,
            String lastName,
            String salt,
            String password,
            Boolean active) {
        super(id, firstName, lastName, salt, password, active);
        this.truck = new Truck("truck", 0, 0, 10);
    }

    public void removeAllPallets() {
        this.truck.removeAllPallets();
    }

    public Map<String, Pallet> getPallets() {
        return this.truck.getPallets();
    }
}
