# To add entries to PATH (on Windows you might use Path), you can use the following pattern:
# export env PATH { ($env.PATH | prepend '/some/path') }
#TODO CARGO_HOME

# GLOBAL VARIABLES

export env WIN32? { (sys).host.name =~ "Windows" }
export env NURC_DIR  { ($nu.config-path| path expand | path dirname) }
export env DOTFILES  { ($env.NURC_DIR| path join ".." | path expand) }
export env WORKSPACE { if $env.WIN32? { "W:" } else { "~/Workspace" } }
