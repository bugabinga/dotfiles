use prompt.nu *
use commands.nu *
use bw.nu
use todo.nu
use ssh-keygen-ed.nu
use md.nu
use start.nu
use timer.nu
use dwnld.nu

if $env.WIN32 {
	use refreshenv.nu *
}

source ($nu.default-config-dir | path join 'aliases.nu')

# must be done, after defining config, since zoxide mutates it
# this will fail if zoxide is not installed yet
source ($nu.default-config-dir | path join "zoxide.nu")

source ($nu.default-config-dir | path join "scripts/direnv.nu")

todo commands
print (char nl)
todo

