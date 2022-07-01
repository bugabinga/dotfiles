set shell := ["nu", "--commands"]

default:
    @just --list

# validate config files
# TODO: shell files
# TODO: nushell files
# TODO: json files

# TODO: markdown files
lint:
    selene .
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
    stylua --verify .
    taplo fmt

# link dorkfiles into HOME
link:
    java bootstripper.java
