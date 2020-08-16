package Model;

public interface ClientInterface {

    /**
     *  Returns the ID of the client
     * @return Id of the client
     */
    String getId();

    /**
     * Tests if a given ID follows the right stipulation for a client's ID
     *
     * @param id TheI ID to test
     * @return boolean indicating if the ID is valid
     */
     static boolean verifyId(String id) {
        return id.matches("[A-Z]([0-4]\\d{3}|50{3})");
    }

     @Override
     int hashCode();
}
