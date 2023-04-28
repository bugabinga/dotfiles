#!/usr/bin/env bash

# Stop the service immediately and disables it from starting on boot.
systemctl --user disable --now helix-dark-mode.service
