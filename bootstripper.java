import static java.text.MessageFormat.format;

import java.io.IOException;
import java.io.InputStreamReader;
import java.nio.file.Files;
import java.nio.file.LinkOption;
import java.nio.file.Path;
import java.util.List;
import java.util.function.BiFunction;

class bootstripper {
    public static void main(String[] arguments) throws Throwable {
        var dorkfile_path_input = ".";
        var do_clean = false;
        var do_decrypt = false;

        if (arguments.length == 1) {
            if ("clean".equals(arguments[0])) {
                do_clean = true;
            }
						else if( "decrypt".equals(arguments[0])) {
							do_decrypt = true;
						} else {
                dorkfile_path_input = arguments[0];
            }
        } else if (arguments.length == 2) {
            if ("clean".equals(arguments[0])) {
                do_clean = true;
                dorkfile_path_input = arguments[1];
            }
						else if ("decrypt".equals(arguments[0])) {
                do_decrypt = true;
                dorkfile_path_input = arguments[1];
            } else {
                usage();
                throw fail();
            }
        } else if (arguments.length > 2) {
            usage();
            throw fail();
        }
        var dorkfiles_root = Path.of(dorkfile_path_input).toRealPath();
        log("Assuming dorkfiles root repo in {0}.",
                emphasize_local(dorkfiles_root.toString()));
        if (do_decrypt) {
					decrypt_secrets(dorkfiles_root.resolve("tresor"));
				} else {
					var hostname = hostname();
					log("Hostname: {0}", emphasize_global(hostname));
					var symlinks_file = dorkfiles_root.resolve(hostname + ".symlinks");
					if (Files.exists(symlinks_file)) {
							if (do_clean)
									delete_symlinks(dorkfiles_root, symlinks_file);
							else
									create_symlinks(dorkfiles_root, symlinks_file);
					} else {
							throw fail("Expected a file containing symlinks at: {0}. Found nothing!",
											symlinks_file);
					}
				}
    }

    static void decrypt_secrets(Path secrets_root) throws Throwable {
        log("{0}:Decrypting files in {1} folder, using rbw.", emphasize_global("TODO"),
                emphasize_local(secrets_root.getFileName().toString()));
    }

    static void create_symlinks(Path root, Path symlinks_file) throws Throwable {
        log("Creating symlinks as defined in {0} file.",
                emphasize_local(symlinks_file.getFileName().toString()));
        var lines = Files.readAllLines(symlinks_file);
        for_each_mapping(lines, (source, target) -> link(root, source, target));
    }

    static void delete_symlinks(Path root, Path symlinks_file) throws Throwable {
        log("Deleting symlinks as defined in {0} file.",
                emphasize_local(symlinks_file.getFileName().toString()));
        var lines = Files.readAllLines(symlinks_file);
        for_each_mapping(lines, (source, target) -> delete(root, source, target));
    }

    static void delete(Path root, String source, String target) throws Throwable {
        var home = System.getProperty("user.home");
        var source_path = root.resolve(source).toAbsolutePath();
        var target_path = Path.of(target.replace("~", home)).toAbsolutePath();

        if (Files.exists(target_path, LinkOption.NOFOLLOW_LINKS)) {
            if (Files.isSymbolicLink(target_path)) {
                log("\nOK {0} exists and points to {1}, a symlink indeed!\nDeleting {0}.",
                        emphasize_global(target_path.toString()),
                        emphasize_local(source_path.toString()));
                // a symlink is always a file. no need to handle folders
                Files.delete(target_path);
            } else {
                log("\nNOPE {0} exists, but it is not a symlink! Clean manually.",
                        target_path.toString());
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
                log("\nOK {0} already exists!\nNot linking {1}.",
                        emphasize_global(target_path.toString()),
                        emphasize_local(source_path.toString()));
                return;
            } else {
                log("\nNOPE {0} exists, but it points into nirvana. Removing broken link!",
                        target_path.toString());
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
             * Creating symbolic links on Windows only recently became possible
             * without admin rights. And even that, is only available in Developer
             * Mode. However, most tools (including JDK) have not yet adapted to this
             * change and still require admin rights. Until that is fixed, we escape
             * to a system tool that is known to behave correctly in this regard.
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
                process.inheritIO().start().onExit().join();
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
            process = process_builder.start().onExit().join();
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
          var name = output.toString();
          if( "localhost".equals(name) ) {
            // we are inside termux
            assert System.getenv("PREFIX") != null;
            return "termux";
          }
            return name;
        }
    }

    static void usage() {
        log("Bootstraps bugabingas {0}.", emphasize_local("dorkfiles"));
        log("{0}: java bootstripper.java [clean] [dotfiles root path]",
                emphasize_global("Usage"));
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

    static interface ThrowUp<A, B> {
        default Throwable gurgh(A a, B b) {
            try {
                apply(a, b);
                return null;
            } catch (Throwable vomit) {
                return vomit;
            }
        }

        void apply(A a, B b) throws Throwable;
    }

    static void for_each_mapping(List<String> lines, ThrowUp<String, String> block)
            throws Throwable {
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
                var vomit = block.gurgh(source, target);
                if (vomit != null)
                    throw vomit;
                source = null;
                target = null;
            }
        }
    }
}
