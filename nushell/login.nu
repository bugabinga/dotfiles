use prompt.nu *
use commands.nu *
use sy.nu
use bw.nu
use md.nu
use todo.nu
use ssh-keygen-ed.nu
use md.nu
use start.nu
use timer.nu
use dwnld.nu
use packages.nu
use fedora_bootstrip.nu
use notes.nu
use direnv.nu

use svn-completions.nu *

use svn-completions.nu *

if $env.WIN32 {
	use refreshenv.nu *
}

source ($nu.default-config-dir | path join 'aliases.nu')
source ($nu.default-config-dir | path join "zoxide.nu")
source ($nu.default-config-dir | path join "carapace.nu")


todo commands
print (char nl)
todo

