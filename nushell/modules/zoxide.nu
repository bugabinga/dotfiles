# Code generated by zoxide. DO NOT EDIT.

# =============================================================================
#
# Hook configuration for zoxide.
#

# Initialize hook to add new entries to the database.
export-env {
  let-env config = ($env | default {} config).config
  let-env config = ($env.config | default {} hooks)
  let-env config = ($env.config | update hooks ($env.config.hooks | default [] pre_prompt))
  let-env config = ($env.config | update hooks.pre_prompt ($env.config.hooks.pre_prompt | append {
    zoxide add -- $env.PWD
  }))
}

# =============================================================================
#
# When using zoxide with --no-cmd, alias these internal functions as desired.
#

# Jump to a directory using only keywords.
export def-env __zoxide_z [...rest:string] {
  # `z -` does not work yet, see https://github.com/nushell/nushell/issues/4769
  let arg0 = ($rest | append '~').0
  let path = if (($rest | length) <= 1) && ($arg0 == '-' || ($arg0 | path expand | path type) == dir) {
    $arg0
  } else {
    (zoxide query --exclude $env.PWD -- $rest | str trim -r -c "\n")
  }
  cd $path
}

# Jump to a directory using interactive search.
export def-env __zoxide_zi  [...rest:string] {
  cd $'(zoxide query -i -- $rest | str trim -r -c "\n")'
}

# =============================================================================
#
# Commands for zoxide. Disable these using --no-cmd.
#

export alias z = __zoxide_z
export alias zi = __zoxide_zi

# =============================================================================
#
# Add this to your env file (find it by running `$nu.env-path` in Nushell):
#
#   zoxide init nushell --hook prompt | save ~/.zoxide.nu
#
# Now, add this to the end of your config file (find it by running
# `$nu.config-path` in Nushell):
#
#   source ~/.zoxide.nu
#
# Note: zoxide only supports Nushell v0.63.0 and above.
