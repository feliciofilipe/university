package server;
/*
import java.io.IOException;
import java.net.InetSocketAddress;
import java.net.ServerSocket;
import java.net.Socket;
import java.util.List;

import sun.misc.Signal;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

import util.Parser;
import view.Terminal;

public final class Server {
    private static final String HOSTNAME = System.getenv("APP_SERVER_HOSTNAME");
    private static final int PORT = Integer.parseInt(System.getenv("APP_SERVER_PORT"));
    private static Logger log = LogManager.getLogger(Server.class);

    private ServerSocket socket;

    public Server() {}

    public static void main(final String[] args) {
        Server.welcome();
        new Server().startUp();
    }

    @SuppressWarnings("checkstyle:magicnumber")
    public void startUp() {
        log.debug("Working Directory " + System.getProperty("user.dir"));

        // handler to Ctrl + C
        Signal.handle(new Signal("INT"), this::exit);

        // create server
        try {
            this.socket = new ServerSocket();
            this.socket.bind(new InetSocketAddress(HOSTNAME, PORT));
            log.info("Server is up at " + this.socket.getLocalSocketAddress());
        } catch (IOException e) {
            log.fatal(e.getMessage());
        }

        int id = 1;
        while (true) {
            try {
                log.info("Waiting for connection...");
                Socket clientServer = this.socket.accept();
                new Thread(new Session(id, clientServer)).start();
                log.debug("Session " + id + " accepted connection");
            } catch (IOException e) {
                log.error(e.getMessage());
            }
            id++;
        }
    }

    public void exit(final Signal signal) {
        log.info("Exiting program...");
        System.exit(0);
    }

    public static void welcome() {
        Terminal.clear();
        List<String> logo =
                Parser.readFile(
                        Server.class.getResource("../art/server.ascii").toString().split(":")[1]);
        Terminal.welcome(logo);
    }
}
*/
