# Render my To-Do file in the terminal
export def todo [] { mdcat ($env.NOTES | path join "TODO.md") }
# Open my To-Do file for editing
export def "todo edit" [] { edit ($env.NOTES | path join "TODO.md")}
# Open a list of commands, that I would like to remember to use
export def "todo commands" [] { mdcat ($env.NOTES | path join "COMMANDS.md") }
# Open the list of commands to remember for editing.
export def "todo commands edit" [] { edit ($env.NOTES | path join "COMMANDS.md") }
