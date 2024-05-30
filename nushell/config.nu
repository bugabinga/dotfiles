# Nushell Config File
use modules/table.nu *
use modules/os.nu *
use modules/prompt.nu *
use modules/aliases.nu *
use modules/todo.nu
use modules/openssl.nu *
use modules/md.nu

# TODO: use nugu colors
# for more information on themes see
# https://github.com/nushell/nushell/blob/main/docs/How_To_Coloring_and_Theming.md
let default_theme = {
    # color for nushell primitives
    separator: white
    leading_trailing_space_bg: { attr: n } # no fg, no bg, attr non effectively turns this off
    header: green_bold
    empty: blue
    bool: white
    int: white
    filesize: white
    duration: white
    date: white
    range: white
    float: white
    string: white
    nothing: white
    binary: white
    cellpath: white
    row_index: green_bold
    record: white
    list: white
    block: white
    hints: dark_gray

    # shapes are used to change the cli syntax highlighting
    shape_garbage: { fg: "#FFFFFF" bg: "#FF0000" attr: b}
    shape_binary: purple_bold
    shape_bool: light_cyan
    shape_int: purple_bold
    shape_float: purple_bold
    shape_range: yellow_bold
    shape_internalcall: cyan_bold
    shape_external: cyan
    shape_externalarg: green_bold
    shape_literal: blue
    shape_operator: yellow
    shape_signature: green_bold
    shape_string: green
    shape_string_interpolation: cyan_bold
    shape_datetime: cyan_bold
    shape_list: cyan_bold
    shape_table: blue_bold
    shape_record: cyan_bold
    shape_block: blue_bold
    shape_filepath: cyan
    shape_globpattern: cyan_bold
    shape_variable: purple
    shape_flag: blue_bold
    shape_custom: green
    shape_nothing: light_cyan
}

# The default config record. This is where much of your global configuration is setup.
$env.config = {
	show_banner: false
  table: {
    mode: light # basic, compact, compact_double, light, thin, with_love, rounded, reinforced, heavy, none, other
  }
  ls: {
    use_ls_colors: true
    clickable_links: true
  }
  rm: {
    always_trash: true
  }
  color_config: $default_theme
  use_grid_icons: true
  footer_mode: "auto" # always, never, number_of_rows, auto
  completions: {
    quick: true # set this to false to prevent auto-selecting completions when only one remains
    partial: true # set this to false to prevent partial filling of the prompt
  }
  float_precision: 2
  use_ansi_coloring: true
  filesize: {
    metric: false
    format: "auto" # b, kb, kib, mb, mib, gb, gib, tb, tib, pb, pib, eb, eib, zb, zib, auto
  }
  edit_mode: emacs # emacs, vi
  history: {
    file_format: "plaintext"
    max_size: 10000
    sync_on_enter: true # Enable to share the history between multiple sessions, else you have to close the session to persist history to file
  }
}

# must be done, after defining config, since zoxide mutates it
# this will fail if zoxide is not installed yet
source ($nu.config-path | path dirname | path join "zoxide.nu")
