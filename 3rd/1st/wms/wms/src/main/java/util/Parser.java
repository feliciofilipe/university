package util;

import java.io.BufferedReader;
import java.io.FileReader;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

public final class Parser {

    private Parser() {}

    /**
     * Function that reads all lines from a file.
     *
     * @param file from where should read
     * @return List of Strings
     */
    public static List<String> readFile(final String file) {
        List<String> linhas = new ArrayList<>();
        BufferedReader inFile;
        String linha;

        try {
            inFile = new BufferedReader(new FileReader(file));
            while ((linha = inFile.readLine()) != null) {
                linhas.add(linha);
            }
        } catch (IOException exc) {
            System.out.println(exc);
        }

        return linhas;
    }
}
