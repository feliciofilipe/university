package Model;

import java.io.Serializable;
import java.util.Arrays;

public class Client implements ClientInterface, Serializable {
    private static final long serialVersionUID = -8323855933745869781L;
    /**
     * Id of the client
     */
    private final String id;

    /**
     * Instantiates a client with the given ID
     * @param id ID of the client
     */
    public Client(String id) {
        this.id = id;
    }

    /**
     *  Returns the ID of the client
     * @return Id of the client
     */
    public String getId() {
        return id;
    }


    @Override
    public int hashCode(){
        return Arrays.hashCode(new Object[]{id});
    }
}
