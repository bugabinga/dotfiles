use prompt.nu *
use commands.nu *
use todo.nu
use ssh-keygen-ed.nu
use md.nu
use start.nu

source ($nu.default-config-dir | path join 'aliases.nu')

# must be done, after defining config, since zoxide mutates it
# this will fail if zoxide is not installed yet
source ($nu.default-config-dir | path join "zoxide.nu")
