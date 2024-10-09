# create file initially, so that we can append to it later
let file = $"($nu.default-config-dir)/aliases.nu"
'' | save -f $file

def aka [
	name: string # name of the new alias
	command: string # program to alias to
	...args: string # optional arguemtns to program
] {

	if not (which $command | is-empty) {
		$"alias ($name) = ($command) ($args | str join ' ')\n" | save -a $file
	}
}

########################################
# Start defining your aliases here

aka cat bat
aka tar bsdtar
aka walk yazi
aka list eza '--long' '--git'
aka tree eza '--tree' '--icons' '--git' '--all' '--long'
aka imgcat wezterm imgcat

aka ll ls '--long'
aka la ls '--long' '--all'

aka browse firefox

aka vim nvim
aka code nvim
aka vide neovide
aka edit nvim '--clean'
aka ed nvim '--clean'
aka vi nvim '--clean'
aka bb bartib

aka userctl systemctl '--user'

# https://gist.github.com/mullnerz/9fff80593d6b442d5c1b
aka archive wget "-mpck" "--html-extension" '--user-agent=""' "-e" "robots=off" "--wait" 1 "-P" .

# CUSTOM LITTLE JAVA COMMANDS
aka aes java ($env.DOTFILES + /tools/ + aes.java)
aka download java ($env.DOTFILES + /tools/ + download.java)
aka download_jar java ($env.DOTFILES + /tools/ + download_jar.java)
