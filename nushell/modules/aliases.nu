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
