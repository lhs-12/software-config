# ~/.bashrc: executed by bash(1) for interactive shells.

[[ "$-" != *i* ]] && return

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

# UCRT64 Config
if [ -n "$MSYSTEM" ] && [ "$MSYSTEM" = "UCRT64" ]; then
  # add PATH
  # echo $PATH | tr ':' '\n'
  # append path if exist
  append_path() {
    local p="$1"
    [ -d "$p" ] || return
    case ":$PATH:" in
      *:"$p":*) ;; 
      *) PATH="${PATH:+$PATH:}$p" ;;
    esac
  }
  append_path "/d/Program Files/tools"
  append_path "/c/Program Files/Docker/Docker/resources/bin"
  append_path "$(cygpath -u "$LOCALAPPDATA/Programs/Microsoft VS Code/bin")"
  append_path "$(cygpath -u "$(uv tool dir --bin)")"
  append_path "$HOME/.local/share/fnm"
  # Tools
  if [[ "$TERM_PROGRAM" != "vscode" ]]; then
    eval "$(oh-my-posh init bash --config ~/.omp.json)"
  fi
  eval "$(fnm env)"
  eval "$(zoxide init bash)"
  # Aliases
  alias ls='lsd'
  alias la='lsd -a'
  alias ll='lsd --long --header'
  alias lla='ll -a'
  alias lr='lsd --tree'
  alias lf='lsd -l | grep -v "^d"'
  alias ldir='lsd -l | grep "^d"'
  alias las='lsd -a | grep "^\."'
  alias less='bat'
  alias cat='bat -pp'
  alias vi='nvim --clean'
  alias vim='nvim'
  alias cdg='cd_g() { local d=$(fd -td "${1:-}" "${2:-.}" | fzf); [ -n "$d" ] && cd "$d"; }; cd_g'
  alias fdns='ipconfig -flushdns'
  alias sva='source .venv/Scripts/activate'
  alias yz='yazi'
  function yy() {
    local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
    yazi "$@" --cwd-file="$tmp"
    IFS= read -r -d '' cwd <"$tmp"
    [ -n "$cwd" ] && [ "$cwd" != "$PWD" ] && builtin cd -- "$cwd"
    rm -f -- "$tmp"
  }
fi
