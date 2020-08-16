package Model;

import Utilities.Config;
import org.junit.jupiter.api.Test;

import java.io.IOException;

class ClientsTest {

    @Test
    void constainsClient() throws IOException {
        Clients clients = new Clients();
        clients.readClientsFile(Config.clientsPath);
        assert clients.constainsClient("F2916");
    }
}