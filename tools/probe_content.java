import java.nio.file.*;
import java.io.*;

class probe_content {
  public static void main(String[] command_line_arguments) throws Throwable {
    if (command_line_arguments.length < 1) {
      throw panic("Give path to file or folder to probe content types of.");
    }
    var rawPath = command_line_arguments[0];
    var path = Paths.get(rawPath);
    if (!Files.exists(path)) {
      throw panic("The given path '%s' does not exist.", path);
    }
    if (Files.isRegularFile(path)) {
      printContentType(path);
    } else if (Files.isDirectory(path)) {
      Files.list(path).forEach(probe_content::printContentType);
    } else {
      throw panic("Dafuq is the given file '%s'???", path);
    }
  }

  private static String probeContentType(Path path) {
    try{
      var type = Files.probeContentType(path);
      if(type == null) return "[unknown]";
      return type;
    }
    catch(IOException __){
    return "[unknown]";
    }
  }

  private static void printContentType(Path path) {
    var type = probeContentType(path);
    print("File '%s' is of type '%s'.", path.getFileName(), type);
  }

  private static void print(String message, Object... parameters) {
    System.out.printf("%s%n", String.format(message, parameters));
  }

  private static Throwable panic(String message, Object... parameters) {
    print(message, parameters);
    System.exit(-1);
    return new Throwable();
  }
}
