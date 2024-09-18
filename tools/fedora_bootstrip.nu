#!/usr/bin/env nu

sudo dnf install fontconfig-devel freetype-devel libX11-xcb libX11-devel libstdc++-static libstdc++-devel
sudo dnf groupinstall "Development Tools" "Development Libraries"

