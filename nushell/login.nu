use prompt.nu *
use commands.nu *
use bw.nu
use todo.nu
use ssh-keygen-ed.nu
use md.nu
use start.nu
use timer.nu
use dwnld.nu
use packages.nu
use fedora_bootstrip.nu
use notes.nu

use svn-completions.nu *

if $env.WIN32 {
	use refreshenv.nu *
}

source ($nu.default-config-dir | path join 'aliases.nu')

# must be done, after defining config, since zoxide mutates it
# this will fail if zoxide is not installed yet
source ($nu.default-config-dir | path join "zoxide.nu")

# FIXME: just like the zoxide script, this will fail if carapace is not around
# in both cases an empty file needs to be genereated, if the commands are not in PATH
# so that this source never fails
source ( [$nu.home-path '.cache' 'carapace' 'init.nu'] | path join)

source ($nu.default-config-dir | path join "scripts/direnv.nu")

todo commands
print (char nl)
todo

