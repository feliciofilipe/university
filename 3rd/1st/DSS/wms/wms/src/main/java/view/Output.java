package view;

public final class Output {

    /**
     * Function that show a string to the user
     *
     * @param arg String to be shown
     */
    public static void show(Object arg) {
        System.out.print(arg);
    }

    /**
     * Function that show a array of strings
     *
     * @param args Strings to be shown
     */
    public static void show(String[] args) {
        for (int i = 0; i < args.length; i++) System.out.print(args[i]);
    }

    /**
     * Function that show a string on a line
     *
     * @param arg String to be shown
     */
    public static void showln(Object arg) {
        switch (arg.getClass().getName()) {
            case ("java.util.ArrayList"):
                System.out.println(
                        arg.toString().replace("[", " ").replace(",", "\n").replace("]", ""));
                break;

            case ("java.util.HashMap"):
                System.out.println(
                        removeLastChar(arg.toString().substring(1)).replace("={", " = {") + "\n");
                break;
            default:
                System.out.println(arg);
                break;
        }
    }

    /**
     * Function that shows a list of strings in different lines
     *
     * @param args Strings to be shown
     */
    public static void showln(String[] args) {
        for (int i = 0; i < args.length; i++) System.out.println(args[i]);
    }

    /**
     * Shown the prompt
     *
     * @param name Name of the prompt
     * @param module Module
     */
    public static void prompt(String name, String module) {
        System.out.print(Color.ANSI_PINK + "[" + name + "@" + module + "]$ " + Color.ANSI_RESET);
    }

    /**
     * Shows a error message
     *
     * @param error Error message to be shown
     */
    public void error(String error) {
        System.out.println(Color.ANSI_RED + "\n" + error + Color.ANSI_RESET);
    }

    /**
     * Auxiliary function that removes last character
     *
     * @param str String to remove last character
     * @return The string without the last character
     */
    private static String removeLastChar(String str) {
        return str.substring(0, str.length() - 1);
    }

    /**
     * Function that creates a title
     *
     * @param title String to make the title
     */
    public void showTitle(String title) {
        showln("\n" + Color.ANSI_CYAN + Output.toAnsi(title) + Color.ANSI_RESET);
    }

