import static java.lang.System.out;

import java.io.*;
import java.net.*;
import java.net.http.*;
import java.net.http.HttpResponse.*;
import java.nio.file.*;
import java.util.*;
import java.util.concurrent.ConcurrentSkipListSet;

class download_jar {
  public static void main(final String[] command_line_arguments) {
    help();
    var current_working_directory = Paths.get(System.getProperty("user.dir"));
    var download_directory = current_working_directory.resolve("downloaded_artifacts");
    var maven_repository = "https://repo.maven.apache.org/maven2";
    var expected_count_of_arguments = 3;
    if (contains(command_line_arguments, "-d")) {
      expected_count_of_arguments = expected_count_of_arguments + 2;
      try {
        var given_download_directory = command_line_arguments[index_of(command_line_arguments, "-d") + 1];
        download_directory = current_working_directory.resolve(given_download_directory);
      } catch (IndexOutOfBoundsException exception) {
        out.println("The -d option requires an argument.");
        usage();
        fail();
      }
    }
    if (contains(command_line_arguments, "-r")) {
      expected_count_of_arguments = expected_count_of_arguments + 2;
      try {
        var given_maven_repository = command_line_arguments[index_of(command_line_arguments, "-r") + 1];
        maven_repository = given_maven_repository;
      } catch (IndexOutOfBoundsException exception) {
        out.println("The -r option requires an argument.");
        usage();
        fail();
      }
    }
    if (command_line_arguments.length != expected_count_of_arguments) {
      usage();
      fail();
    }
    var maven_coordinates_reversed = new String[3];
    for (var index = 2; index >= 0; --index) {
      maven_coordinates_reversed[index] = command_line_arguments[expected_count_of_arguments - index - 1];
    }
    var group_id = maven_coordinates_reversed[2];
    var artifact_id = maven_coordinates_reversed[1];
    var version = maven_coordinates_reversed[0];

    if (Files.exists(download_directory) && Files.isRegularFile(download_directory)) {
      fail("The given download directory path %s already points to a file!%n", download_directory.toString());
    } else if (!Files.exists(download_directory)) {
      out.printf("Creating directory at %s%n.", emphasize_global(download_directory.toString()));
      try {
        Files.createDirectories(download_directory);
      } catch (IOException __) {
        fail("Unable to create directory at %s", emphasize_global(download_directory.toString()));
      }
    }

    var expected_artifact_base_url = guess_maven_artifact_url(maven_repository, group_id, artifact_id, version);
    var client = HttpClient.newHttpClient();
    var request = HttpRequest.newBuilder().uri(URI.create(expected_artifact_base_url)).build();
    var target_directory = download_directory;
    client.sendAsync(request, BodyHandlers.ofString()).thenApply(HttpResponse::statusCode).thenAccept(status -> {
      if (status > 299) {
        fail("Could not find maven artifact at %s.%n", expected_artifact_base_url);
      } else {
        download_ressource(client, target_directory,
            build_ressource_url(expected_artifact_base_url, artifact_id, version, ".jar"));
        download_ressource(client, target_directory,
            build_ressource_url(expected_artifact_base_url, artifact_id, version, "-sources.jar"));
        // FIXME BLOCKER! How do we implement the version clash resolution?
        // Preferably in a manner that avoids pointless downloads...
        var processed_cache = new ConcurrentSkipListSet<String>();
        process_pom(client, processed_cache,
            build_ressource_url(expected_artifact_base_url, artifact_id, version, ".pom"));
      }
    }).join();

    out.printf("download directory:\t%s%nmaven repository:\t%s%nmaven coordinates:\t%s:%s:%s%n",
        emphasize_global(download_directory.toString()), emphasize_global(maven_repository), emphasize_global(group_id),
        emphasize_global(artifact_id), emphasize_global(version));
    exit();
  }

  static Collection<String> process_pom(HttpClient client, Set<String> processed, String pom_url) {
    if (processed.contains(pom_url))
      return Collections.emptyList();
    var request = HttpRequest.newBuilder().uri(URI.create(pom_url)).build();
    return client.sendAsync(request, BodyHandlers.ofInputStream()).thenApply(input -> {
      // TODO add pom to list of processed so that a pom only ever gets read once
      processed.add(pom_url);
      // TODO traverse path to root of poms and collect managed dependencies
      // TODO collect declared dependencies from given pom
      return List.<String>of();
    }).join();
  }

  static void download_ressource(HttpClient client, Path target_directory, String ressource_url) {
    var request = HttpRequest.newBuilder().uri(URI.create(ressource_url)).build();
    var ressource_name = ressource_url.substring(ressource_url.lastIndexOf('/') + 1);
    var target_ressource_path = target_directory.resolve(ressource_name);
    client.sendAsync(request, BodyHandlers.ofFile(target_ressource_path)).join();
  }

  static String build_ressource_url(String base, String artifact_id, String version, String suffix) {
    var url = new StringBuilder(base);
    if (!base.endsWith("/"))
      url.append('/');
    url.append(artifact_id);
    url.append('-');
    url.append(version);
    url.append(suffix);
    return url.toString();
  }

  static String guess_maven_artifact_url(String base, String group_id, String artifact_id, String version) {
    var url = new StringBuilder(base);
    if (!base.endsWith("/"))
      url.append('/');
    url.append(group_id.replaceAll("\\.", "\\/"));
    url.append('/');
    url.append(artifact_id);
    url.append('/');
    url.append(version);
    url.append('/');
    return url.toString();
  }

  static class Dependency {
    String artifactId;
    String groupId;
    String version;
    String scope;
    boolean optional;
  }

  static <T> int index_of(T[] array, T item) {
    var length = array.length;
    if (length == 0)
      return -1;
    for (var index = 0; index < length; ++index) {
      var element = array[index];
      if (Objects.equals(element, item))
        return index;
    }
    return -1;
  }

  @SafeVarargs
  static <T> boolean contains(T[] array, T... items) {
    if (array.length == 0)
      return false;
    if (items.length == 0)
      return false;
    for (var element : array) {
      for (var argument : items) {
        if (element.equals(argument))
          return true;
      }
    }
    return false;
  }

  static void help() {
    out.printf("Downloads an artifact from a %s repository with its %s.%n", emphasize_local("maven"),
        emphasize_local("transitive dependencies"));
  }

  static void usage() {
    out.printf("%s: java download_jar.java <group id> <artifact id> <version>%n", emphasize_global("Usage"));
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
