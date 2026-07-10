# Basic environment settings

# === Non-interactive shell config ===

# User local binaries
fish_add_path -g $HOME/.local/bin

# Mise shims for non-interactive shells
mise activate fish --shims | source

if not status is-interactive; exit; end

# === Interactive shell config ===

# Language
set -gx LANG en_US.UTF-8 # zh_CN.UTF-8
set -gx LANGUAGE en_US   # zh_CN:en_US

# Mise activate for interactive shells
mise activate fish | source

# VSCode from Windows
fish_add_path -g "/mnt/c/Users/L/AppData/Local/Programs/Microsoft VS Code/bin"
