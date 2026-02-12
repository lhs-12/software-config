#!/usr/bin/env bash
# Basic environment settings

# Language
set -gx LANG en_US.UTF-8
set -gx LANGUAGE en_US.UTF-8

# Editor
set -gx EDITOR nvim
set -gx VISUAL nvim

# XDG folders
set -gx XDG_DATA_HOME "$HOME/.local/share"
set -gx XDG_CONFIG_HOME "$HOME/.config"
set -gx XDG_STATE_HOME "$HOME/.local/state"
set -gx XDG_CACHE_HOME "$HOME/.cache"

# PATH
fish_add_path -g ~/.local/bin
fish_add_path -g ~/.opencode/bin

# Mise (environment manager)
mise activate fish | source

# Proxy configuration
proxycfg on 1>/dev/null 2>&1 # enable proxy by default
