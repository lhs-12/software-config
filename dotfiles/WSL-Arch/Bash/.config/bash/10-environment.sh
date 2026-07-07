#!/usr/bin/env bash
# Basic interactive environment settings

# Language
export LANG=en_US.UTF-8
export LANGUAGE=en_US

# VSCode from Windows
append_path "/mnt/c/Users/L/AppData/Local/Programs/Microsoft VS Code/bin"

# Mise (environment manager)
eval "$(mise activate bash)"
