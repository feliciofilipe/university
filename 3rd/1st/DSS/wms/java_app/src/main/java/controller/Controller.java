package controller;

import exceptions.AuthenticationException;
import model.IWMS;
import model.User;
import util.Config;
import util.Tools;
import view.Input;
import view.Output;

import java.io.IOException;
import java.lang.reflect.InvocationTargetException;
import java.lang.reflect.Method;
import java.lang.reflect.Parameter;
import java.util.Arrays;

public class Controller {

  private IWMS wms;

  public Controller(IWMS wms) {
    this.wms = wms;
  }

  public void run() throws IOException, ClassNotFoundException, AuthenticationException {
    String[] input;
    do {
      Output.prompt("Menu", "WMS");
      input = Input.read();
      switch (input[0]) {
        case "login":
          if (input.length == 3) login(input[1], input[2]);
          break;
        case "help":
          Output.showln("login String String");
          Output.showln("signup");
          Output.showln("robot");
          Output.showln("exit");
          break;
        case "clear":
          Output.clear();
          break;
        case "robot":
          robotShell();
          break;
      }
    } while (!Tools.isExit(input[0]));
  }

  private void login(String id, String password)
      throws IOException, ClassNotFoundException, AuthenticationException {
    try {
      this.wms.authenticate(id, password);
      this.dashboard(id);
    } catch (AuthenticationException e) {
      Output.showln(Config.InvalidCredentials);
    }
  }

  private void robotShell() throws ClassNotFoundException, IOException {
    Method[] methods = Class.forName("controller.RobotController").getMethods();

    Method[] methods2 = Class.forName("controller.IRobotController").getMethods();
    String[] input;
    do {
      Output.prompt("robot", "Shell");
      input = Input.read();
      if (input[0].equals("help")) showMethods(methods2);
      else if (input[0].equals("clear")) Output.clear();
      else callMethod(Class.forName("controller.RobotController"), methods, input, "");

    } while (!Tools.isExit(input[0]));
  }

  private void dashboard(String id) throws ClassNotFoundException, IOException {
    Class clazz = this.wms.getClass(id);
    String className = clazz.getName().replace("model.", "");
    User user = this.wms.getUser(id);
    Method[] methods = Class.forName("controller.I" + className + "Controller").getMethods();
    String[] input;
    do {
      Output.prompt(user.getId(), className + "Prompt");
      input = Input.read();
      if (input[0].equals("help")) showMethods(methods);
      else if (input[0].equals("clear")) Output.clear();
      else callMethod(Class.forName("controller." + className + "Controller"), methods, input, id);

    } while (!Tools.isExit(input[0]));
  }

  private void showMethods(Method[] methods) throws ClassNotFoundException {
    for (int i = 0; i < methods.length; i++) {
      Output.show(methods[i].getName());
      Parameter[] parameters = methods[i].getParameters();
      for (int j = 0; j < parameters.length; j++) {
        for (String string :
            Arrays.asList(" ", parameters[j].getType().getName().replace("java.lang.", ""))) {
          Output.show(string);
        }
      }
      Output.showln(" ");
    }
    Output.showln("quit");
  }

  private void callMethod(Class clazz, Method[] methods, String[] input, String id) {
    try {
      Object instance =
          clazz.getConstructor(new Class[] {String.class, IWMS.class}).newInstance(id, this.wms);
      if (!Tools.isExit(input[0])) {
        for (int i = 0; i < methods.length; i++)
          if (methods[i].getName().equals(input[0])) {
            methods[i].invoke(
                instance,
                Tools.argsGenerator(
                    Arrays.copyOfRange(input, 1, input.length), methods[i].getParameterTypes()));
          }
      } else {

      }
    } catch (InstantiationException
        | InvocationTargetException
        | NoSuchMethodException
        | IllegalAccessException e) {
      Output.showln(Config.InvalidOption);
      e.printStackTrace();
    }
  }

  private void signup(String id, String password) {}
}
