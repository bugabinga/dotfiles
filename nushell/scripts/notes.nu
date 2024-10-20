### bugabingas custom note taking and organizing system
###
### notes are grouped into contexts (folders), so that i can distinguish between
### personal and work related notes.

#TODO: subbcommands:
# - search
# - graph

def validate_context [
	context: string
] {
	if not ($env.NOTES | path exists) {
		error make {
			msg: "No notes folder found in environment variables.
			Make sure a NOTES variable exists in $env."
		}
	}
	if not ($env.NOTES | path join $context | path exists) {
error make {
			msg: $"The given context ($context) does not exist in ($env.NOTES).
			Create it and try again."
		}
	}
}

 export def main [
	--context: string = "bugabinga" # which context do the notes belong to
] {
	# TODO: the context needs to get overridden by env var, so that switch between work and personal is easy

	validate_context $context
	
	ls --short-names ($env.NOTES | path join $context)
	# TODO: print some high level view of the notes. tree, graph, text ?
}

def new_note_id [] { random binary 3 | encode base64 --nopad --url }

def new_note [
	title: string # title of note. will be used for title and initial heading
	author: string # author, usually me...
	date: string # creation date of note
	tags: list<string> # a list of tags, if already known
	context: string # note context
] {
	$"---
title: ($title)
author: ($author)
date: ($date)
tags:
- ($context)
($tags | each { '- ' + $in } | str join (char  nl))
---
	
"
}

def edit [ ...rest ] {
	mut editor = if ( $env.EDITOR == null ) { 'vi' } else { $env.EDITOR }
	$editor = if ( $env.VISUAL == null ) { $editor } else { $env.VISUAL }
	run-external $editor ...$rest
}

def notes_directory [ 
	context: string # which context do the notes belong to
] {
	$env.NOTES | path join $context
}

export def new [
	title?: string # title of new node
	--tags: list<string> # some optional tags for the note
	--context: string = "bugabinga" # which context do the notes belong to
] {
	validate_context $context

	let title = if ($title | is-empty) { input "gimme title: " } else { $title }
	let author = 'Oliver Jan Krylow'
	let now = date now | date to-record
	let date = $"($now.day)/($now.month)/($now.year)" # german dates. what can i say...
	let tags = if ($tags  == null) { [] } else { $tags }

	let note_content = new_note $title $author $date $tags $context
	let note_file_name = $"(new_note_id)-($title | str kebab-case).md"
	let note_file = [ (notes_directory $context) $note_file_name] | path join

	if ($note_file | path exists) {
		error make {
			msg: "the note you are trying to create exists already"
		}
	}
	$note_content | save --raw $note_file
	edit $note_file
}

export def open [
	query: string = "" # intial search term
	--context: string = "bugabinga" # which context do the notes belong to
] {
	let note = ls --short-names --threads ( notes_directory $context) |
	sort-by --reverse modified |
	get name |
	to text |
	^sk --query $query --bind $"f1:execute\(inlyne (notes_directory $context)/{}\)" --preview $"mdcat (notes_directory $context)/{}" --header "F1: GUI Preview"

	edit ( notes_directory $context | path join $note)
}
