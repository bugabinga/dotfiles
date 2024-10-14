# Installs my most used packages on fedora.
# This mainly means devel packages for rust tools or tools in the repos.
export def main [
	--gui # install gui stuff
] {

	# building c/c++
	sudo dnf groupinstall "Development Tools" "Development Libraries"

	# deps of some rust crates i like to build
	sudo dnf install fontconfig-devel freetype-devel libX11-xcb libX11-devel libstdc++-static libstdc++-devel alsa-lib-devel libspatialaudio-devel pipewire-devel systemd-devel libseat-devel cairo-gobject-devel pango-devel libdisplay-info-devel libinput-devel mesa-libgbm-devel openssl-devel wayland-devel pipewire-devel pango-devel mesa-libgbm-devel libxkbcommon-devel libseat-devel libspatialaudio-devel

	# these seem to be deps of the openssl-sys crates build system
	sudo dnf install perl-File-Compare perl-File-Copy perl-FindBin perl-IPC-Cmd

	# system stuff
	sudo dnf install python3-dnf-plugin-rpmconf dnf-automatic
	sudo systemctl enable --now dnf-automatic-install.timer
	
	# my stuff
	sudo dnf install aerc llvm clang cmake unison rustup neovim mold java-latest-openjdk-devel java-latest-openjdk-src perl-Image-ExifTool

	# gui stuff
	if $gui {
		sudo dnf install gnome-tweaks zathura zathura-pdf-mudpf
	}
}
