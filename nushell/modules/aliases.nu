# Semantic aliases
export alias view = bat
export alias list = exa --group-directories-first --classify --all --long --icons --git
export alias tree = exa --tree --group-directories-first
export alias look = xplr
export alias browse = firefox
export alias edit = hx

# CUSTOM LITTLE JAVA COMMANDS
export alias aes = java (build-string $env.DOTFILES /tools/ aes.java)
export alias download = java (build-string $env.DOTFILES /tools/ download.java)
export alias download_jar = java (build-string $env.DOTFILES /tools/ download_jar.java)

# Open manual page.
# On Windows, a man web page is opened.
export def man [
  ...rest: string # Arguments to man
] {
  if $env.WIN32? {
    ^start (build-string https://man.archlinux.org/man/ ($rest | to-string))
  } else {
    ^man $rest
  }
}

# Search the given query on the web with the default browser in DuckDuckGo.
export def web [
  ...rest:string # The search query
] {
  let query = (build-string "https://duckduckgo.com/?q=" ($rest | to-string))
  if $env.WIN32? {
    # There seems to be an issue with the nu start command on windows: It does not handle URLs
    # Using windows command for now:
    ^start $query
  } else {
    xdg-open $query
  }
}
