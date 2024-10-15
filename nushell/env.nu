# GLOBAL VARIABLES

$env.WIN32 = ( $nu.os-info.name =~ "windows" )

$env.WORKSPACE = if $env.WIN32 { "~/Workspaces" } else { "~/Workspace" | path expand }
$env.DOTFILES  = ( $env.WORKSPACE | path join 'dotfiles' )
$env.NOTES = ("~/Notes" | path expand)
$env.TOOLS = ("~/Tools" | path expand)
$env.CARGO_HOME = ( "~/.cargo" | path expand )
$env.GO_HOME = ( "~/go" | path expand )
$env.BARTIB_FILE = ( $env.NOTES | path join 'timetrack.txt')

if $env.WIN32 {
	$env.Path = (
  $env.Path
  | split row (char esep)
  | append ($env.CARGO_HOME | path join bin)
  | append ($env.HOME | path join .local bin)
  | uniq # filter so the paths are unique
)
} else {
	$env.PATH = (
  $env.PATH
  | split row (char esep)
  | append ($env.CARGO_HOME | path join bin)
  | append ($env.GO_HOME | path join bin)
  | append ($env.HOME | path join .local bin)
  | uniq # filter so the paths are unique
)
}

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

if ( not $env.WIN32 )  {
	let tools_bin = ( $env.TOOLS | path join bin )
	$env.PATH = (
		$env.PATH |
		split row (char esep) |
		prepend $tools_bin
	)
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

$env.NU_LIB_DIRS = [
	($nu.default-config-dir | path join 'scripts')
	($nu.default-config-dir | path join 'completions')
]

# generate aliases here and now, so that we can apply conditions.
# later, in config.nu, the evaluated aliases will be sourced
source ($nu.default-config-dir | path join 'gen-aliases.nu')

# generate zoxide hooks for sourcing later on
let zoxide_config_path = $nu.default-config-dir | path join 'zoxide.nu'
if not (which zoxide |  is-empty) {
	zoxide init nushell | save --force $zoxide_config_path
} else {
	'' | save -f $zoxide_config_path
}

let carapace_config_path = $nu.default-config-dir | path join 'carapace.nu'
if not (which carapace | is-empty) {
	carapace _carapace nushell | save --force $carapace_config_path
} else {
	'' | save --force $carapace_config_path
}

def --env wslg [] {
	load-env {
		DISPLAY:':0'
		WAYLAND_DISPLAY:'wayland-0'
		PULSE_SERVER:'/mnt/wslg/PulseServer'
		XDG_RUNTIME_DIR:'/mnt/wslg/runtime-dir'
	}
}

if ( $env | get -i WSLENV | is-not-empty ) { wslg }
