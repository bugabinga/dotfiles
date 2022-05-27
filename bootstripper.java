import java.nio.file.*;
import java.io.*;

import static java.text.MessageFormat.format;

class bootstripper {
  public static void main(String[] arguments) throws Throwable {
    var dorkfile_path_input = ".";
    if (arguments.length == 1) {
      dorkfile_path_input = arguments[0];
    } else if (arguments.length > 1) {
      usage();
      throw fail();
    }
    var dorkfiles_root = Path.of(dorkfile_path_input).toRealPath();
    log("Assuming dorkfiles root repo in {0}.", emphasize_local(dorkfiles_root.toString()));
    decrypt_secrets(dorkfiles_root.resolve("tresor"));
    var hostname = hostname();
    log("Hostname: {0}", emphasize_global(hostname));
    var symlinks_file = hostname + ".symlinks";
    create_symlinks(dorkfiles_root, dorkfiles_root.resolve(symlinks_file));
  }

  static void decrypt_secrets(Path secrets_root) throws Throwable {
    log("{0}:Decrypting files in {1} folder.", emphasize_global("TODO"),
        emphasize_local(secrets_root.getFileName().toString()));
  }

  static void create_symlinks(Path root, Path symlinks_file) throws Throwable {
    log("Creating symlinks as defined in {0} file.",
        emphasize_local(symlinks_file.getFileName().toString()));
    var lines = Files.readAllLines(symlinks_file);
    String source = null;
    String target = null;
    for (String line : lines) {
      if (line.isBlank())
        continue;
      if (source == null)
        source = line;
      else
        target = line;
      if (target != null) {
        link(root, source, target);
        source = null;
        target = null;
      }
    }
  }

  static void link(Path root, String source, String target) throws Throwable {
    var home = System.getProperty("user.home");
    var source_path = root.resolve(source).toAbsolutePath();
    var target_path = Path.of(target.replace("~", home)).toAbsolutePath();
    var is_directory = Files.isDirectory(source_path);
    if (Files.exists(target_path, LinkOption.NOFOLLOW_LINKS)) {
      if (Files.exists(target_path)) {
        log("\nOK {0} already exists!\nNot linking {1}.", emphasize_global(target_path.toString()),
            emphasize_local(source_path.toString()));
        return;
      } else {
        log("\nNOPE {0} exists, but it points into nirvana. Removing broken link!", target_path.toString());
        Files.delete(target_path);
      }
    }
    log("\nLINK {0} TO {1}.", emphasize_local(source_path.toString()),
        emphasize_local(target_path.toString()));
    Files.createDirectories(target_path.getParent());
    try {
      Files.createSymbolicLink(target_path, source_path);
    } catch (Exception __) {
      /*
       * Creating symbolic links on Windows only recently became possible without
       * admin rights.
       * And even that, is only available in Developer Mode.
       * However, most tools (including JDK) have not yet adapted to this change and
       * still require admin rights.
       * Until that is fixed, we escape to a system tool that is known to behave
       * correcty in this regard.
       */
      var operating_system = System.getProperty("os.name");
      if (operating_system.toLowerCase().contains("win")) {
        var process = new ProcessBuilder();
        var command = process.command();
        command.add("cmd.exe");
        command.add("/c");
        command.add("mklink");
        if (is_directory) {
          command.add("/d");
        }
        command.add(target_path.toString());
        command.add(source_path.toString());
        log(command.toString());
        process.inheritIO()
            .start()
            .onExit()
            .join();
      } else {
        __.printStackTrace();
        throw fail("Could not create symbolic link!");
      }
    }
  }

  static String hostname() throws Exception {
    var process_builder = new ProcessBuilder().command("hostname");
    Process process;
    try {
      process = process_builder
          .start()
          .onExit()
          .join();
    } catch (IOException __) {
      process = new ProcessBuilder()
          .command("hostnamectl", "hostname")
          .start()
          .onExit()
          .join();
    }
    try (var reader = new InputStreamReader(process.getInputStream())) {
      int character = -1;
      var output = new StringBuilder();
      while ((character = reader.read()) != -1) {
        if (character == '\n' || character == '\r')
          continue;
        output.append((char) character);
      }
      return output.toString();
    }
  }

  static void usage() {
    log("Bootstraps bugabingas {0}.", emphasize_local("dorkfiles"));
    log("{0}: java bootstripper.java [dotfiles root path]", emphasize_global("Usage"));
  }

  static String emphasize_global(String message) {
    return "\033[4m" + message + "\033[0m";
  }

  static String emphasize_local(String message) {
    return "\033[3m" + message + "\033[0m";
  }

  static Throwable fail(String message, Object... arguments) {
    log(message, arguments);
    return fail();
  }

  static Throwable fail() {
    System.exit(-1);
    return new Throwable("use 'throw fail()' for control flow");
  }

  static void log(String message, Object... arguments) {
    System.out.println(format(message, arguments));
  }
}
