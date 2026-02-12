#!/usr/bin/env bash
# User-defined functions

# Open with default app (Windows Style)
start() {
  LANGUAGE=zh_CN.UTF-8 nohup xdg-open "$@" </dev/null >/dev/null 2>&1 &
  disown $! 2>/dev/null
}

# cd into fzf directory
cdg() {
  local d=$(fd -td "${1:-}" "${2:-.}" | fzf)
  [ -n "$d" ] && cd "$d"
}

# Move and go to directory
mvg() {
  if [ -d "$2" ]; then
    mv "$1" "$2" && cd "$2"
  else
    mv "$1" "$2"
  fi
}

# Create and go to directory
mkdirg() {
  mkdir -p "$1"
  cd "$1"
}

# Go up N directories (i.e. up 4)
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
