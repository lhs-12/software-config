#!/usr/bin/env bash
# External tools initialization

# Oh-my-posh prompt (skip in VSCode)
if [[ "$TERM_PROGRAM" != "vscode" ]]; then
  eval "$(oh-my-posh init bash --config ~/.omp.json)"
fi

# Bat (cat/less replacement)
alias less='bat'
alias cat='bat -pp'
# Batman (man pages with bat)
eval "$(batman --export-env)"

# Zoxide (smarter cd)
eval "$(zoxide init bash)"

# Trash
alias rm='trash -v'

# Yazi
alias yz='yazi'
function yy() {
  local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
  yazi "$@" --cwd-file="$tmp"
  IFS= read -r -d '' cwd <"$tmp"
  [ -n "$cwd" ] && [ "$cwd" != "$PWD" ] && builtin cd -- "$cwd"
  rm -f -- "$tmp"
}
