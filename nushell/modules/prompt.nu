# Map of paths to icons.
# These will be used to replace certain path segments in the prompt for example.
# Order these paths for precedence.
def icons [] {
    [
        [ path icon ];
        [ "/home/oli/Notes" (char -u "1f4d3") ]
        [ "C:\\Users\\okr\\Notes" (char -u "1f4d3") ]
        [ "/home/oli/Workspace" (char -u "1f4bb") ]
        [ "C:\\Users\\okr\\Workspaces" (char -u "1f4bb") ]
        [ "/home/oli" (char nf_house2) ]
        [ "C:\\Users\\okr" (char nf_house2) ]
    ]
}

# Uses a special escape code to set the window title of the terminal emulator.
# This will be ignored in terminal emulator, that do not support that escape code.
# The title to be set is derived from the current working directory.
# Special types of directories, e.g. HOME, get custom icons.
def set-window-title [] {
    # normalize path
    let pwd = ( $env.PWD | path expand )
    let icon = if (icons | any { |icon| $icon.path == $pwd } ) { ( icons | where path == $pwd | get icon.0 ) } else { $"(char nf_folder1)" }
    # Some terminals freeze, if they do not support this OSC
    if ($env | get -i TERM_PROGRAM) == WezTerm {
      echo ([ (ansi title) $icon " " ( $pwd | path basename ) (ansi reset) ] | str collect)
    }
}

def get_vcs_path [] {
    #normalize path
    let pwd = ($env.PWD | path expand)

    let svn_relative_cmd = ( do --ignore-errors { ^svn info --show-item relative-url --no-newline $pwd | complete } )
    let svn_relative_path = if ($svn_relative_cmd.exit_code == 0) { $" 🐢 (char nf_branch) ($svn_relative_cmd.stdout)" }

    let git_status = ( gstat )
    let git_branch = if ( $git_status.branch != "no_branch" ) { $" (char nf_git) (char nf_branch) ($git_status.branch)" }

    [
      $svn_relative_path
      $git_branch
    ] | str collect
}

def create_left_prompt [] {
    set-window-title

    # normalize path
    let pwd = ($env.PWD | path expand)
    let pwd = (icons | reduce --fold $pwd { |item, accumulator| $accumulator | str replace --string $item.path $item.icon })
    let truncate_level = 5
    let truncate_symbol = $"…(char path_sep)"
    let path_segment = if ($pwd | path split | length) >= $truncate_level { ($pwd | path dirname --num-levels 2 --replace $truncate_symbol ) } else { $pwd }

    let vcs_segment = get_vcs_path

    [
      (ansi dark_gray)
      $path_segment
      (ansi reset)
      (ansi green)
      $vcs_segment
      (ansi reset)
    ] | str collect
}

def create_right_prompt [] {
    let time_segment = ([
        (date now | date format '%d.%m %R')
    ] | str collect)

    let command_status_segment = if $env.LAST_EXIT_CODE == 0 { $" (char -u '2713') " } else { $"(ansi red) (char failed) (ansi reset)" }
    let command_duration_segment = if ( $env.CMD_DURATION_MS | into int) > 0 { $"($env.CMD_DURATION_MS)ms" | into duration }

    [
      (ansi dark_gray_dimmed)
      $command_duration_segment
      (ansi reset)
      (ansi dark_gray)
      $command_status_segment
      (ansi reset)
      (ansi dark_gray)
      $time_segment
      (ansi reset)
    ] | str collect
}

export-env {
  # Use nushell functions to define your right and left prompt
  let-env PROMPT_COMMAND = { create_left_prompt }
  let-env PROMPT_COMMAND_RIGHT = { create_right_prompt }

  # The prompt indicators are environmental variables that represent
  # the state of the prompt
  let-env PROMPT_INDICATOR = $"(ansi purple) (char prompt) (ansi reset)"
  let-env PROMPT_INDICATOR_VI_INSERT = $"(ansi purple) (char pipe) (ansi reset)"
  let-env PROMPT_INDICATOR_VI_NORMAL = $"(ansi purple) (char prompt) (ansi reset)"
  let-env PROMPT_MULTILINE_INDICATOR = $"(ansi purple) (char prompt)(char prompt) (ansi reset)"
}
