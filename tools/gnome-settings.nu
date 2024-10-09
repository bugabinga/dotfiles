#!/usr/bin/env nu

def main [] {
	const background_settings = [
		['key', 'value'];
		['picture-uri', 'none']
		['color-shading-type', 'solid']
		['primary-color', '#131313']
		['secondary-color', '#131313']
	]

	$background_settings | each { | setting |
		run-external gsettings set 'org.gnome.desktop.background' $setting.key $setting.value
	}

	null
}
