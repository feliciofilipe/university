import controller.Controller;
import exceptions.AuthenticationException;
import model.*;
import view.Output;

import java.io.IOException;
import java.lang.reflect.InvocationTargetException;
import java.security.NoSuchAlgorithmException;

public class Shell {

  public static void main(String[] args)
      throws IOException, NoSuchAlgorithmException, InvocationTargetException,
          NoSuchMethodException, InstantiationException, IllegalAccessException,
          ClassNotFoundException, AuthenticationException {
    IWMS wms = new WMS();
    Controller controller = new Controller(wms);
    Output.clear();
    controller.run();
  }
}
