# names of binaries in cargo must not necessarily be equal to the crate name.
# this table resolves the binary name of a crate.
# also, a crate can have more than one binary, but for the purpose of checking if a crate is
# already installed on the system, finding one binary is sufficient.
# we also cannot use `cargo install --list` to search for the binary name, in case the crate 
# is not installed yet
let cargo_crates = [
  [name bin features];
  ["sccache" "sccache" []]
  ["nu" "nu" ["--features=extra"]]
  ["sd" "sd" []]
  ["cbs" "cbs" []]
  ["ouch" "ouch" []]
  ["fd-find" "fd" []]
  ["choose", "choose", []]
  ["ripgrep" "rg" []]
  ["onefetch" "onefetch" []]
  ["eva" "eva" []]
  ["mdcat" "mdcat" []]
  ["cargo-update" "cargo-install-update" []]
  ["hexyl" "hexyl" []]
  ["hyperfine" "hyperfine" []]
  ["so" "so" so-features]
  ["tealdeer" "tldr" []]
  ["tokei" "tokei" []]
  ["bat" "bat" []]
  ["pastel" "pastel" []]
  ["diskonaut" "diskonaut" []]
  ["menyoki" "menyoki" []]
  ["zoxide" "zoxide" []]
  ["grex" "grex" []]
  ["xh" "xh" []]
  ["comrak" "comrak" []]
  # ["bandwhich" "bandwhich" []] masked until https://github.com/imsnif/bandwhich/issues/233
  ["linky" "linky" []]
  ["viu" "viu" []]
  ["licensor" "licensor" []]
  ["gib" "gib" []]
  ["silicon" "silicon" []]
  ["bottom" "btm" []]
  ["sic" "sic" []]
  ["just" "just" []]
  ["mdsh" "mdsh" []]
  ["selene" "selene" ["--no-default-features"]]
  ["stylua" "stylua" ["--features=lua52"]]
]

def so-features [] {
  if $env.WIN32? {
    ["--no-default-features" "--features=windows"]
  } else {
    []
  }
}

let cargo_git_crates = [
  "https://github.com/mosmeh/indexa"
]

def install-helix-editor [] {
  cd $env.WORKSPACE
  if ( $env.WORKSPACE | path join "helix/.git" | path exists ) {
    git -C helix pull
  } else {
    git clone https://github.com/helix-editor/helix
  }
  cd helix
  cargo install --locked --path helix-term
  hx --grammar fetch | ignore
  hx --grammar build | ignore
}

# install all my favorite crate, only if they are not already in PATH.
def main [] {
  $cargo_crates | each { | crate |
    if ( which $crate.bin | empty? ) {
      echo $'cargo install --locked ($crate.name) ($crate.features)'
      cargo install --locked $crate.name $crate.features
    } else {
      echo $"($crate.name) already installed"
    }
  }
  # crates, that are not even on crates.io are not likely to be packeged anywhere else.
  # so we skip the check if the binary is already in path
  $cargo_git_crates | each { |crate| 
    cargo install --locked --git $crate
  }
  install-helix-editor
}
