#!/usr/bin/env bash
# If not running interactively, don't do anything
[[ $- != *i* ]] && return
# Source global definitions
if [ -f /etc/bashrc ]; then
  . /etc/bashrc
fi
# command prompt format: [user@host dir]$
PS1='[\u@\h \W]\$ '

# Language
export LANG=en_US.UTF-8
export LANGUAGE=en_US

# system update
alias sysup='bash ~/.config/my_scripts/sysup.sh'

# ---------- proxy ----------
proxy_on() {
  local proxy="http://127.0.0.1:10808"
  local noproxy="localhost,127.0.0.1,127.0.0.0/8,::1,10.0.0.0/8,172.16.0.0/12,192.168.0.0/16"
  local PROXY_ENV=(
    http_proxy https_proxy ftp_proxy rsync_proxy all_proxy
    HTTP_PROXY HTTPS_PROXY FTP_PROXY RSYNC_PROXY ALL_PROXY
  )
  for envar in "${PROXY_ENV[@]}"; do
    export "$envar=$proxy"
  done
  export no_proxy="$noproxy"
  export NO_PROXY="$noproxy"
  git config --global http.proxy "$proxy"
  git config --global https.proxy "$proxy"
}

proxy_on # enable proxy by default

proxy_off() {
  unset http_proxy https_proxy ftp_proxy rsync_proxy all_proxy no_proxy \
    HTTP_PROXY HTTPS_PROXY FTP_PROXY RSYNC_PROXY ALL_PROXY NO_PROXY
  git config --global --unset http.proxy
  git config --global --unset https.proxy
}

# Enable bash programmable completion features in interactive shells
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

# Expand the history size
export HISTFILESIZE=5000
export HISTSIZE=500
export HISTTIMEFORMAT="%F %T" # add timestamp
# Don't put duplicate lines in the history and do not add lines that start with a space
export HISTCONTROL=erasedups:ignoredups:ignorespace

# Check the window size after each command and, if necessary, update the values of LINES and COLUMNS
shopt -s checkwinsize
# Causes bash to append to history instead of overwriting it
# so if you start a new terminal, you have old session history
shopt -s histappend
PROMPT_COMMAND='history -a'

# set up XDG folders
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_STATE_HOME="$HOME/.local/state"
export XDG_CACHE_HOME="$HOME/.cache"

# open with default app
start() {
  nohup xdg-open "$@" </dev/null >/dev/null 2>&1 &
  disown $! 2>/dev/null
}

# Set the default editor
export EDITOR=nvim
export VISUAL=nvim
alias vi='nvim --clean'
alias vim='nvim'
alias svi='sudo nvim'
alias code='code --ozone-platform=wayland'

# Change directory aliases
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'
# cd into the old directory
alias bd='cd "$OLDPWD"'
# cd into fzf directory
alias cdg='cd_g() { local d=$(fd -td "${1:-}" "${2:-.}" | fzf); [ -n "$d" ] && cd "$d"; }; cd_g'

# Yazi
alias yz='yazi'
function yy() {
  local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
  yazi "$@" --cwd-file="$tmp"
  IFS= read -r -d '' cwd <"$tmp"
  [ -n "$cwd" ] && [ "$cwd" != "$PWD" ] && builtin cd -- "$cwd"
  rm -f -- "$tmp"
}

# replace grep with ripgrep
# alias grep='grep --color=auto'
alias grep='rg --color=auto'
unset GREP_OPTIONS

# alish rm to trash
alias rm='trash -v'

# list packages
alias yayf="yay -Slq | fzf --multi --preview 'yay -Sii {1}' --preview-window=down:75% | xargs -ro yay -S"

# directory listing aliases
alias ls='lsd'
alias la='lsd -a'
alias ll='lsd --long --header'
alias lla='ll -a'
alias lr='lsd --tree'
alias lf='lsd -l | grep -v "^d"'
alias ldir='lsd -l | grep "^d"'
alias las='lsd -a | grep "^\."'

# bat
alias less='bat'
alias cat='bat -pp'

# Search command line history
alias h="history | grep "

# Search running processes
alias p="ps aux | grep "
alias topcpu="/bin/ps -eo pcpu,pid,user,args | sort -k 1 -r | head -10"

# Show all logs in /var/log
alias logs="sudo find /var/log -type f -exec file {} \; | grep 'text' | cut -d' ' -f1 | sed -e's/:$//g' | grep -v '[0-9]$' | xargs tail -f"

# SHA1
alias sha1='openssl sha1'

# Archives
alias mktar='tar -cvf'
alias mkbz2='tar -cvjf'
alias mkgz='tar -cvzf'
alias untar='tar -xvf'
alias unbz2='tar -xvjf'
alias ungz='tar -xvzf'

extract() {
  for archive in "$@"; do
    if [ -f "$archive" ]; then
      case $archive in
      *.tar.bz2) tar xvjf $archive ;;
      *.tar.gz) tar xvzf $archive ;;
      *.bz2) bunzip2 $archive ;;
      *.rar) rar x $archive ;;
      *.gz) gunzip $archive ;;
      *.tar) tar xvf $archive ;;
      *.tbz2) tar xvjf $archive ;;
      *.tgz) tar xvzf $archive ;;
      *.zip) unzip $archive ;;
      *.Z) uncompress $archive ;;
      *.7z) 7z x $archive ;;
      *) echo "don't know how to extract '$archive'..." ;;
      esac
    else
      echo "'$archive' is not a valid file!"
    fi
  done
}

# Move and go to the directory
mvg() {
  if [ -d "$2" ]; then
    mv "$1" "$2" && cd "$2"
  else
    mv "$1" "$2"
  fi
}

# Create and go to the directory
mkdirg() {
  mkdir -p "$1"
  cd "$1"
}

# Goes up a specified number of directories  (i.e. up 4)
up() {
  local d=""
  limit=$1
  for ((i = 1; i <= limit; i++)); do
    d=$d/..
  done
  d=$(echo $d | sed 's/^\///')
  if [ -z "$d" ]; then
    d=..
  fi
  cd $d
}

# IP address lookup
alias whatismyip="whatsmyip"
function whatsmyip() {
  # Internal IP Lookup.
  if command -v ip &>/dev/null; then
    echo -n "Internal IP: "
    ip addr show wlan0 | grep "inet " | awk '{print $2}' | cut -d/ -f1
  else
    echo -n "Internal IP: "
    ifconfig wlan0 | grep "inet " | awk '{print $2}'
  fi

  # External IP Lookup
  echo -n "External IP: "
  curl -4 ifconfig.me
  echo ""
}

# Config tools
if [[ "$TERM_PROGRAM" != "vscode" ]]; then
  eval "$(oh-my-posh init bash --config ~/.omp.json)"
fi
eval "$(batman --export-env)"
eval "$(zoxide init bash)"
eval "$(mise activate bash)"

export PATH="$HOME/.local/bin:$PATH"
export PATH="$HOME/.opencode/bin:$PATH"
