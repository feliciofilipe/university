package util;

import java.io.IOException;
import java.lang.reflect.InvocationTargetException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.stream.Collectors;
import java.util.stream.Stream;

public class Tools {

    public static Object[] getSubclasses(Class clazz, String packageName) {
        try (Stream<Path> walk = Files.walk(Paths.get("src/main/java/" + packageName))) {
            return walk.filter(Files::isRegularFile).map(Path::toString)
                    .filter(s -> s.endsWith(".java")).collect(Collectors.toList()).stream()
                    .map(s -> s.replace("src/main/java", ""))
                    .map(s -> s.replace("/", "."))
                    .map(s -> s.replace(".java", ""))
                    .map(s -> s.replaceFirst(".", ""))
                    .map(
                            s -> {
                                try {
                                    return Class.forName(s);
                                } catch (ClassNotFoundException e) {
                                    return Class.class;
                                }
                            })
                    .filter(subclass -> subclass.isAssignableFrom(clazz))
                    .toArray();
        } catch (IOException ignored) {
            ignored.printStackTrace();
        }
        return null;
    }

    /**
     * Function that generates the arguments of an function to be invoked
     *
     * @param input Array of inputs from the user of the program
     * @param classes Classes of the inputs
     * @return Array of objects that can be used to invoke a method
     * @throws InvocationTargetException e
     * @throws NoSuchMethodException e
     * @throws InstantiationException e
     * @throws IllegalAccessException e
     */
    public static Object[] argsGenerator(String[] input, Class[] classes)
            throws InvocationTargetException, NoSuchMethodException, InstantiationException,
                    IllegalAccessException {
        Object[] args = new Object[classes.length];
        for (int i = 0; i < classes.length; i++) {
            args[i] = parseObjectFromString(input[i], classes[i]);
        }
        return args;
    }

    /**
     * Parses a String to any type of Object
     *
     * @param string String to be parsed
     * @param clazz Class to be parsed to
     * @param <T> Abstract return type
     * @return Object parsed from String
     * @throws NoSuchMethodException
     * @throws IllegalAccessException
     * @throws InvocationTargetException
     * @throws InstantiationException
     */
    private static <T> T parseObjectFromString(String string, Class<T> clazz)
            throws NoSuchMethodException, IllegalAccessException, InvocationTargetException,
                    InstantiationException {
        return clazz.getConstructor(new Class[] {String.class}).newInstance(string);
    }

    public static Boolean isExit(String string) {
        return string.equals("quit") || string.equals("q") || string.equals("exit");
    }
}
