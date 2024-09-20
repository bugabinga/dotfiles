# GLOBAL VARIABLES

$env.WIN32 = ( $nu.os-info.name =~ "windows" )

$env.WORKSPACE = if $env.WIN32 { "~/Workspaces" } else { "~/Workspace" | path expand }
$env.DOTFILES  = ( $env.WORKSPACE | path join 'dotfiles' )
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
]

# generate aliases here and now, so that we can apply conditions.
# later, in config.nu, the evaluated aliases will be sourced
source ($nu.default-config-dir | path join 'gen-aliases.nu')

# generate zoxide hooks for sourcing later on
if not (which zoxide |  is-empty) {
	zoxide init nushell | save -f ($nu.default-config-dir | path join 'zoxide.nu')
}
