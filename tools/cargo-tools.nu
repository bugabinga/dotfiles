# names of binaries in cargo must not necessarily be equal to the crate name.
# this table resolves the binary name of a crate.
# also, a crate can have more than one binary, but for the purpose of checking if a crate is
# already installed on the system, finding one binary is sufficient.
# we also cannot use `cargo install --list` to search for the binary name, in case the crate
# is not installed yet
let cargo_crates = [
  [ name bin crago_args];
  [ "bat" "bat" [] ]
  [ "bottom" "btm" [] ]
  [ "cargo-cache" "cargo-cache" [] ]
  [ "cargo-update" "cargo-install-update" [] ]
  [ "choose", "choose", [] ]
  [ "eva" "eva" [] ]
  [ "eva" "eva" [] ]
  [ "fd-find" "fd" [] ]
  [ "git-delta" "delta" [] ]
  [ "gitu" "gitu" [ "--locked" ] ]
  [ "hexyl" "hexyl" [] ]
  [ "hyperfine" "hyperfine" [] ]
  [ "just" "just" [] ]
  [ "lms" "lms" [] ]
  [ "lychee" "lychee" [ "--locked" "--no-default-features" "--features" "rustls-tls,email-check"] ]
  [ "mdcat" "mdcat" [] ]
  [ "mdsh" "mdsh" [] ]
  [ "nu" "nu" [ "--features" "extra" ] ]
  [ "ouch" "ouch" [] ]
  [ "pastel" "pastel" [] ]
  [ "ripgrep" "rg" [] ]
  [ "sd" "sd" [] ]
  [ "selene" "selene" [ "--no-default-features" ] ]
  [ "stylua" "stylua" [ "--features" "lua52" ] ]
  [ "taplo-cli" "taplo" [] ]
  [ "tealdeer" "tldr" [] ]
  [ "tokei" "tokei" [] ]
  [ "viu" "viu" [] ]
  [ "vivid" "vivid" [] ]
  [ "yazi-cli" "ya" [ "--locked" ] ]
  [ "yazi-fm" "yazi" [ "--locked" ] ]
  [ "zoxide" "zoxide" [] ]
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
