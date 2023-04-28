# Semantic aliases
export alias view = bat
export alias list = exa --group-directories-first --classify --all --long --icons --git
export alias tree = exa --tree --group-directories-first
export alias look = xplr
export alias browse = firefox
export alias edit = hx

# TODO: HOST SPECIFIC ALIASES
# I do not see a way right now the have different aliases per host with nu.

# CUSTOM LITTLE JAVA COMMANDS
export alias aes = java ($env.DOTFILES + /tools/ + aes.java)
export alias download = java ($env.DOTFILES + /tools/ + download.java)
export alias download_jar = java ($env.DOTFILES + /tools/ + download_jar.java)

# systemd
export alias userctl = systemctl --user
