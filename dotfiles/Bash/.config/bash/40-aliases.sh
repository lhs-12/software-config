#!/usr/bin/env bash
# Command aliases

# Editor aliases
alias vi='nvim --clean'
alias vim='nvim'
alias svi='sudo nvim'
alias code='code --ozone-platform=wayland'

# lsd (ls replacement)
alias ls='lsd'
alias la='lsd -a'
alias ll='lsd --long --header'
alias lla='ll -a'
alias lr='lsd --tree'
alias lf='lsd -l | grep -v "^d"'
alias ldir='lsd -l | grep "^d"'
alias las='lsd -a | grep "^\."'

# Directory navigation aliases
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'
# cd into the old directory
alias bd='cd "$OLDPWD"'

# Grep
alias grep='grep --color=auto'
unset GREP_OPTIONS

# Search command line history
alias h="history | grep "

# Search running processes
alias p="ps aux | grep "
alias topcpu="/bin/ps -eo pcpu,pid,user,args | sort -k 1 -r | head -10"
alias topmem="/bin/ps -eo pmem,pid,user,args | sort -k 1 -r | head -10"

# SHA1
alias sha1='openssl sha1'
