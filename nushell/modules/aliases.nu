# Semantic aliases
export alias show = bat
export def list [] { ls --all --long --du --mime-type | where type == dir | append (ls --all --long --du --mime-type | where type != dir) }
export alias browse = firefox
export alias edit = hx
# TODO ewrite bak command
export alias backup = bak

# TODO: HOST SPECIFIC ALIASES
# I do not see a way right now the have different aliases per host with nu.

# update windows user environment variables
alias ue = let-env Path = (do $env.ENV_CONVERSIONS.Path.from_string (powershell -C '[System.Environment]::GetEnvironmentVariable('PATH', [System.EnvironmentVariableTarget]::User)') | append $env.Path | flatten | uniq)

# CUSTOM LITTLE JAVA COMMANDS
export alias aes = java ($env.DOTFILES + /tools/ + aes.java)
export alias download = java ($env.DOTFILES + /tools/ + download.java)
export alias download_jar = java ($env.DOTFILES + /tools/ + download_jar.java)

# systemd
export alias userctl = systemctl --user
