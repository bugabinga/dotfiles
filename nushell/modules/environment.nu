export env GO111MODULE { "on" }
export env GOPATH { ($nu.home-path | path join '.go') }

export env PATH {
                    ( $env.PATH |
                      prepend ($env.GOPATH | path join 'bin')
                    )
                }
#TODO CARGO_HOME

# GLOBAL VARIABLES

export env WIN32? { (sys).host.name =~ "Windows" }
export env NURC_DIR  { ($nu.config-path| path expand | path dirname) }
export env DOTFILES  { ($env.NURC_DIR| path join ".." | path expand) }
export env WORKSPACE { if $env.WIN32? { "W:" } else { "~/Workspace" } }
