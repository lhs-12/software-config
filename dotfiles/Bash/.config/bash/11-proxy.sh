#!/usr/bin/env bash
# Proxy configuration

_proxycfg_detect() {
  # 1) gsettings
  if command -v gsettings >/dev/null 2>&1 \
     && [ "$(gsettings get org.gnome.system.proxy mode 2>/dev/null)" = "'manual'" ]; then
    local h="$(gsettings get org.gnome.system.proxy.http host 2>/dev/null | tr -d "'")"
    local p="$(gsettings get org.gnome.system.proxy.http port 2>/dev/null)"
    if [ -n "$h" ] && [ -n "$p" ] && [ "$p" != 0 ]; then
      echo "http://$h:$p"
      return 0
    fi
  fi
  # 2) kioslaverc (KDE), only when ProxyType=1
  local url="$(awk '/^\[/{g=/^\[Proxy Settings\]/;next} g&&/^ProxyType=1$/{ok=1} g&&/^httpProxy=/{u=substr($0,11)} END{if(ok&&u!="")print u}' "$HOME/.config/kioslaverc" 2>/dev/null)"
  if [ -n "$url" ]; then
    echo "http://$(sed -E 's#^[a-zA-Z0-9+.-]+://##' <<<"$url")"
    return 0
  fi
  return 1
}

proxycfg() {
  local noproxy="localhost,127.0.0.1,127.0.0.0/8,::1,10.0.0.0/8,172.16.0.0/12,192.168.0.0/16"
  case "$1" in
    on)
      local addr="$2"
      [ -z "$addr" ] && addr="$(_proxycfg_detect)"
      if [ -z "$addr" ]; then
        echo "proxycfg: no active system proxy found (gsettings / kioslaverc); usage: proxycfg on [host:port]" >&2
        return 1
      fi
      [[ "$addr" != *://* ]] && addr="http://$addr"
      export proxy="$addr"
      local envar
      for envar in http_proxy https_proxy ftp_proxy rsync_proxy all_proxy \
                   HTTP_PROXY HTTPS_PROXY FTP_PROXY RSYNC_PROXY ALL_PROXY; do
        export "$envar=$addr"
      done
      export no_proxy="$noproxy" NO_PROXY="$noproxy"
      git config --global http.proxy  "$addr"
      git config --global https.proxy "$addr"
      echo "Proxy enabled: $addr"
      ;;
    off)
      local envar
      for envar in http_proxy https_proxy ftp_proxy rsync_proxy all_proxy \
                   HTTP_PROXY HTTPS_PROXY FTP_PROXY RSYNC_PROXY ALL_PROXY; do
        unset "$envar"
      done
      unset no_proxy NO_PROXY
      git config --global --unset http.proxy
      git config --global --unset https.proxy
      echo "Proxy disabled"
      ;;
    status)
      echo "=== Proxy Status ==="
      local envar
      for envar in http_proxy https_proxy ftp_proxy rsync_proxy all_proxy \
                   HTTP_PROXY HTTPS_PROXY FTP_PROXY RSYNC_PROXY ALL_PROXY \
                   no_proxy NO_PROXY; do
        printf '%-12s %s\n' "$envar" "${!envar:-(not set)}"
      done
      printf '%-12s %s\n' git_http  "$(git config --global --get http.proxy 2>/dev/null || echo '(not set)')"
      printf '%-12s %s\n' git_https "$(git config --global --get https.proxy 2>/dev/null || echo '(not set)')"
      printf '%-12s %s\n' sys_proxy "$(_proxycfg_detect || echo '(inactive)')"
      echo "==================="
      ;;
    *)
      echo "Usage: proxycfg {on|off|status} [host:port]"
      return 1
      ;;
  esac
}

# Follow system proxy on shell start (gsettings or kioslaverc backend)
[[ -n ${WSL_DISTRO_NAME:-}${WSL_INTEROP:-} ]] && return 0
proxycfg on >/dev/null 2>&1 || proxycfg off >/dev/null 2>&1
