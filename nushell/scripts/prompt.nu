# Map of paths to icons.
# These will be used to replace certain path segments in the prompt for example.
# Order these paths for precedence.
def icons [] {
    [
        [ path icon ];

        [ "/home/oli/Notes" (char -u "03C0") ]
        [ "/home/okr/Notes" (char -u "03C0") ]
        [ "/home/bugabinga/Notes" (char -u "03C0") ]
        [ "C:\\Users\\okr\\Notizen" (char -u "03C0") ]

        [ "/home/oli/Workspace" (char -u "03BB") ]
        [ "/home/okr/Workspace" (char -u "03BB") ]
        [ "/home/bugabinga/Workspace" (char -u "03BB") ]
        [ "C:\\Users\\okr\\Workspaces" (char -u "03BB") ]

        [ "/home/oli" (char home) ]
        [ "/home/okr" (char home) ]
        [ "/home/bugabinga" (char home) ]
        [ "C:\\Users\\okr" (char home) ]
    ]
}

def prompt-git-branch [] {
}

def get_vcs_path [] {
    #normalize path
    let pwd = ($env.PWD | path expand)

    let svn_relative_cmd = ( do --ignore-errors { ^svn info --show-item relative-url --no-newline $pwd | complete } )
    let svn_relative_path = if ( (not ($svn_relative_cmd | is-empty)) and ($svn_relative_cmd.exit_code == 0)) { $" 🐢 (char nf_branch) ($svn_relative_cmd.stdout)" }

    let git_branch_cmd = ( do -i { ^git rev-parse --abbrev-ref HEAD | complete } )
    let git_path = if (not ($git_branch_cmd | is-empty) and ($git_branch_cmd.exit_code == 0)) { $" (char nf_git) (char nf_branch) ($git_branch_cmd.stdout | str trim -r)" }

    [
      $svn_relative_path
      $git_path
    ] | str join
}

def create_left_prompt [] {
    # normalize path
    let pwd = ($env.PWD | path expand)
    let pwd = ( (icons) | reduce --fold $pwd { |item, accumulator| $accumulator | str replace $item.path $item.icon })
    let truncate_level = 5
    let truncate_symbol = $"…(char path_sep)"
    let path_segment = if ($pwd | path split | length) >= $truncate_level { ($pwd | path dirname --num-levels 2 --replace $truncate_symbol ) } else { $pwd }

    let vcs_segment = (get_vcs_path)

    [
      (ansi dark_gray)
      $path_segment
      (ansi reset)
      (ansi green)
      $vcs_segment
      (ansi reset)
    ] | str join
}

def create_right_prompt [] {
    let command_status_segment = if $env.LAST_EXIT_CODE == 0 { $" (char -u '2713') " } else { $"(ansi red) (char failed) (ansi reset)" }

    [
      (ansi dark_gray_dimmed)
      $command_status_segment
      (ansi reset)
    ] | str join
}

export-env {
  # Use nushell functions to define your right and left prompt
  $env.PROMPT_COMMAND = { || create_left_prompt }
  $env.PROMPT_COMMAND_RIGHT = { || create_right_prompt }

  # The prompt indicators are environmental variables that represent
  # the state of the prompt
  $env.PROMPT_INDICATOR = $"(ansi green) ⚈  (ansi reset)"
  $env.PROMPT_INDICATOR_VI_INSERT = $"(ansi magenta) (char pipe) (ansi reset)"
  $env.PROMPT_INDICATOR_VI_NORMAL = $"(ansi magenta) (char prompt) (ansi reset)"
  $env.PROMPT_MULTILINE_INDICATOR = $"(ansi magenta) (char prompt)(char prompt) (ansi reset)"
}

