package model;

public abstract class SystemEntity {

    private String id;
    /*
        public SystemEntity(String[] id){
            if (id.length == 1){
                this.id = id[0];
            }
            else this.id = null;
        }
    */
    public SystemEntity(String id) {
        this.id = id;
    }

    // protected SystemEntity() {}

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }
}
