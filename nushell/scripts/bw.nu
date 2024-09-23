# fuzzy filter wrapper over rbw
export def main [] {
# TODO: needs to handle all kinds of weird rbw output
# TODO: how to get the desired field into clipboard?
	^sk --ansi -i -c 'rbw search {}' --preview "rbw get --full {3} {1}@{2}" --delimiter '@' --nth 2
}
