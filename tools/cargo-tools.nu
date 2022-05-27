let cargo_crates = [
  "sccache"  
  "sd"
  "cbs"
  "ouch"
  "fd-find"
  "ripgrep"
  "eva"
  "mdcat"
  "hexyl"
  "hyperfine"
  "so"
  "tealdeer"
  "tokei"
  "bat"
  "pastel"
  "diskonaut"
  "menyoki"
  "grex"
  "xh"
  "comrak"
  "bandwhich"
  "linky"
  "viu"
  "licensor"
  "gib"
  "silicon"
  "bottom"
  "sic"
]

let cargo_git_crates = [
  "https://github.com/mosmeh/indexa"
]

def install-helix-editor [] {
  cd $env.WORKSPACE
  git clone https://github.com/helix-editor/helix
  cd helix
  cargo install --locked --path helix-term
  hx --grammar fetch
  hx --grammar build
}

def main [] {
  $cargo_crates | each { |crate|
    if ( which $crate | empty? ) {
      cargo install --locked $crate
    } else {
      echo $"($crate) already installed"
    }
  }
  
  $cargo_git_crates | each { |crate| 
    cargo install --locked --git $crate
  }
  
  install-helix-editor
}
