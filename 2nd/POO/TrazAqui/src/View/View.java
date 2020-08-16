package View;

import Utilities.Colors;
import Utilities.Resources;

public class View {

    /**
     * Function that show a string to the user
     * @param arg String to be shown
     */
    public void show(Object arg){
        System.out.print(arg);
    }

    /**
     * Function that show a array of strings
     * @param args Strings to be shown
     */
    public void show(String[] args){
        for(int i = 0; i < args.length; i++)
            System.out.print(args[i]);
    }

    /**
     * Function that show a string on a line
     * @param arg String to be shown
     */
    public void showln(Object arg){
        switch(arg.getClass().getName()){
            case("java.util.ArrayList"):
                System.out.println(arg.toString().replace("["," ").replace(",","\n").replace("]",""));
                break;

            case("java.util.HashMap"):
                System.out.println(removeLastChar(arg.toString().substring(1)).replace("={"," = {") + "\n");
                //System.out.println(arg.toString());
                break;
            default:
                //System.out.println(arg.getClass().getName());
                System.out.println(arg);
                break;
        }
    }

    /**
     * Function that shows a list of strings in different lines
     * @param args Strings to be shown
     */
    public void showln(String[] args){
        for(int i = 0; i < args.length; i++)
            System.out.println(args[i]);
    }

    /**
     * Shown the prompt
     * @param name Name of the prompt
     * @param module Module
     */
    public void prompt(String name, String module){
        System.out.print(Colors.ANSI_PINK + "["+ name +"@" + module + "]$ " + Colors.ANSI_RESET);
    }

    /**
     * Shows a error message
     * @param error Error message to be shown
     */
    public void error(String error){
        System.out.println(Colors.ANSI_RED + "\n" + error + Colors.ANSI_RESET);
    }

    /**
     * Function that creates a title
     * @param title String to make the title
     */
    public void showTitle(String title){
        showln("\n" + Colors.ANSI_CYAN + View.toAnsi(title) + Colors.ANSI_RESET);
    }

    /**
     * Auxiliary function that removes last character
     * @param str String to remove last character
     * @return The string without the last character
     */
    private static String removeLastChar(String str) {
        return str.substring(0, str.length() - 1);
    }

