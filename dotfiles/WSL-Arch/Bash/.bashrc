#!/usr/bin/env bash

BASH_CONFIG_DIR="$HOME/.config/bash"

# Non-interactive shell settings
for config in "$BASH_CONFIG_DIR"/0[0-9]-*.sh; do # 00-09
  [[ -r $config ]] && source "$config"
done

# Exit if not an interactive shell
[[ $- != *i* ]] && return

# Interactive shell settings
for config in "$BASH_CONFIG_DIR"/[1-9][0-9]-*.sh; do # 10-99
  [[ -r $config ]] && source "$config"
done
