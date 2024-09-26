# TODO: use nugu colors
# for more information on themes see
# https://github.com/nushell/nushell/blob/main/docs/How_To_Coloring_and_Theming.md

$env.config = {
	show_banner: false
  table: {
    mode: none
  }
  rm: {
    always_trash: true
  }
  completions: {
    use_ls_colors: true
  }

	# some experimental options
	buffer_editor: ["nvim" "--clean"]
  highlight_resolved_externals : true
  use_kitty_protocol : true
  render_right_prompt_on_last_line: true

  history: {
    file_format: "sqlite"
    isolation: true
  }
}
