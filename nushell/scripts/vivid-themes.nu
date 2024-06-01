export def --env main [] {
	(vivid themes) |
	lines |
	str trim |
	each { |theme|
		print $"theme: (ansi black_bold)($theme)(ansi reset)"
		with-env { LS_COLORS: (vivid generate $theme) } {
			ls $env.HOME
			print "\n"
			print "\n"
		}
	}
}
