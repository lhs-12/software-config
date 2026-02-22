# Basic environment settings

if not status is-interactive; exit; end # Skip non-interactive shells

# Language
set -gx LANG en_US.UTF-8 # zh_CN.UTF-8
set -gx LANGUAGE en_US   # zh_CN:en_US

# PATH
fish_add_path -g ~/.opencode/bin

# Mise (environment manager)
mise activate fish | source
