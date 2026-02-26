#!/usr/bin/env bash
# Basic environment settings

# Language
export LANG=en_US.UTF-8 # zh_CN.UTF-8
export LANGUAGE=en_US   # zh_CN:en_US

# PATH
append_path(){ case ":$PATH:" in *:"$1":*) ;; *) PATH="${PATH:+$PATH:}$1" ;; esac; }
append_path "$HOME/.opencode/bin"

# Mise (environment manager)
eval "$(mise activate bash)"