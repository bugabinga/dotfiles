import static java.lang.System.out;
import static java.nio.charset.StandardCharsets.UTF_16LE;
import static java.util.stream.Collectors.joining;

import java.util.*;

class startup {
  public static void main(String[] __) throws Exception {
    out.println("Map D:/Workspaces to W:.");
    call("subst.exe", "W:", "D:\\Workspaces");
    out.println("Map D:/Notizen to N:.");
    call("subst.exe", "N:", "D:\\Notizen");
    out.println("Map D:/Tools to X:.");
    call("subst.exe", "X:", "D:\\Tools");
    out.println("save list of installed apps in case something goes wrong and mass reinstall is necessary.");
    ps("scoop export > D:\\Tools\\scoop_installed_apps.txt");
    ps("winget export D:\\Tools\\winget_installed_apps.json");
    out.println("Upgrading the whole system.");
    ps("topgrade");
    pause();
  }

  static int call(String... command) throws Exception {
    return new ProcessBuilder()
    .command(command)
    .inheritIO()
    .start()
    .onExit()
    .join()
    .exitValue();
  }

  static int ps(String command) throws Exception {
    return call(
      "powershell.exe",
      "-NonInteractive",
      "-NoProfile",
      "-NoLogo",
      "-encodedCommand",
      Base64.getEncoder().encodeToString(command.getBytes(UTF_16LE)));
  }

  static void pause() throws Exception {
    out.println("pause; waiting for input...");
    System.in.read();
  }
}
