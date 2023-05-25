#!/usr/bin/env nu

def main [] {
	(vivid themes) |
	lines |
	str trim |
	each { |theme| 
		print $"theme: (ansi black_bold)($theme)(ansi reset)"
		with-env { LS_COLORS: (vivid generate $theme) } {
			exa
			print "\n"
		}
	}
}
