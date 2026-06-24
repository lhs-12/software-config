#!/usr/bin/env bash
# Basic environment settings

# Language
export LANG=en_US.UTF-8
export LANGUAGE=en_US

# Input method (WSLg: fcitx5)
export XMODIFIERS=@im=fcitx

# PATH
append_path(){ case ":$PATH:" in *:"$1":*) ;; *) PATH="${PATH:+$PATH:}$1" ;; esac; }

# VSCode from Windows
append_path "/mnt/c/Users/L/AppData/Local/Programs/Microsoft VS Code/bin"

# Mise (environment manager)
eval "$(mise activate bash)"
