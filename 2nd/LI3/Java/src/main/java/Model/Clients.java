package Model;


import java.io.*;

import java.util.Hashtable;
import java.util.Map;
import java.util.HashMap;


public class Clients implements ClientsInterface, Serializable {

    private static final long serialVersionUID = 796752640106477533L;
    /**
     * Map structure which stores Client objects where the key is their ID
     */
    public Map<String, ClientInterface> clientsCatalog;


    public Clients(){
        this.clientsCatalog = new Hashtable<>();
    }

    /**
     * Reads a file containing client's IDs and adds them
     * @param filePath path to the file
     * @throws IOException  If there's a problem when reading the file
     */
    public void readClientsFile(String filePath) throws IOException {
        BufferedReader inFile = new BufferedReader(new FileReader(filePath));
        String clientID;
        while ((clientID = inFile.readLine()) != null) {
            if (ClientInterface.verifyId(clientID)) {
                ClientInterface client = new Client(clientID);
                clientsCatalog.put(clientID, client);
            }
        }
    }




    /**
     * Returns the number of clients in the application
     *
     * @return number of clients in the application
     */
    public int getNumberOfClients() {
        return this.clientsCatalog.size();
    }

    /**
     * Checks if a client exists.
     * @param clientID Id of client to be searched.
     * @return Boolean value indicating if client exists.
     */
    public boolean constainsClient(String clientID){
        return this.clientsCatalog.containsKey(clientID);
    }

}