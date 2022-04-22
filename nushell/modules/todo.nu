# Render my To-Do file in the terminal
export def todo [] { mdcat ($env.DOTFILES | path join "TODO.md") }
# Open my To-Do file for editing
export def "todo edit" [] { hx ($env.DOTFILES | path join "TODO.md")}
# Open a list of commands, that I would like to remember to use
export def "todo commands" [] { mdcat ($env.DOTFILES | path join "COMMANDS.md") }
# Open the list of commands to remember for editing.
export def "todo commands edit" [] { hx ($env.DOTFILES | path join "COMMANDS.md") }
