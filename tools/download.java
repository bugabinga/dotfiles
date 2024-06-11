import static java.lang.System.*;

import java.net.*;
import java.net.http.*;
import java.net.http.HttpClient.*;
import java.net.http.HttpResponse.*;
import java.nio.file.*;
import java.util.*;
import java.util.regex.*;

class download {
  public static void main(String[] command_line_arguments) {
    if (command_line_arguments.length < 1) {
      usage();
      fail("give me an url to download from!");
    }
    var client = HttpClient.newBuilder().followRedirects(Redirect.NORMAL).build();
    var source_name = command_line_arguments[0];
    var source = URI.create(source_name);
    var current_working_directory = System.getProperty("user.dir");
    Path target;
    if (command_line_arguments.length == 2) {
      target = Paths.get(current_working_directory, command_line_arguments[1]);
    } else {
      target = Paths.get(current_working_directory, guess_file_name(source_name));
    }
    out.printf("Downloading %s into %s.%n", emphasize_local(source.toString()), emphasize_local(target.toString()));
    download_ressource(client, source, target);
    // TODO: download links in html to other pages
    exit();
  }

  static String guess_file_name(String name) {
    return name.replaceAll("\\w+:\\/\\/", "").replaceAll("\\/", "_");
  }

  static void download_ressource(HttpClient client, URI source, Path target) {
    //TODO: handle copmressed ressources
    //TODO: show progess
    var request = HttpRequest.newBuilder().uri(source).build();
    client
    .sendAsync(request, BodyHandlers.ofFile(target))
    .thenAccept(response -> out.printf("Downloaded %s into %s!%n", emphasize_local(source.toString()), emphasize_global(response.body().toString())))
    .join();
  }

  static void usage() {
    out.printf("Downloads a file from an %s.%n", emphasize_local("URL"));
    out.printf("%s: java download.java <source url> <destination path>%n", emphasize_global("Usage"));
  }

  static void exit() {
    out.printf("%s!%n", emphasize_local("Done"));
    System.exit(0);
  }

  static String emphasize_global(String message) {
    return "\033[4m" + message + "\033[0m";
  }

  static String emphasize_local(String message) {
    return "\033[3m" + message + "\033[0m";
  }

  static void fail(String message, Object... arguments) {
    out.printf(message, arguments);
    System.exit(-1);
  }

  static void fail() {
    System.exit(-1);
  }
}
