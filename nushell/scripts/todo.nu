def print_markdown [ md: path ] {
	if not ( which mdcat | is-empty ) { mdcat $md; return }
	if not ( which bat | is-empty ) { bat $md; return }
	if not ( which glow | is-empty ) { glow $md; return }
	open $md
}

# Render my To-Do file in the terminal
export def main [] { print_markdown ($env.NOTES | path join "TODO.md") }

# Open my To-Do file for editing
export def edit [] { run-external $env.EDITOR ($env.NOTES | path join "TODO.md") }

# Open a list of commands, that I would like to remember to use
export def commands [] { print_markdown ($env.NOTES | path join "COMMANDS.md") }

# Open the list of commands to remember for editing.
export def "commands edit" [] { run-external $env.EDITOR ($env.NOTES | path join "COMMANDS.md") }
