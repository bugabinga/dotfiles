# names of binaries in cargo must not necessarily be equal to the crate name.
# this table resolves the binary name of a crate.
# also, a crate can have more than one binary, but for the purpose of checking if a crate is
# already installed on the system, finding one binary is sufficient.
# we also cannot use `cargo install --list` to search for the binary name, in case the crate
# is not installed yet
let cargo_crates = [
  [ name bin crago_args];
  [ "inferno" "inferno-flamegraph" [] ]
  [ "nu" "nu" [ "--features" "extra" ] ]
  [ "sd" "sd" [] ]
  [ "ouch" "ouch" [] ]
  [ "fd-find" "fd" [] ]
  [ "choose", "choose", [] ]
  [ "ripgrep" "rg" [] ]
  [ "eva" "eva" [] ]
  [ "mdcat" "mdcat" [] ]
  [ "cargo-update" "cargo-install-update" [] ]
  [ "cargo-cache" "cargo-cache" [] ]
  [ "hexyl" "hexyl" [] ]
  [ "hyperfine" "hyperfine" [] ]
  [ "tealdeer" "tldr" [] ]
  [ "tokei" "tokei" [] ]
  [ "bat" "bat" [] ]
  [ "pastel" "pastel" [] ]
  [ "zoxide" "zoxide" [] ]
  [ "lychee" "lychee" [] ]
  [ "viu" "viu" [] ]
  [ "vivid" "vivid" [] ]
  [ "bottom" "btm" [] ]
  [ "just" "just" [] ]
  [ "mdsh" "mdsh" [] ]
  [ "git-delta" "delta" [] ]
  [ "selene" "selene" [ "--no-default-features" ] ]
  [ "stylua" "stylua" [ "--features" "lua52" ] ]
  [ "taplo-cli" "taplo" [] ]
  [ "lms" "lms" [] ]
  [ "gitu" "gitu" [ "--locked" ] ]
]

# install all my favorite crate, only if they are not already in PATH.
def main [] {
  $cargo_crates | each { | crate |
    if ( which $crate.bin | is-empty ) {
      echo $'cargo install ($crate.name) ($crate.crago_args)'
      cargo install $crate.name ...$crate.crago_args
    } else {
      echo $"($crate.name) already installed"
    }
  }
}
