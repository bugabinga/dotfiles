export def main [
	--clear-cache
	--cache = "~/.cache/packages"
	--packages = "~/Tools/packages.csv"
	--prefix = "~/Tools"
] {
	check_dependencies
	let prefix = $prefix | path expand
	let packages = $packages | path expand
	let packages = open --raw $packages | from csv --separator ';' --comment '#' --trim all
	let cache = $cache | path expand
	if $clear_cache {
		rm --recursive --trash --interactive-once $cache
		return
	}
	mkdir $cache

	print $"Downloading packages..."
	let $packages_file = mktemp --suffix _packages.txt --tmpdir XXX
	$packages | get url | save --force $packages_file
	run-external dlm '--maxConcurrentDownloads' 4 '--inputFile' $packages_file '--outputDir' $cache 

	$packages | each { |package| 

		# pipe through url parse for validation
		let base = $package.url | url parse | get path | path basename
		let cached = $cache | path join $base

		print $"Installing ($package.name)"
		if ($cached | is-archive) {
			print $"Decompressing ($package.name)..."
			run-external ouch decompress '--quiet' $cached '--dir' $prefix
		} else {
			error make {
				msg: $"The package ($package.name) does not seem to be an archive."
			}
		}

		print $"TODO: Symlinks"
	}
}

def is-archive [] {
	[ .zip .tar.gz .tar.bz2 .tar.xz .7z ] | any { |ext| $in | str ends-with $ext }
}

def remove-archive-extension [] {
	let uri = $in
	[ .zip .tar.gz .tar.bz2 .tar.xz .7z ] | reduce --fold $uri { |ext, acc|
		$acc | str replace $ext ''
	} | str trim
}

def check_dependencies [] {
	let missing = [ ouch dlm ] | any { which $in | is-empty }
	if $missing {
		error make {
			msg: 'Some dependency is missing!'
		}
	}
}
