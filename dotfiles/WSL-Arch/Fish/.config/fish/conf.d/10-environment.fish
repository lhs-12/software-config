# Basic environment settings

if not status is-interactive; exit; end # Skip non-interactive shells

# Language
set -gx LANG en_US.UTF-8
set -gx LANGUAGE en_US

# Input method (WSLg: fcitx5)
set -gx XMODIFIERS @im=fcitx

# User local binaries
fish_add_path $HOME/.local/bin

# VSCode from Windows
fish_add_path "/mnt/c/Users/L/AppData/Local/Programs/Microsoft VS Code/bin"

# Mise (environment manager)
mise activate fish | source
