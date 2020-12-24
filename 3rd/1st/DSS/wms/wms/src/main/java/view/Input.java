package view;

import java.io.IOException;
import java.util.Scanner;

public final class Input {

    public static String[] read() throws IOException {
        Scanner scanner = new Scanner(System.in);
        return scanner.nextLine().split(" ");
    }
}
