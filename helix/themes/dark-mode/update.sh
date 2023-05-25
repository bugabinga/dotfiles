#!/usr/bin/env bash

# Fail early, fail often.
set -eu -o pipefail

if [[ "$1" == "default" ]]; then
  # Update Helix Editor config to use light theme.
  sed -i 's/theme = ".*"/theme = "nugu-light"/' ${HOME}/.config/helix/config.toml
else
  # Update Helix Editor config to use dark theme.
  sed -i 's/theme = ".*"/theme = "nugu-dark"/' ${HOME}/.config/helix/config.toml
fi

# reload configuration of running helix instances
pkill -USR1 hx
