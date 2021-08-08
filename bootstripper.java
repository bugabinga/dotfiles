import java.nio.file.*;
import java.io.*;
import java.util.*;

class bootstripper{
  public static void main(String[] arguments) throws Exception {
    if(arguments.length == 0){
      usage();
      fail();
    }
    var dorkfiles_root = Path.of(arguments[0]).toRealPath();
    System.out.printf("Assuming dorkfiles root repo in %s.%n", emphasize_local(dorkfiles_root.toString()));
    decrypt_secrets(dorkfiles_root.resolve("secrets"));
    var hostname = hostname();
    System.out.printf("Hostname: %s%n", emphasize_global(hostname));
    var symlinks_file = hostname + ".symlinks";
    create_symlinks(dorkfiles_root.resolve(symlinks_file));
  }
  static void decrypt_secrets(Path secrets_root) throws Exception {
    System.out.printf("%s:Decrypting files in %s folder.%n", emphasize_global("TODO"), emphasize_local(secrets_root.getFileName().toString()));
  }
  static void create_symlinks(Path symlinks_file) throws Exception {
    System.out.printf("Creating symlinks as defined in %s file.%n", emphasize_local(symlinks_file.getFileName().toString()));
    var lines = Files.readAllLines(symlinks_file);
    String source = null;
    String target = null;
    for(String line : lines){
      if(line.isBlank()) continue;
      if (source == null) source = line;
      else if (target == null) target = line;
      if(source != null && target != null){
        link(source, target);
        source = null;
        target = null;
      }
    }
  }
  static void link(String source, String target) throws Exception {
    var home = System.getProperty("user.home");
    var source_path = Path.of(source.replace("~", home)).toAbsolutePath();
    var target_path = Path.of(target.replace("~", home)).toAbsolutePath();
    var is_directory = Files.isDirectory(source_path);
    if(Files.exists(target_path, LinkOption.NOFOLLOW_LINKS)){
      System.out.printf("✅%s already exists!%nNot linking %s.%n", emphasize_global(target_path.toString()), emphasize_local(source_path.toString()));
    }
    else{
      System.out.printf("🔗 %s ➔ %s.%n", emphasize_local(source_path.toString()), emphasize_local(target_path.toString()));
      if(!is_directory){
        Files.createDirectories(target_path.getParent());
      }
      try{
        Files.createSymbolicLink(target_path, source_path);
      }
      catch (Exception __) {
        /*
         * Creating symbolic links on Windows only recently became possible without admin rights.
         * However, most tools (including JDK) have not yet adapted to this change and still require admin rights.
         * Until that is fixed, we escape to a system tool that is known to behave correcty in this regard.
         */
        var operating_system = System.getProperty("os.name");
        if(operating_system.toLowerCase().contains("win")){
          var process = new ProcessBuilder();
          var command = process.command();
          command.add("cmd.exe");
          command.add("/c");
          command.add("mklink");
          if(is_directory){
            command.add("/d");
          }
          command.add(target_path.toString());
          command.add(source_path.toString());
          process.inheritIO()
          .start()
          .onExit()
          .join();
        }
	else {
  	  __.printStackTrace();
	  fail("Could not create symbolic link!");
	}
      }
    }
  }
  static String hostname() throws Exception {
    var process = new ProcessBuilder()
    .command("hostname")
    .start()
    .onExit()
    .join();
    try(var reader = new InputStreamReader(process.getInputStream()))
    {
      int character = -1;
      var output = new StringBuilder();
      while((character = reader.read()) != -1){
        if(character == '\n' || character == '\r') continue;
        output.append((char)character);
      }
      return output.toString();
    }
  }
  static void usage() {
    System.out.printf("Bootstraps bugabingas %s.%n", emphasize_local("dorkfiles"));
    System.out.printf("%s: java bootstripper.java <dotfiles root path>%n", emphasize_global("Usage"));
  }
  static void exit() {
    System.exit(0);
  }
  static String emphasize_global(String message) {
    return "\033[4m" + message + "\033[0m";
  }
  static String emphasize_local(String message) {
    return "\033[3m" + message + "\033[0m";
  }
  static void fail(String message, Object... arguments) {
    System.out.printf(message, arguments);
    System.exit(-1);
  }
  static void fail() {
    System.exit(-1);
  }
}
