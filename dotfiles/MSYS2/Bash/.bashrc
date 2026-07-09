# ~/.bashrc: executed by bash(1) for interactive shells.

# append path if exist (add to PATH end, lowest priority)
# echo $PATH | tr ':' '\n'
append_path() {
  local p="$1"
  [ -d "$p" ] || return
  case ":$PATH:" in
    *:"$p":*) ;;
    *) PATH="${PATH:+$PATH:}$p" ;;
  esac
}
append_path "$HOME/.local/bin"

# Mise shims for non-interactive shells (fix MSYS2)
eval "$(mise activate bash --shims | perl -pe 's{([A-Za-z]:[\x5c/][^\x27:\s]*)}{ my $p = qx(cygpath -u "$1"); chomp $p; $p }eg')"

# === local private config (gitignored) ===
[[ -r "$HOME/.bash_local.sh" ]] && source "$HOME/.bash_local.sh"

[[ "$-" != *i* ]] && return

# Language
export LANG=en_US.UTF-8 # zh_CN.UTF-8
export LANGUAGE=en_US   # zh_CN:en_US

# History
export HISTFILE="$HOME/.bash_history"
export HISTFILESIZE=20000
export HISTSIZE=10000
export HISTTIMEFORMAT="%F %T "
export HISTCONTROL=ignoreboth:erasedups
shopt -s checkwinsize
shopt -s histappend
export PROMPT_COMMAND="history -a"
export HISTIGNORE="ls:ll:la:cd:pwd:exit:clear:history"
[ -d "$HOME" ] && touch "$HISTFILE" 2>/dev/null

# UCRT64-specific config only (early exit for other MSYSTEM types)
[[ -z "$MSYSTEM" || "$MSYSTEM" != "UCRT64" ]] && return

# === add PATH ===
append_path "/d/Program Files/tools"
append_path "/c/Program Files/WezTerm"
append_path "$(cygpath -u "$LOCALAPPDATA/Programs/Microsoft VS Code/bin")"

# === Tools ===
# Prompt (Oh My Posh)
if [[ "$TERM_PROGRAM" != "vscode" ]]; then
  eval "$(oh-my-posh init bash --config ~/.om-posh.json)"
fi
# Mise activate for interactive shells (fix MSYS2)
# 嵌套多次启动交互 shell 依然会导致PATH的格式错乱. 但这个场景不常用, 避开即可
mise_activate() {
  local script="$(mise activate bash)"
  local fixed=$(
    printf '%s\n' "$script" |
    sed -e 's|eval "\$(mise hook-env .*)"|&; export PATH="$(/usr/bin/cygpath -u -p \"$PATH\")";|' \
        -e 's|eval "\$(command "\$__MISE_EXE" "\$command" "\$@")"|&; export PATH="$(/usr/bin/cygpath -u -p \"$PATH\")";|'
  )
  eval "$fixed"
}
mise_activate
# Bat (cat/less replacement)
alias less='bat'
alias cat='bat -pp'
# Zoxide (smarter cd)
eval "$(zoxide init bash)"
# Yazi
alias yz='yazi'
function yy() {
  local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
  yazi "$@" --cwd-file="$tmp"
  IFS= read -r -d '' cwd <"$tmp"
  [ -n "$cwd" ] && [ "$cwd" != "$PWD" ] && builtin cd -- "$cwd"
  rm -f -- "$tmp"
}

# === Aliases ===
# Editor aliases
alias vi='nvim --clean'
alias vim='nvim'
# Directory listing (lsd)
alias ls='lsd'
alias la='lsd -a'
alias ll='lsd --long --header'
alias lla='ll -a'
alias lr='lsd --tree'
alias lf='lsd -l | grep -v "^d"'
alias ldir='lsd -l | grep "^d"'
alias las='lsd -a | grep "^\."'
# Grep
alias grep='grep --color=auto'
unset GREP_OPTIONS
# Others
alias h="history | grep "
alias p="ps aux | grep "
alias fdns='ipconfig -flushdns'
alias cdg='cd_g() { local d=$(fd -td "${1:-}" "${2:-.}" | fzf); [ -n "$d" ] && cd "$d"; }; cd_g'
