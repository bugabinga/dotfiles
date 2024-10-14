# Installs my most used packages on fedora.
# This mainly means devel packages for rust tools or tools in the repos.
export def main [
	--gui # install gui stuff
] {

	# building c/c++
	sudo dnf groupinstall "Development Tools" "Development Libraries"

	mut packages = [
		# deps of some rust crates i like to build
		fontconfig-devel
		freetype-devel
		libX11-xcb
		libX11-devel
		libstdc++-static
		libstdc++-devel
		alsa-lib-devel
		libspatialaudio-devel
		pipewire-devel
		systemd-devel
		libseat-devel
		cairo-gobject-devel
		pango-devel
		libdisplay-info-devel
		libinput-devel
		mesa-libgbm-devel
		openssl-devel
		wayland-devel
		pipewire-devel
		pango-devel
		mesa-libgbm-devel
		libxkbcommon-devel
		libseat-devel
		libspatialaudio-devel
		# these seem to be deps of the openssl-sys crates build system
		perl-File-Compare
		perl-File-Copy
		perl-FindBin
		perl-IPC-Cmd
		# java
		java-latest-openjdk
		java-latest-openjdk-src
		java-latest-openjdk-javadoc
		java-latest-openjdk-devel
		# other langs
		llvm
		clang
		cmake rustup
		golang
		mold
		# system stuff
		python3-dnf-plugin-rpmconf
		dnf-automatic
		# my stuff
		aerc
		unison
		neovim
		perl-Image-ExifTool
	]

	# gui stuff
	if $gui {
		let gui_packages = [
			gnome-tweaks
			zathura
			zathura-pdf-mupdf
		]
		$packages = $packages | append $gui_packages

		flatpak install com.bitwarden.desktop com.discordapp.Discord org.telegram.desktop rs.ruffle.Ruffle
	}

	sudo dnf install ...$packages

	sudo systemctl enable --now dnf-automatic-install.timer
}

