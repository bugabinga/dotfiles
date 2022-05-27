# GLOBAL VARIABLES

let-env WIN32? = $nu.os-info.name =~ "windows" 
let-env NURC_DIR  = ($nu.config-path| path expand | path dirname)
let-env DOTFILES  = ($env.NURC_DIR| path join ".." | path expand) 
let-env WORKSPACE = if $env.WIN32? { "W:/misc" } else { "~/Workspace" } 
let-env CARGO_HOME = if $env.WIN32? { "C:/Users/okr/.cargo" } else { "~/.cargo" } 

# Specifies how environment variables are:
# - converted from a string to a value on Nushell startup (from_string)
# - converted from a value back to a string when running external commands (to_string)
# Note: The conversions happen *after* config.nu is loaded
let-env ENV_CONVERSIONS = {
  "PATH": {
    from_string: { |s| $s | split row (char esep) }
    to_string: { |v| $v | str collect (char esep) }
  }
  "Path": {
    from_string: { |s| $s | split row (char esep) }
    to_string: { |v| $v | str collect (char esep) }
  }
}

# Directories to search for scripts when calling source or use
let-env NU_LIB_DIRS = [
    ($nu.config-path | path dirname | path join 'modules'),
    ($nu.config-path | path dirname | path join 'completions')
]

# Directories to search for plugin binaries when calling register
let-env NU_PLUGIN_DIRS = [
    ($nu.config-path | path dirname | path join 'plugins'),
    ($env.CARGO_HOME | path join 'bin'),
]