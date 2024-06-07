export def list [] { ls --all --long --du --mime-type | where type == dir | append (ls --all --long --du --mime-type | where type != dir) }

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
