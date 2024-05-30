# GLOBAL VARIABLES

$env.WIN32 = ( $nu.os-info.name =~ "windows" )
$env.NURC_DIR  = ( $nu.config-path | path expand | path dirname )
$env.DOTFILES  = ( $env.NURC_DIR | path join ".." | path expand )
$env.WORKSPACE = if $env.WIN32 { "~/Workspaces" } else { "~/Workspace" | path expand }
$env.NOTES = ("~/Notes" | path expand)
$env.TOOLS = ("~/Tools" | path expand)

if not (which nvim | is-empty) {
	$env.EDITOR = 'nvim'
	$env.GIT_EDITOR = 'nvim'
}

if not (which neovide | is-empty) {
	$env.VISUAL = 'neovide'
}

if ($env | get -i TERM_PROGRAM) == WezTerm {
  $env.TERM =  "xterm-256color"
}

# theme for ls and other programs, that use LS_COLORS
$env.LS_COLORS = (try { vivid generate alabaster_dark | into string } catch {""})

# Specifies how environment variables are:
# - converted from a string to a value on Nushell startup (from_string)
# - converted from a value back to a string when running external commands (to_string)
# Note: The conversions happen *after* config.nu is loaded
$env.ENV_CONVERSIONS = {
  "PATH": {
    from_string: { |s| $s | split row (char esep) }
    to_string: { |v| $v | str join (char esep) }
  }
  "Path": {
    from_string: { |s| $s | split row (char esep) }
    to_string: { |v| $v | str join (char esep) }
  }
}
