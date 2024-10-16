### bugabingas custom note taking and organizing system
###
### notes are grouped into contexts (folders), so that i can distinguish between
### personal and work related notes.



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
	let note_file = [ $env.NOTES $context $note_file_name] | path join

	if ($note_file | path exists) {
		error make {
			msg: "the note you are trying to create exists already"
		}
	}

	$note_content | save --raw $note_file

	let editor = if ( $env.EDITOR == null ) { 'vi' } else { $env.EDITOR }
	let editor = if ( $env.VISUAL == null ) { $editor } else { $env.VISUAL }
	run-external $editor $note_file
}
