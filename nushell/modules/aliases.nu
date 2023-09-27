# Semantic aliases
export alias show = bat
export def list [] { ls --all --long --du --mime-type | where type == dir | append (ls --all --long --du --mime-type | where type != dir) }
export alias web = firefox
export alias edit = hx
# TODO ewrite bak command
export alias backup = bak

# https://gist.github.com/mullnerz/9fff80593d6b442d5c1b
export alias archive = wget -mpck --html-extension --user-agent="" -e robots=off --wait 1 -P .

def-env workspace [] {
	fd --type directory --max-depth 1 . $env.WORKSPACE | sk --ansi --preview 'test -f {}README.md&& mdcat {}README.md' --preview-window 'right:66%' | cd $in
}
export alias w =  workspace

export def-env lk [] {
	cd (walk --icons)
}

def open-editor-with-content-search [ initial_query:string = ''] {
	sk --ansi --interactive --cmd-query $initial_query --delimiter ':' --nth 1 --cmd "rg --color=always --line-number {}" --preview 'bat --color=always {1}' --color light | parse '{file}:{number}:{line}' | each { nvim -c $in.number -c $"?\\V($in.line | str trim )" $in.file }
}
export alias nc = open-editor-with-content-search

def open-editor-with-file-search [ initial_query:string = ''] {
	sk --ansi --interactive --cmd-query $initial_query --delimiter ':' --nth 1 --cmd "fd --type file --color=always {}" --preview 'bat --color=always {1}' --color light | str trim | each { nvim $in }
}
export alias nf = open-editor-with-file-search

# TODO: HOST SPECIFIC ALIASES
# I do not see a way right now the have different aliases per host with nu.

# CUSTOM LITTLE JAVA COMMANDS
export alias aes = java ($env.DOTFILES + /tools/ + aes.java)
export alias download = java ($env.DOTFILES + /tools/ + download.java)
export alias download_jar = java ($env.DOTFILES + /tools/ + download_jar.java)

# systemd
export alias userctl = systemctl --user
