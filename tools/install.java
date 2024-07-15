import static java.lang.System.out;
import static java.lang.System.err;

import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.Arrays;

final class install {
	//  TODO: platform key in die csv, um os zu unterscheiden.
	static final String CARGO_PACKAGES_CSV_FILE = "tools.csv";

	public static void main(String[] __)
			throws Throwable {
		exec("cargo", "--version");

		var csv = Path.of(CARGO_PACKAGES_CSV_FILE);
		if (!Files.exists(csv)) {
			throw fail("Expected a CSV file with cargo crates!");
		}

		var lines = Files.lines(csv).toArray(String[]::new);
		for (int index = 1; index < lines.length; ++index) {
			var line = lines[index];
			var spec = parse(line);
			if (spec != null && !which(spec.bin)) {
				install(spec);
			}
		}
	}

	static boolean which(String program) {
		var pathEnv = System.getenv("PATH");

		if (pathEnv == null || pathEnv.isEmpty()) {
			return false;
		}

		var paths = pathEnv.split(System.getProperty("path.separator"));
		var extensions = new String[] { "", ".exe", ".bat", ".cmd", ".com" };

		for (var path : paths) {
			for (var extension : extensions) {
				var fullPath = Paths.get(path, program + extension);
				if (Files.exists(fullPath) && Files.isExecutable(fullPath)) {
					return true;
				}
			}
		}

		return false;
	}

	static void exec(String... command)
			throws Throwable {
		var proc = new ProcessBuilder(command).inheritIO().start();
		proc.waitFor();
		var exit = proc.exitValue();
		if (exit != 0) {
			throw fail("process failed to exec with code %d.%nproc: %s", exit, emphasize_local(Arrays.toString(command)));
		}
	}

	static void install(Spec spec)
			throws Throwable {
		out("cargo install %s (%s) %s",
				emphasize_global(spec.name),
				emphasize_local(spec.bin),
				emphasize_local(Arrays.toString(spec.flags)));

		var cmd = new String[3 + spec.flags.length];
		cmd[0] = "cargo";
		cmd[1] = "install";
		cmd[2] = spec.name;

		System.arraycopy(spec.flags, 0, cmd, 3, spec.flags.length);

		exec(cmd);
	}

	record Spec(String name, String bin, String... flags) {
	};

	static Spec parse(String line)
			throws Throwable {
		if (line.startsWith("#"))
		{
			return null;
		}
		var by_comma = line.split(";");
		if (by_comma.length == 0) {
			throw fail("empty line in CSV");
		}
		if (by_comma.length > 3) {
			throw fail("line in CSV should have 1-3 fields%nfound: %s", emphasize_local(line));
		}
		var name = by_comma[0].strip();
		var bin = name;
		if (by_comma.length > 1) {
			bin = by_comma[1].strip();
		}
		var flags = new String[] {};
		if (by_comma.length == 3) {
			flags = by_comma[2].strip().split(" ");
		}
		return new Spec(name, bin, flags);
	}

	static void out(String fmt, Object... args) {
		out.printf(fmt, args);
		out.println();
	}

	static void dbg(String fmt, Object... args) {
		System.err.print("[DBG]: ");
		System.err.printf(fmt, args);
		System.err.println();
	}

	static Throwable exit() {
		System.exit(0);
		// abuse control flow to make compiler realize `exit` will never return
		return new Throwable();
	}

	static String emphasize_global(String message) {
		return "\033[4m" + message + "\033[0m";
	}

	static String emphasize_local(String message) {
		return "\033[3m" + message + "\033[0m";
	}

	static Throwable fail(String message, Object... arguments) {
		err.printf(message, arguments);
		System.exit(-1);
		// abuse control flow to make compiler realize `fail` will never return
		return new Throwable();
	}

	static Throwable fail() {
		System.exit(-1);
		// abuse control flow to make compiler realize `fail` will never return
		return new Throwable();
	}
}
