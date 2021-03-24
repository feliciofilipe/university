package server;
/*
import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.PrintWriter;
import java.net.Socket;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

@SuppressWarnings({"checkstyle:VisibilityModifier", "checkstyle:MagicNumber"})
public final class Session implements Runnable {
    private int id;
    private final Socket socket;
    private BufferedReader in;
    private PrintWriter out;

    private static Logger log = LogManager.getLogger(Session.class);

    public Session(final int id, final Socket socket) {
        this.id = id;
        this.socket = socket;
    }

    @SuppressWarnings("checkstyle:InnerAssignment")
    @Override
    public void run() {
        log.info("Session " + this.id + " established on " + this.socket.getRemoteSocketAddress());

        try {
            this.in = new BufferedReader(new InputStreamReader(this.socket.getInputStream()));
            this.out = new PrintWriter(this.socket.getOutputStream(), true);

            String message;
            while ((message = in.readLine()) != null) {
                this.out.println(message);
            }

            this.socket.shutdownOutput();
            this.socket.shutdownInput();
            this.socket.close();
            log.info("Session " + this.id + " finished!");
        } catch (IOException e) {
            log.error(this.id + ": " + e.getMessage());
        }
    }
}
*/
