set shell := ["nu", "--commands"]

default:
    @just --list

# validate config files
# TODO: shell files
# TODO: nushell files
# TODO: json files

# TODO: markdown files
lint:
    taplo lint
    javac -Werror -Xlint:all bootstripper.java
    rm bootstripper.class
    lychee .

# format config files
# TODO: java files
# TODO: nushell files

# TODO: markdown files
fmt:
    just --fmt --unstable
    taplo fmt

# link dorkfiles into HOME
link:
    java bootstripper.java

# remove links to dorkfiles in HOME
unlink:
		java bootstripper.java clean

# Decrypts all my secrets in tresor, using password manager, if available.
decrypt:
	java bootstripper.java decrypt

# install rust user land
tools:
    cd tools;java install.java

# typically the initial git remote for the dotfiles repo is https
# this command changes the remote to ssh
ssh-remote:
	git remote rm origin
	git remote add origin git@github.com:bugabinga/dotfiles.git
