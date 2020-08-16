package Clients;

import Model.Client;
import Model.ClientInterface;
import Model.Clients;
import Model.ClientsInterface;

import java.io.*;
import java.util.HashMap;
import java.util.Map;

public class ClientsHashMap implements ClientsInterface, Serializable {

    private static final long serialVersionUID = 3616935224304871067L;
    /**
     * Map structure which stores Client objects where the key is their ID
     */
    public Map<String, ClientInterface> clientsCatalog;


    public ClientsHashMap(){
        this.clientsCatalog = new HashMap<>();
    }

    /**
     * @param filePath Path to the folder containing the Clients information
     * @throws FileNotFoundException If the given file is not found
     * @throws IOException           If there's a problem when reading the file
     */
    @Override
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
