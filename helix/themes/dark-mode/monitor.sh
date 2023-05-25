#!/usr/bin/env bash

gsettings monitor org.gnome.desktop.interface color-scheme \
  | xargs -L1 bash -c "source ${HOME}/.config/helix/themes/dark-mode/update.sh"
