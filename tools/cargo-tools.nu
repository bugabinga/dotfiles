# names of binaries in cargo must not necessarily be equal to the crate name.
# this table resolves the binary name of a crate.
# also, a crate can have more than one binary, but for the purpose of checking if a crate is
# already installed on the system, finding one binary is sufficient.
# we also cannot use `cargo install --list` to search for the binary name, in case the crate
# is not installed yet
let cargo_crates = [
  [ name bin features];
  [ "sccache" "sccache" [] ]
  [ "inferno" "inferno-flamegraph" [] ]
  [ "nu" "nu" [ "--features" "extra" ] ]
  [ "sd" "sd" [] ]
  [ "ouch" "ouch" [] ]
  [ "fd-find" "fd" [] ]
  [ "choose", "choose", [] ]
  [ "ripgrep" "rg" [] ]
  [ "onefetch" "onefetch" [] ]
  [ "eva" "eva" [] ]
  [ "mdcat" "mdcat" [] ]
  [ "cargo-update" "cargo-install-update" [] ]
  [ "hexyl" "hexyl" [] ]
  [ "hyperfine" "hyperfine" [] ]
  [ "so" "so" (so-features) ]
  [ "tealdeer" "tldr" [] ]
  [ "tokei" "tokei" [] ]
  [ "bat" "bat" [] ]
  [ "pastel" "pastel" [] ]
  [ "diskonaut" "diskonaut" [] ]
  [ "menyoki" "menyoki" [] ]
  [ "zoxide" "zoxide" [] ]
  [ "grex" "grex" [] ]
  [ "xh" "xh" [] ]
  [ "comrak" "comrak" [] ]
  # [ "bandwhich" "bandwhich" [] ] masked until https://github.com/imsnif/bandwhich/issues/233
  [ "lychee" "lychee" [] ]
  [ "viu" "viu" [] ]
  [ "vivid" "vivid" [] ]
  [ "licensor" "licensor" [] ]
  [ "gib" "gib" [] ]
  [ "silicon" "silicon" [] ]
  [ "bottom" "btm" [] ]
  [ "sic" "sic" [] ]
  [ "just" "just" [] ]
  [ "mdsh" "mdsh" [] ]
  [ "git-delta" "delta" [] ]
  [ "selene" "selene" [ "--no-default-features" ] ]
  [ "stylua" "stylua" [ "--features" "lua52" ] ]
  [ "taplo-cli" "taplo" [] ]
  [ "lms" "lms" [] ]
  [ "coreutils" "coreutils" (coreutils-features) ]
]

def coreutils-features [] {
  if $env.WIN32? {
    [ "--features" "windows" ]
  } else {
    [ "--features" "unix" ]
  }
}

def so-features [] {
  if $env.WIN32? {
    [ "--no-default-features" "--features" "windows" ]
  } else {
    []
  }
}

def install-helix-editor [] {
  cd $env.WORKSPACE
  if ( not ($env.WORKSPACE | path join "helix/.git" | path exists) ) {
    git clone https://github.com/helix-editor/helix
  } 
  cd helix
  git fetch
  # check if fetch actually downloaded anything new
  # if (not ((git rev-parse HEAD) == (git rev-parse @{u}))) {
  # topgrade has already updated the repo by this point, so that we never hit this case.
  # needs alternative idea
    git pull
    let toolchain = (if $nu.os-info.family == "windows" {"+stable-mvsc"} else {"+stable"})
    cargo $toolchain install --path helix-term  --profile opt
    hx --grammar fetch | ignore
    hx --grammar build | ignore
  # }
}

# install all my favorite crate, only if they are not already in PATH.
def main [] {
  $cargo_crates | each { | crate |
    if ( which $crate.bin | is-empty ) {
      echo $'cargo install ($crate.name) ($crate.features)'
      cargo install $crate.name $crate.features
    } else {
      echo $"($crate.name) already installed"
    }
  }
  install-helix-editor
}
