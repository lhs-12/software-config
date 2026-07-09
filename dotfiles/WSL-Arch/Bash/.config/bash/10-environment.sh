#!/usr/bin/env bash
# Basic interactive environment settings

# Language
export LANG=en_US.UTF-8 # zh_CN.UTF-8
export LANGUAGE=en_US   # zh_CN:en_US

# Mise activate for interactive shells
eval "$(mise activate bash)"

# VSCode from Windows
append_path "/mnt/c/Users/L/AppData/Local/Programs/Microsoft VS Code/bin"
