# Semantic aliases
export alias view = bat
export alias list = exa --group-directories-first --classify --all --long --icons --git
export alias tree = exa --tree --group-directories-first
export alias look = xplr
export alias browse = firefox
export alias edit = code

# TODO: HOST SPECIFIC ALIASES
# I do not see a way right now the have different aliases per host with nu.

# CUSTOM LITTLE JAVA COMMANDS
export alias aes = java (build-string $env.DOTFILES /tools/ aes.java)
export alias download = java (build-string $env.DOTFILES /tools/ download.java)
export alias download_jar = java (build-string $env.DOTFILES /tools/ download_jar.java)
