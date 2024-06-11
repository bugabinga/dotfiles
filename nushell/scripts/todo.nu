# Render my To-Do file in the terminal
export def main [] { mdcat ($env.NOTES | path join "TODO.md") }

# Open my To-Do file for editing
export def edit [] { nvim ($env.NOTES | path join "TODO.md") }

# Open a list of commands, that I would like to remember to use
export def commands [] { mdcat ($env.NOTES | path join "COMMANDS.md") }

# Open the list of commands to remember for editing.
export def "commands edit" [] { nvim ($env.NOTES | path join "COMMANDS.md") }
