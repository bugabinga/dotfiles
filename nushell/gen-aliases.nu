#!/usr/bin/env nu

let file = $"($nu.default-config-dir)/aliases.nu"

def save-alias [...args: string] {
    $"alias ($args | str join ' ')\n" | save -a $file
}

'' | save -f $file

########################################
# Start defining your aliases here

if not (which bat | is-empty) {
    save-alias cat = bat
}

if not (which bsdtar | is-empty) {
    save-alias tar = bsdtar
}
