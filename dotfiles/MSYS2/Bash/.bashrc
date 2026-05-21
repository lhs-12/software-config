# ~/.bashrc: executed by bash(1) for interactive shells.

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

# UCRT64 Config
if [ -n "$MSYSTEM" ] && [ "$MSYSTEM" = "UCRT64" ]; then
  # === add PATH ===
  # echo $PATH | tr ':' '\n'
  # append path if exist (add to PATH end, lowest priority)
  append_path() {
    local p="$1"
    [ -d "$p" ] || return
    case ":$PATH:" in
      *:"$p":*) ;; 
      *) PATH="${PATH:+$PATH:}$p" ;;
    esac
  }
  append_path "/d/Program Files/tools"
  append_path "/c/Program Files/WezTerm"
  append_path "/c/Program Files/Docker/Docker/resources/bin"
  append_path "$(cygpath -u "$LOCALAPPDATA/Programs/Microsoft VS Code/bin")"
  [ -n "$JAVA_HOME" ] && append_path "$(cygpath -u "$JAVA_HOME/bin")"
  append_path "$HOME/.local/bin"

  # === Tools ===
  # Prompt (Oh My Posh)
  if [[ "$TERM_PROGRAM" != "vscode" ]]; then
    eval "$(oh-my-posh init bash --config ~/.omp.json)"
  fi
  # Mise (Mise 输出路径没适配 MSYS2, 是 Win 风格, 修复 PATH 变量为 Unix 风格)
  mise_activate_script="$(mise activate bash)"
  fixed_mise_script=$(
      printf '%s\n' "$mise_activate_script" |
      sed 's|eval "\$(mise hook-env .*)"|&; export PATH="$(/usr/bin/cygpath -u -p \"$PATH\")";|'
  )
  eval "$fixed_mise_script"
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
fi
