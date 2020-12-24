package model;

public class EntryRequest {

    private String palletID;
    private String product;
    private Integer quantity;
    private String company;
    private String type;
    private String truckID;

    public EntryRequest(
            String palletID,
            String product,
            Integer quantity,
            String company,
            String type,
            String truckID) {
        this.palletID = palletID;
        this.product = product;
        this.quantity = quantity;
        this.company = company;
        this.type = type;
        this.truckID = truckID;
    }

    public EntryRequest(Pallet pallet, String truckID) {
        this.palletID = pallet.getId();
        this.product = pallet.getProduct();
        this.quantity = pallet.getQuantity();
        this.company = pallet.getCompany();
        this.type = pallet.getType();
        this.truckID = truckID;
    }

    public String getId() {
        return palletID;
    }

    public void setId(String id) {
        this.palletID = id;
    }

    public String getProduct() {
        return product;
    }

    public void setProduct(String product) {
        this.product = product;
    }

    public Integer getQuantity() {
        return quantity;
    }

    public void setQuantity(Integer quantity) {
        this.quantity = quantity;
    }

    public String getCompany() {
        return company;
    }

    public void setCompany(String company) {
        this.company = company;
    }

    public String getType() {
        return type;
    }

    public void setType(String type) {
        this.type = type;
    }

    public String getTruckID() {
        return truckID;
    }

    public void setTruckID(String truckID) {
        this.truckID = truckID;
    }
}
