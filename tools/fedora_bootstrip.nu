#!/usr/bin/env nu

sudo dnf install fontconfig-devel freetype-devel libX11-xcb libX11-devel libstdc++-static libstdc++-devel
sudo dnf groupinstall "Development Tools" "Development Libraries"
sudo dnf install alsa-lib-devel libspatialaudio-devel pipewire-devel systemd-devel libseat-devel cairo-gobject-devel pango-devel libdisplay-info-devel libinput-devel mesa-libgbm-devel

