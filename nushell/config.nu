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
				| load-env'#
		}
	]
}

$env.config = {
	show_banner: false
  table: {
    mode: none
  }
  rm: {
    always_trash: true
  }
  completions: {
    use_ls_colors: true
  }

	# some experimental options
	buffer_editor: ["nvim" "--clean"]
	highlight_resolved_externals : true
  use_kitty_protocol : true
  render_right_prompt_on_last_line: true

  history: {
    file_format: "sqlite"
    isolation: true
  }
	hooks: {
		env_change: {
			PWD: (direnv)
		}
	}
}

