def "complete svn subcommands" [] {
  ^svn help
  | lines
  | skip until { | line | $line | str starts-with "Available subcommands:" }
  | skip 1
  | each { |line| $line | str trim }
  | take until { |line| $line | empty? }
  | split column " "
  | get column1
}

# TODO: parse xml output

def "complete svn add paths" [] {
  ^svn status --depth files
  | lines
  | parse "{mode} {file}"
  | str trim
  | where mode == ?
  | get file
}

def "complete svn revert paths" [] {
  ^svn status --depth files
  | lines
  | parse "{mode} {file}"
  | where mode == M
  | str trim
  | get file
}

def "complete svn depth" [] { ['empty', 'files', 'immediates', 'infinity'] }

def "complete svn changelists" [] {
  ^svn status --depth files
  | lines
  | parse "--- Changelist '{changelist}':"
  | get --ignore-errors changelist
}

# Subversion is a tool for version control.
# For additional information, see http://subversion.apache.org/
export extern svn [
  subcommand?: string@"complete svn subcommands" # for help on a specific subcommand.
  --version # to see the program version and RA modules
  --quiet # to see just the version number
  --verbose # to see dependency versions as well
]

# help (?, h): Describe the usage of this program or its subcommands.
# usage: help [SUBCOMMAND...]
export extern "svn help" [
  subcommand?: string@"complete svn subcommands" # for help on a specific subcommand.
  --verbose(-v) # also show experimental subcommands and options
]

# FIXME:
# SVN has short options with double dashes: --changelist(--cl).
# This is not allowed in nu.

# FIXME:
# Multiline doccomments will be rendered without the newlines.

# Print the status of working copy files and directories.
export extern "svn status" [
  ...paths: path                        # PATHs
  --show-updates(-u)                    # display update information
  --verbose(-v)                         # print extra information
  --depth: string@"complete svn depth"  # limit operation by depth ARG ('empty', 'files', 'immediates', or 'infinity')
  --revision(-r): string                # ARG (some commands also take ARG1:ARG2 range)
                                        # A revision argument can be one of:
                                        # NUMBER       revision number
                                        # '{' DATE '}' revision at start of the date
                                        # 'HEAD'       latest in repository
                                        # 'BASE'       base rev of item's working copy
                                        # 'COMMITTED'  last commit at or before BASE
                                        # 'PREV'       revision just before COMMITTED
  --quiet(-q)                           # don't print unversioned items
  --no-ignore                           # disregard default and svn:ignore and svn:global-ignores property ignores
  --incremental                         # give output suitable for concatenation
  --xml                                 # output in XML
  --ignore-externals                    # ignore externals definitions
  --changelist:string@"complete svn changelists" # operate only on members of changelist ARG
]

# FIXME: https://github.com/nushell/nushell/issues/5012
# rest parameters do not play well with completions yet
# the `paths` parameter should be `...paths`

# Put new files and directories under version control.
export extern "svn add" [
  paths: path@"complete svn add paths" # unversioned PATHs for addition
  --targets: path          # pass contents of file ARG as additional args
  --non-recursive(-N)      # obsolete; same as --depth=empty
  --depth: string@"complete svn depth" # limit operation by depth ARG ('empty', 'files', 'immediates', or 'infinity')
  --quiet(-q)              # print nothing, or only summary information
  --force                  # ignore already versioned paths
  --no-ignore              # disregard default and svn:ignore and svn:global-ignores property ignores
  --auto-props             # enable automatic properties
  --no-auto-props          # disable automatic properties
  --parents                # add intermediate parents
]

# Restore pristine working copy state (undo local changes).
export extern "svn revert" [
  paths: path@"complete svn revert paths"
  --targets: path             # pass contents of file as additional args
  --recursive(-R)             # descend recursively, same as --depth=infinity
  --depth: string@"complete svn depth" # limit operation by depth ARG ('empty', 'files', 'immediates', or 'infinity')
  --quiet(-q)                 # print nothing, or only summary information
  --changelist: string@"complete svn changelists" # operate only on members of changelist ARG
  --remove-added              # reverting an added item will remove it from disk
]

# FIXME
# SVN uses aliases for subcommands. E.g. `co` for `checkout`.
# How to express that with nu extern commands?

# Check out a working copy from a repository.
export extern "svn checkout" [
  ...url_with_rev:string  # source
  path: path              # destination
  --revision(-r)          # ARG (some commands also take ARG1:ARG2 range)
                          # A revision argument can be one of:
                          #    NUMBER       revision number
                          #    '{' DATE '}' revision at start of the date
                          #    'HEAD'       latest in repository
                          #    'BASE'       base rev of item's working copy
                          #    'COMMITTED'  last commit at or before BASE
                          #    'PREV'       revision just before COMMITTED
  --quiet(-q)             # print nothing, or only summary information
  --depth: string@"complete svn depth"  # limit operation by depth ARG ('empty', 'files', 'immediates', or 'infinity')
  --force                 # force operation to run
  --ignore-externals      # ignore externals definitions
]