    /**
     * Function that creates a title from the letter that are saved
     *
     * @param string String from where the title is created
     * @return String of the title
     */
    private static String toAnsi(String string) {
        StringBuilder sb = new StringBuilder();
        int length = 0;

        for (int i = 0; i < 6; i++) {

            for (char c : string.toUpperCase().toCharArray()) {

                switch (c) {
                    case 'A':
                    case 'Á':
                    case 'À':
                    case 'Ã':
                    case 'Â':
                        sb.append(Ansi.A[i]);
                        if (i == 0) length += Ansi.A[i].length();
                        break;

                    case 'B':
                        sb.append(Ansi.B[i]);
                        if (i == 0) length += Ansi.B[i].length();
                        break;

                    case 'C':
                        sb.append(Ansi.C[i]);
                        if (i == 0) length += Ansi.C[i].length();
                        break;

                    case 'D':
                        sb.append(Ansi.D[i]);
                        if (i == 0) length += Ansi.D[i].length();
                        break;

                    case 'E':
                    case 'É':
                    case 'È':
                    case 'Ê':
                        sb.append(Ansi.E[i]);
                        if (i == 0) length += Ansi.E[i].length();
                        break;

                    case 'F':
                        sb.append(Ansi.F[i]);
                        if (i == 0) length += Ansi.F[i].length();
                        break;

                    case 'G':
                        sb.append(Ansi.G[i]);
                        if (i == 0) length += Ansi.G[i].length();
                        break;

                    case 'H':
                        sb.append(Ansi.H[i]);
                        if (i == 0) length += Ansi.H[i].length();
                        break;

                    case 'I':
                    case 'Í':
                    case 'Ì':
                    case 'Î':
                        sb.append(Ansi.I[i]);
                        if (i == 0) length += Ansi.I[i].length();
                        break;

                    case 'J':
                        sb.append(Ansi.J[i]);
                        if (i == 0) length += Ansi.J[i].length();
                        break;

                    case 'K':
                        sb.append(Ansi.K[i]);
                        if (i == 0) length += Ansi.K[i].length();
                        break;

                    case 'L':
                        sb.append(Ansi.L[i]);
                        if (i == 0) length += Ansi.L[i].length();
                        break;

                    case 'M':
                        sb.append(Ansi.M[i]);
                        if (i == 0) length += Ansi.M[i].length();
                        break;

                    case 'N':
                        sb.append(Ansi.N[i]);
                        if (i == 0) length += Ansi.N[i].length();
                        break;

                    case 'O':
                    case 'Ó':
                    case 'Ò':
                    case 'Ô':
                    case 'Õ':
                        sb.append(Ansi.O[i]);
                        if (i == 0) length += Ansi.O[i].length();
                        break;

                    case 'P':
                        sb.append(Ansi.P[i]);
                        if (i == 0) length += Ansi.P[i].length();
                        break;

                    case 'Q':
                        sb.append(Ansi.Q[i]);
                        if (i == 0) length += Ansi.Q[i].length();
                        break;

                    case 'R':
                        sb.append(Ansi.R[i]);
                        if (i == 0) length += Ansi.R[i].length();
                        break;

                    case 'S':
                        sb.append(Ansi.S[i]);
                        if (i == 0) length += Ansi.S[i].length();
                        break;

                    case 'T':
                        sb.append(Ansi.T[i]);
                        if (i == 0) length += Ansi.T[i].length();
                        break;

                    case 'U':
                    case 'Ú':
                    case 'Ù':
                    case 'Û':
                        sb.append(Ansi.U[i]);
                        if (i == 0) length += Ansi.U[i].length();
                        break;

                    case 'V':
                        sb.append(Ansi.V[i]);
                        if (i == 0) length += Ansi.V[i].length();
                        break;

                    case 'W':
                        sb.append(Ansi.W[i]);
                        if (i == 0) length += Ansi.W[i].length();
                        break;

                    case 'X':
                        sb.append(Ansi.X[i]);
                        if (i == 0) length += Ansi.X[i].length();
                        break;

                    case 'Y':
                        sb.append(Ansi.Y[i]);
                        if (i == 0) length += Ansi.Y[i].length();
                        break;

                    case 'Z':
                        sb.append(Ansi.Z[i]);
                        if (i == 0) length += Ansi.Z[i].length();
                        break;

                    case '0':
                        sb.append(Ansi.zero[i]);
                        if (i == 0) length += Ansi.zero[i].length();
                        break;

                    case '1':
                        sb.append(Ansi.one[i]);
                        if (i == 0) length += Ansi.one[i].length();
                        break;

                    case '2':
                        sb.append(Ansi.two[i]);
                        if (i == 0) length += Ansi.two[i].length();
                        break;

                    case '3':
                        sb.append(Ansi.three[i]);
                        if (i == 0) length += Ansi.three[i].length();
                        break;

                    case '4':
                        sb.append(Ansi.four[i]);
                        if (i == 0) length += Ansi.four[i].length();
                        break;

                    case '5':
                        sb.append(Ansi.five[i]);
                        if (i == 0) length += Ansi.five[i].length();
                        break;

                    case '6':
                        sb.append(Ansi.six[i]);
                        if (i == 0) length += Ansi.six[i].length();
                        break;

                    case '7':
                        sb.append(Ansi.seven[i]);
                        if (i == 0) length += Ansi.seven[i].length();
                        break;

                    case '8':
                        sb.append(Ansi.eight[i]);
                        if (i == 0) length += Ansi.eight[i].length();
                        break;

                    case '9':
                        sb.append(Ansi.nine[i]);
                        if (i == 0) length += Ansi.nine[i].length();
                        break;

                    case ' ':
                        sb.append(Ansi.space[0]);
                        if (i == 0) length += Ansi.space[0].length();
                        break;

                    case ',':
                        sb.append(Ansi.comma[i]);
                        if (i == 0) length += Ansi.comma[i].length();
                        break;

                    case '-':
                        sb.append(Ansi.dash[i]);
                        if (i == 0) length += Ansi.dash[i].length();
                        break;

                    case '_':
                        sb.append(Ansi.underscore[i]);
                        if (i == 0) length += Ansi.underscore[i].length();
                        break;

                    case '/':
                        sb.append(Ansi.slash[i]);
                        if (i == 0) length += Ansi.slash[i].length();
                        break;

                    case '.':
                        sb.append(Ansi.dot[i]);
                        if (i == 0) length += Ansi.dot[i].length();

                    default:
                        break;
                }
            }
            sb.append("\n");
        }

        for (int i = 0; i < 2; i++) {
            for (int j = 0; j < 2; j++) {
                sb.append(Ansi.begginingBar[i]);
                for (int l = 0; l < (length / 2) - 6; l++) sb.append(Ansi.bar[i]);
                sb.append(Ansi.endingBar[i]);
                if (j == 0) sb.append(Ansi.dot[i]);
                if (j == 1) sb.append("\n");
            }
        }
        return sb.toString();
    }

    public static void clear() {
        for (int i = 0; i < 50; i++) showln("");
    }
}
