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
  [ "cargo-cache" "cargo-cache" [] ]
  [ "hexyl" "hexyl" [] ]
  [ "hyperfine" "hyperfine" [] ]
  [ "tealdeer" "tldr" [] ]
  [ "tokei" "tokei" [] ]
  [ "bat" "bat" [] ]
  [ "pastel" "pastel" [] ]
  [ "diskonaut" "diskonaut" [] ]
  [ "menyoki" "menyoki" [] ]
  [ "zoxide" "zoxide" [] ]
  [ "difftastic" "difft" []]
  [ "grex" "grex" [] ]
  [ "xh" "xh" [] ]
  [ "comrak" "comrak" [] ]
  # [ "bandwhich" "bandwhich" [] ] masked until https://github.com/imsnif/bandwhich/issues/233
  [ "lychee" "lychee" [] ]
  [ "viu" "viu" [] ]
  [ "vivid" "vivid" [] ]
  [ "silicon" "silicon" [] ]
  [ "bottom" "btm" [] ]
  # [ "sic" "sic" [] ] some issue with ssl on win32?
  [ "just" "just" [] ]
  [ "mdsh" "mdsh" [] ]
  [ "git-delta" "delta" [] ]
  [ "selene" "selene" [ "--no-default-features" ] ]
  [ "stylua" "stylua" [ "--features" "lua52" ] ]
  [ "taplo-cli" "taplo" [] ]
  [ "lms" "lms" [] ]
]

# install all my favorite crate, only if they are not already in PATH.
def main [] {
	# FIXME: nushell in NixOS cannot detect hostname?
	if (sys).host.name == "NixOS" {
	#if (sys).host.name == "x230" {
		if (which akku | is-empty) {
			echo $'cargo install akku'
			cargo install --git https://github.com/bugabinga/akku
		} else {
			echo $"akku already installed"
		}
	}
  $cargo_crates | each { | crate |
    if ( which $crate.bin | is-empty ) {
      echo $'cargo install ($crate.name) ($crate.features)'
      cargo install $crate.name ...$crate.features
    } else {
      echo $"($crate.name) already installed"
    }
  }
}
