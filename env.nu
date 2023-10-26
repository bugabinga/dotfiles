# GLOBAL VARIABLES
# GLOBAL VARIABLES

$env.WIN32 = ( $nu.os-info.name =~ "windows" )
$env.NURC_DIR  = ( $nu.config-path | path expand | path dirname )
$env.DOTFILES  = ( $env.NURC_DIR | path join ".." | path expand )
$env.WORKSPACE = if $env.WIN32 { "W:/" } else { "~/Workspace" | path expand }
$env.NOTES = if $env.WIN32 { "N:/" } else { "~/Notes" | path expand }
if ($env | get -i TERM_PROGRAM) == WezTerm {
	$env.TERM = "wezterm"
	$env.TERMCAP = ~/.terminfo/w/wezterm
}

# theme for ls and other programs, that use LS_COLORS
$env.LS_COLORS = (try { vivid generate ayu | into string } catch {""})

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

# Directories to search for scripts when calling source or use
$env.NU_LIB_DIRS = [
    ($nu.config-path | path dirname | path join 'modules'),
    ($nu.config-path | path dirname | path join 'completions')
]

alias cb = flatpak run app.getclipboard.Clipboard

$env.CLIPBOARD_EDITOR = nvim
$env.CLIPBOARD_HISTORY = 100000
$env.CLIPBOARD_PERSISTDIR = /home/oli/Clipboard
$env.CLIPBOARD_NOAUDIO = 1
# $env.CLIPBOARD_NOGUI = 1
$env.CLIPBOARD_THEME = light
