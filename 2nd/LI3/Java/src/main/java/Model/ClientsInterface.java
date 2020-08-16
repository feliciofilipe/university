package Model;

import java.io.IOException;

public interface ClientsInterface {
    /**
     * Reads a file containing client's IDs and adds them
     * @param filePath path to the file
     * @throws IOException  If there's a problem when reading the file
     */
    void readClientsFile(String filePath) throws IOException;


    /**
     * Returns the number of clients in the application
     * @return number of clients in the application
     */
     int getNumberOfClients();

    /**
     * Checks if a client exists.
     * @param clientID Id of client to be searched.
     * @return Boolean value indicating if client exists.
     */
     boolean constainsClient(String clientID);

}
