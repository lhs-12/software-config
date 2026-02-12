#!/usr/bin/env bash
# Basic environment settings

# Language
export LANG=en_US.UTF-8
export LANGUAGE=en_US.UTF-8

# Default editor
export EDITOR=nvim
export VISUAL=nvim

# XDG directories
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_STATE_HOME="$HOME/.local/state"
export XDG_CACHE_HOME="$HOME/.cache"

# PATH
append_path(){ case ":$PATH:" in *:"$1":*) ;; *) PATH="${PATH:+$PATH:}$1" ;; esac; }
append_path "$HOME/.local/bin"
append_path "$HOME/.opencode/bin"

# Mise (environment manager)
eval "$(mise activate bash)"
