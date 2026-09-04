#!/usr/bin/env bash
# Basic interactive shell settings

# Source global definitions
if [ -f /etc/bashrc ]; then
  . /etc/bashrc
fi

# Basic prompt format: [user@host dir]$
# may be overridden by other prompt settings
PS1='[\u@\h \W]\$ '

# Bash completion
if [ -f /usr/share/bash-completion/bash_completion ]; then
  . /usr/share/bash-completion/bash_completion
elif [ -f /etc/bash_completion ]; then
  . /etc/bash_completion
fi

# Ignore case on auto-completion
# Note: bind used instead of sticking these in .inputrc
bind "set completion-ignore-case on"
# Show auto-completion list automatically, without double tab
bind "set show-all-if-ambiguous On"

# History settings
export HISTFILE="$HOME/.bash_history"
export HISTFILESIZE=4000
export HISTSIZE=2000
export HISTTIMEFORMAT="%F %T " # add timestamp
# Don't put duplicate lines in the history and do not add lines that start with a space
export HISTCONTROL=ignoreboth:erasedups

# Shell options
# Check the window size after each command and, if necessary, update the values of LINES and COLUMNS
shopt -s checkwinsize
# Causes bash to append to history instead of overwriting it
# so if you start a new terminal, you have old session history
shopt -s histappend
export PROMPT_COMMAND="history -a" # history -a; history -c; history -r
export HISTIGNORE="ls:ll:la:cd:pwd:exit:clear:history"