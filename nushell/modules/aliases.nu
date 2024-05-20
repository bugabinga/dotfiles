# Semantic aliases
export alias show = bat
export def list [] { ls --all --long --du --mime-type | where type == dir | append (ls --all --long --du --mime-type | where type != dir) }
export alias walk = yazi
export alias browse = firefox
export alias vim = nvim
export alias edit = nvim --clean
# TODO ewrite bak command
export alias backup = bak

export alias userctl = systemctl --user

# https://gist.github.com/mullnerz/9fff80593d6b442d5c1b
export alias archive = wget -mpck --html-extension --user-agent="" -e robots=off --wait 1 -P .

# FIXME: README preview does not work (in WSL2)
def --env workspace [] {
	fd --type directory --max-depth 1 . $env.WORKSPACE | fzf --ansi --preview 'mdcat {}README.md' --preview-window 'up:69%,border-bottom' | cd $in
}
export alias w =  workspace

def open-editor-with-content-search [ initial_query:string = ''] {
	rg --color=always --line-number --no-heading --smart-case $initial_query | fzf --ansi --delimiter : --preview 'bat --color=always {1} --highlight-line {2}' --color "hl:-1:underline,hl+:-1:underline:reverse" --preview-window 'up,60%,border-bottom,+{2}+3/3,~3' | parse '{file}:{number}:{line}' | each { nvim -c $in.number -c $"?\\V($in.line | str trim )" $in.file }

}
export alias nc = open-editor-with-content-search

def open-editor-with-file-search [ initial_query:string = ''] {
	fd --type file --color=always ign | fzf --ansi --preview 'bat --color=always {1}' --preview-window 'up,60%,border-bottom,+{2}+3/3,~3' | str trim | each { nvim $in }
}
export alias nf = open-editor-with-file-search

export def fkill [ query:string ] {
  let pid = (^ps -ef | sed 1d | fzf -m --query $query | awk '{print $2}')
  if not ($pid | is-empty) {
  	kill ($pid | into int )
	}
}

export def --env yy [...args] {
	let tmp = (mktemp -t "yazi-cwd.XXXXXX")
	yazi ...$args --cwd-file $tmp
	let cwd = (open $tmp)
	if $cwd != "" and $cwd != $env.PWD {
		cd $cwd
	}
	rm -fp $tmp
}

# TODO: HOST SPECIFIC ALIASES
# I do not see a way right now the have different aliases per host with nu.

# CUSTOM LITTLE JAVA COMMANDS
export alias aes = java ($env.DOTFILES + /tools/ + aes.java)
export alias download = java ($env.DOTFILES + /tools/ + download.java)
export alias download_jar = java ($env.DOTFILES + /tools/ + download_jar.java)
