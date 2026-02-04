#!/usr/bin/env bash
# Proxy Configuration

proxycfg() {
  local proxy_url="http://127.0.0.1:10808"
  local noproxy="localhost,127.0.0.1,127.0.0.0/8,::1,10.0.0.0/8,172.16.0.0/12,192.168.0.0/16"
  local PROXY_ENV=(
    http_proxy https_proxy ftp_proxy rsync_proxy all_proxy
    HTTP_PROXY HTTPS_PROXY FTP_PROXY RSYNC_PROXY ALL_PROXY
  )
  case "$1" in
    on)
      for envar in "${PROXY_ENV[@]}"; do
        export "$envar=$proxy_url"
      done
      export no_proxy="$noproxy"
      export NO_PROXY="$noproxy"
      git config --global http.proxy "$proxy_url"
      git config --global https.proxy "$proxy_url"
      echo "Proxy enabled: $proxy_url"
      ;;
    off)
      for envar in "${PROXY_ENV[@]}"; do
        unset "$envar"
      done
      unset no_proxy NO_PROXY
      git config --global --unset http.proxy
      git config --global --unset https.proxy
      echo "Proxy disabled"
      ;;
    status)
      local git_http="$(git config --global --get http.proxy)"
      local git_https="$(git config --global --get https.proxy)"
      echo "=== Proxy Status ==="
      for envar in "${PROXY_ENV[@]}"; do
        local val="${!envar}"
        printf '%-12s %s\n' "$envar" "${val:-(not set)}"
      done
      printf '%-12s %s\n' no_proxy "${no_proxy:-(not set)}"
      printf '%-12s %s\n' NO_PROXY "${NO_PROXY:-(not set)}"
      printf '%-12s %s\n' git_http "${git_http:-(not set)}"
      printf '%-12s %s\n' git_https "${git_https:-(not set)}"
      echo "==&lt;==================="
      ;;
    *)
      echo "Usage: proxy {on|off|status}"
      return 1
      ;;
  esac
}

# enable proxy by default
proxycfg on 1>/dev/null 2>&1
