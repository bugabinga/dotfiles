export def list [] { ls --all --long --du --mime-type | where type == dir | append (ls --all --long --du --mime-type | where type != dir) }

export def fkill [ query:string ] {
  let pid = (^ps -ef | sed 1d | fzf -m --query $query | awk '{print $2}')
  if not ($pid | is-empty) {
  	kill ($pid | into int )
	}
}

export def --env yy [...args] {
	let tmp = (mktemp -t "yazi-cwd.XXXXXX")
	yazi ...$args --cwd-file $tmp
	let cwd = (open $tmp)
	if $cwd != "" and $cwd != $env.PWD {
		cd $cwd
	}
	rm -fp $tmp
}

# creates a backup of the given file in a temporary directory and prints the path
export def bak [
	file: path # the file to copy into a backup
] {
	if not ($file | path exists ) {
		error make {
			msg: "The file to backup does not exist.",
			label: {
				text: "Missing its existence!",
				span: (metadata $file).span
			}
		}
	}
	let full_path = $file | path expand
	let tmpdir = mktemp --directory --tmpdir backup_XXX
	let backup = $tmpdir | path join ( $file | path basename )
	let backup_original_path = $tmpdir | path join 'original.path'
	$full_path | save $backup_original_path
	cp --preserve [ mode timestamps ] $file $backup
	print $backup
}
	
# restores a backup previously made with `bak` command
export def kab [
	backup: path # a backup file to restore
] {
	if not ($backup | path exists ) {
		error make {
			msg: "The backup file does not exist.",
			label: {
				text: "Missing its existence!",
				span: (metadata $backup).span
			}
		}
	}
	let backup_file = $backup | path expand
	if ($backup_file !~ 'backup_' ) {
		error make {
			msg: "The file does not seem to be a backup file from `bak`.",
			label: {
				text: "Are u even bak'ed up?",
				span: (metadata $backup).span
			}
		}
	}
	let backup_dir = $backup | path dirname
	let original_path_file = $backup_dir | path join 'original.path'
	let original_path = open --raw $original_path_file
	try {
		mv --progress --interactive --verbose $backup_file $original_path
	} catch {
		return # skip deletion
	}
	rm --trash --recursive $backup_dir
}
