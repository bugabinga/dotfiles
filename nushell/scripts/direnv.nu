def expand-home [] {
	let p = $in
	if ( $p =~ '~') {
		return ($p | path expand)
	}
	return $p
}

def direnv [] {
	[
		{
			condition: {|before, after| ($before != $after) and ($after | path join '.env' | path exists) }
			code: r#'
				open .env
				| lines
				| parse --regex '\s*(?P<key>.+?)\s*=\s*?(?P<value>.+)?\s*'
				| reduce --fold {} { | entry, acc|
					$acc | upsert $entry.key ( $entry.value | str trim | expand-home )
				}
				| load-env
				'#
		}
	]
}

export-env {
	$env.config = ( $env.config | upsert hooks { |config|
		let o = ($config | get -i hooks.env_change.PWD)
		let val = (direnv)
		let appended = if $o == null {
			$val
		} else {
			$o | append $val
		}
		env_change: {
			PWD: $appended
		}
	})
}
