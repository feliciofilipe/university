package Model;

import static org.junit.jupiter.api.Assertions.*;

class ClientTest {

    @org.junit.jupiter.api.Test
    void getId() {
        String expected = "A1234";
        Client client = new Client(expected);
        String actual = client.getId();
        assertEquals(expected,actual);
    }
}