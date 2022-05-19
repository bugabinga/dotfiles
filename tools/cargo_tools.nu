let cargo_crates = [
  "sd"
  "fd-find"
  "ripgrep"
  "eva"
  "watchexec-cli"
  "mdcat"
  "hexyl"
  "hyperfine"
  "so"
  "tealdeer"
  "tokei"
  "bottom"
  "bat"
  "pastel"
  "diskonaut"
  "menyoki"
  "rpick"
  "grex"
  "xh"
  "comrak"
  "bandwhich"
  "linky"
  "viu"
  "licensor"
  "gib"
  "silicon"
  "onefetch"
]

let cargo_git_crates = [
  "https://github.com/mosmeh/indexa"
]

def install_hx [] {
  cd $env.WORKSPACE
  git clone https://github.com/helix-editor/helix
  cd helix
  cargo install --path helix-term
  hx --grammar fetch
  hx --grammar build
}

def main [] {
  cargo install --locked $cargo_crates
  cargo install --locked nu --all-features
  $cargo_git_crates | each {|it| cargo install --locked --git $it }
  install_hx
}
