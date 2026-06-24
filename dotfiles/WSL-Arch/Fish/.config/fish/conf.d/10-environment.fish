# Basic environment settings

if not status is-interactive; exit; end # Skip non-interactive shells

# Language
set -gx LANG en_US.UTF-8
set -gx LANGUAGE en_US

# Input method (WSLg: fcitx5)
set -gx XMODIFIERS @im=fcitx

# Mise (environment manager)
mise activate fish | source
