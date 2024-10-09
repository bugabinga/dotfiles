# Check system status
export def main [] {
	check-deps

	let git_status_notes = [ '-C' $env.NOTES status ]
	let git_status_dotfiles = [ '-C' $env.DOTFILES status ]

	# print git $git_status_notes
	run-external git ...$git_status_notes
	# print git $git_status_dotfiles
	run-external git ...$git_status_dotfiles

	macchina
}

# Synchronize by uploading
export def up [] {
	check-deps

	let git_commit_notes = [ '-C' $env.NOTES commit '--all' ]
	let git_push_notes = [ '-C' $env.NOTES push ]
	let git_commit_dotfiles = [ '-C' $env.DOTFILES commit '--all' ]
	let git_push_dotfiles = [ '-C' $env.DOTFILES push ]

	# print git ...$git_commit_notes
	run-external git ...$git_commit_notes
	# print git $git_push_notes
	run-external git ...$git_push_notes
	# print git $git_commit_dotfiles
	run-external git ...$git_commit_dotfiles
	# print git $git_push_dotfiles
	run-external git ...$git_push_dotfiles
}

# Synchronise by downloading
export def down [] {
	check-deps

	let git_pull_notes = [ '-C' $env.NOTES pull '-ff' ]
	let git_pull_dotfiles = [ '-C' $env.DOTFILES pull '-ff' ]

	# print git $git_pull_notes
	run-external git ...$git_pull_notes
	# print git $git_pull_dotfiles
	run-external git ...$git_pull_dotfiles
	# print topgrade
	run-external topgrade
}

def all-exist [] { all { which $in | is-not-empty } }

def check-deps [] {
	let deps = [ git topgrade macchina ]
	if not ($deps | all-exist) {
		error make {
			msg: $"Install all of ($deps)"
		}
	}
}
