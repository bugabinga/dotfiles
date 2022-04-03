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
]

let cargo_git_crates = [
  "https://github.com/mosmeh/indexa"
]

echo "CARGO CRATES"
echo $cargo_crates
echo "CARGO GIT CRATES"
echo $cargo_git_crates
echo "CUSTOM INSTALLS"
echo "hx"

def install_hx [] {
  cd ~/Workspace #TODO make WORKSPACE env var
  git clone https://github.com/helix-editor/helix
  cd helix
  cargo install --path helix-term
  ln -s ~/Workspace/helix/runtime ~/.config/helix/runtime
  hx --grammar fetch
  hx --grammar build
}

cargo install $cargo_crates

$cargo_git_crates | each {|it| cargo install --git $it }

install_hx
