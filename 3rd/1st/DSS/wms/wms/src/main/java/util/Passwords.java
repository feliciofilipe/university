package util;

import java.security.NoSuchAlgorithmException;
import java.security.SecureRandom;
import java.security.spec.InvalidKeySpecException;
import java.security.spec.KeySpec;
import java.util.Base64;

import javax.crypto.SecretKeyFactory;
import javax.crypto.spec.PBEKeySpec;

public class Passwords {

    @SuppressWarnings("checkstyle:MagicNumber")
    public static String getSalt() throws NoSuchAlgorithmException {
        SecureRandom random = SecureRandom.getInstance("SHA1PRNG");
        byte[] salt = new byte[8];
        random.nextBytes(salt);
        return Base64.getEncoder().encodeToString(salt);
    }

    public static String getEncryptedPassword(String password, String salt) {
        String algorithm = "PBKDF2WithHmacSHA1";
        int derivedKeyLength = 160; // for SHA1
        int iterations = 20000; // NIST specifies 10000

        try {
            byte[] saltBytes = Base64.getDecoder().decode(salt);
            KeySpec spec =
                    new PBEKeySpec(password.toCharArray(), saltBytes, iterations, derivedKeyLength);
            SecretKeyFactory f = SecretKeyFactory.getInstance(algorithm);

            byte[] encBytes = f.generateSecret(spec).getEncoded();
            return Base64.getEncoder().encodeToString(encBytes);
        } catch (NoSuchAlgorithmException | InvalidKeySpecException e) {
            e.printStackTrace();
            return null;
        }
    }

    public static boolean authenticate(String inputPassword, String salt, String password) {
        return Passwords.getEncryptedPassword(inputPassword, salt).equalsIgnoreCase(password);
    }

    @SuppressWarnings("checkstyle:MagicNumber")
    public static int score(final String password) {
        int score = 0;

        if (password.length() > 8) {
            score += 1;

            if ((password.matches("(?=.*[a-z]).*")) && (password.matches("(?=.*[A-Z]).*")))
                score += 1;

            if (password.matches("(?=.*[~!@#$%^&*()_-]).*") && password.matches("(?=.*[0-9]).*"))
                score += 1;
        }

        return score;
    }
}
