set shell := ["nu", "--commands"]

default:
    @just --list

# validate config files
lint:
    # Lua files
    selene .
    # toml files
    taplo lint
    # shell files
    # nushell files
    # java files
    javac -Werror -Xlint:all bootstripper.java
    rm bootstripper.class
    # json files
    # markdown files
    # links
    lychee .

# format config files
fmt:
    # Justfiles
    just --fmt --unstable
    # lua
    stylua --verify .
    # shell files
    # toml files
    taplo fmt
    # java files ?
    # nushell files ?
    # markdown files

# link dorkfiles into HOME
link:
    java bootstripper.java
