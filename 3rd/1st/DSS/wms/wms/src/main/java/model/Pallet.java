package model;

public class Pallet {
    private String id;
    private String product;
    private Integer quantity;
    private String company;
    private String type;

    public Pallet(String id, String product, Integer quantity, String company, String type) {
        this.id = id;
        this.product = product;
        this.quantity = quantity;
        this.company = company;
        this.type = type;
    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getProduct() {
        return product;
    }

    public Integer getQuantity() {
        return quantity;
    }

    public String getCompany() {
        return company;
    }

    public String getType() {
        return type;
    }

    // public clone :TODO
}
