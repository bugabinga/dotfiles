# create file initially, so that we can append to it later
let file = $"($nu.default-config-dir)/aliases.nu"
'' | save -f $file

def aka [
	name: string # name of the new alias
	command: string # program to alias to
	...args: string # optional arguemtns to program
] {

	if (which $command | is-not-empty) {
		$"alias ($name) = ($command) ($args | str join ' ')\n" | save --append $file
	}
}

########################################
# Start defining your aliases here

# semantic aliases
aka tree eza '--tree' '--icons' '--git' '--all' '--long'
aka view wezterm imgcat
aka list eza '--long' '--git'
aka show bat
aka web firefox
aka code neovide
aka edit nvim '--clean'
aka archive wget "-mpck" "--html-extension" '--user-agent=""' "-e" "robots=off" "--wait" 1 "-P" .

# pro aliases
aka ll ls '--long'
aka la ls '--long' '--all'
aka q exit
aka g git
aka gu gitu
aka vim nvim
aka vi nvim '--clean'
aka vide neovide
aka bb bartib
aka cal carl

aka userctl systemctl '--user'

# CUSTOM LITTLE JAVA COMMANDS
aka aes java ($env.DOTFILES + /tools/ + aes.java)
aka download java ($env.DOTFILES + /tools/ + download.java)
aka download_jar java ($env.DOTFILES + /tools/ + download_jar.java)
