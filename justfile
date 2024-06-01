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

tools:
		cd tools;java install.java