    /**
     * Function that creates a title from the letter that are saved
     * @param string String from where the title is created
     * @return String of the title
     */
    public static String toAnsi(String string) {
        StringBuilder sb = new StringBuilder();
        int length = 0;

        for(int i=0 ; i < 6 ; i++){

            for(char c : string.toUpperCase().toCharArray()){

                switch(c) {
                    case 'A':
                    case 'Á':
                    case 'À':
                    case 'Ã':
                    case 'Â':
                        sb.append(Resources.A[i]);
                        if(i==0) length += Resources.A[i].length();
                        break;

                    case 'B':
                        sb.append(Resources.B[i]);
                        if(i==0) length += Resources.B[i].length();
                        break;

                    case 'C':
                        sb.append(Resources.C[i]);
                        if(i==0) length += Resources.C[i].length();
                        break;

                    case 'D':
                        sb.append(Resources.D[i]);
                        if(i==0) length += Resources.D[i].length();
                        break;

                    case 'E':
                    case 'É':
                    case 'È':
                    case 'Ê':
                        sb.append(Resources.E[i]);
                        if(i==0) length += Resources.E[i].length();
                        break;

                    case 'F':
                        sb.append(Resources.F[i]);
                        if(i==0) length += Resources.F[i].length();
                        break;

                    case 'G':
                        sb.append(Resources.G[i]);
                        if(i==0) length += Resources.G[i].length();
                        break;

                    case 'H':
                        sb.append(Resources.H[i]);
                        if(i==0) length += Resources.H[i].length();
                        break;

                    case 'I':
                    case 'Í':
                    case 'Ì':
                    case 'Î':
                        sb.append(Resources.I[i]);
                        if(i==0) length += Resources.I[i].length();
                        break;

                    case 'J':
                        sb.append(Resources.J[i]);
                        if(i==0) length += Resources.J[i].length();
                        break;

                    case 'K':
                        sb.append(Resources.K[i]);
                        if(i==0) length += Resources.K[i].length();
                        break;

                    case 'L':
                        sb.append(Resources.L[i]);
                        if(i==0) length += Resources.L[i].length();
                        break;

                    case 'M':
                        sb.append(Resources.M[i]);
                        if(i==0) length += Resources.M[i].length();
                        break;

                    case 'N':
                        sb.append(Resources.N[i]);
                        if(i==0) length += Resources.N[i].length();
                        break;

                    case 'O':
                    case 'Ó':
                    case 'Ò':
                    case 'Ô':
                    case 'Õ':
                        sb.append(Resources.O[i]);
                        if(i==0) length += Resources.O[i].length();
                        break;

                    case 'P':
                        sb.append(Resources.P[i]);
                        if(i==0) length += Resources.P[i].length();
                        break;

                    case 'Q':
                        sb.append(Resources.Q[i]);
                        if(i==0) length += Resources.Q[i].length();
                        break;

                    case 'R':
                        sb.append(Resources.R[i]);
                        if(i==0) length += Resources.R[i].length();
                        break;

                    case 'S':
                        sb.append(Resources.S[i]);
                        if(i==0) length += Resources.S[i].length();
                        break;

                    case 'T':
                        sb.append(Resources.T[i]);
                        if(i==0) length += Resources.T[i].length();
                        break;

                    case 'U':
                    case 'Ú':
                    case 'Ù':
                    case 'Û':
                        sb.append(Resources.U[i]);
                        if(i==0) length += Resources.U[i].length();
                        break;

                    case 'V':
                        sb.append(Resources.V[i]);
                        if(i==0) length += Resources.V[i].length();
                        break;

                    case 'W':
                        sb.append(Resources.W[i]);
                        if(i==0) length += Resources.W[i].length();
                        break;

                    case 'X':
                        sb.append(Resources.X[i]);
                        if(i==0) length += Resources.X[i].length();
                        break;

                    case 'Y':
                        sb.append(Resources.Y[i]);
                        if(i==0) length += Resources.Y[i].length();
                        break;

                    case 'Z':
                        sb.append(Resources.Z[i]);
                        if(i==0) length += Resources.Z[i].length();
                        break;

                    case '0':
                        sb.append(Resources.zero[i]);
                        if(i==0) length += Resources.zero[i].length();
                        break;

                    case '1':
                        sb.append(Resources.one[i]);
                        if(i==0) length += Resources.one[i].length();
                        break;

                    case '2':
                        sb.append(Resources.two[i]);
                        if(i==0) length += Resources.two[i].length();
                        break;

                    case '3':
                        sb.append(Resources.three[i]);
                        if(i==0) length += Resources.three[i].length();
                        break;

                    case '4':
                        sb.append(Resources.four[i]);
                        if(i==0) length += Resources.four[i].length();
                        break;

                    case '5':
                        sb.append(Resources.five[i]);
                        if(i==0) length += Resources.five[i].length();
                        break;

                    case '6':
                        sb.append(Resources.six[i]);
                        if(i==0) length += Resources.six[i].length();
                        break;

                    case '7':
                        sb.append(Resources.seven[i]);
                        if(i==0) length += Resources.seven[i].length();
                        break;

                    case '8':
                        sb.append(Resources.eight[i]);
                        if(i==0) length += Resources.eight[i].length();
                        break;

                    case '9':
                        sb.append(Resources.nine[i]);
                        if(i==0) length += Resources.nine[i].length();
                        break;

                    case ' ':
                        sb.append(Resources.space[0]);
                        if(i==0) length += Resources.space[0].length();
                        break;

                    case ',':
                        sb.append(Resources.comma[i]);
                        if(i==0) length += Resources.comma[i].length();
                        break;

                    case '-':
                        sb.append(Resources.dash[i]);
                        if(i==0) length += Resources.dash[i].length();
                        break;

                    case '_':
                        sb.append(Resources.underscore[i]);
                        if(i==0) length += Resources.underscore[i].length();
                        break;

                    case '/':
                        sb.append(Resources.slash[i]);
                        if(i==0) length += Resources.slash[i].length();
                        break;

                    case '.':
                        sb.append(Resources.dot[i]);
                        if(i==0) length += Resources.dot[i].length();

                    default:
                        break;
                }
            }
            sb.append("\n");
        }

        for(int i=0 ; i<2 ; i++) {
            for (int j = 0; j < 2; j++) {
                sb.append(Resources.begginingBar[i]);
                for (int l = 0; l < (length / 2) - 6; l++) sb.append(Resources.bar[i]);
                sb.append(Resources.endingBar[i]);
                if (j == 0) sb.append(Resources.dot[i]);
                if (j == 1) sb.append("\n");
            }
        }
        return sb.toString();
    }

}
