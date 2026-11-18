function _proxycfg_detect --description "print active system proxy as http://host:port; return 1 if none"
  # 1) gsettings
  if command -q gsettings; and test (gsettings get org.gnome.system.proxy mode 2>/dev/null) = "'manual'"
    set -l h (gsettings get org.gnome.system.proxy.http host 2>/dev/null | string trim --chars="'")
    set -l p (gsettings get org.gnome.system.proxy.http port 2>/dev/null)
    if test -n "$h"; and test -n "$p"; and test "$p" != 0
      echo "http://$h:$p"
      return 0
    end
  end
  # 2) kioslaverc (KDE), only when ProxyType=1
  set -l url (awk '/^\[/{g=/^\[Proxy Settings\]/;next} g&&/^ProxyType=1$/{ok=1} g&&/^httpProxy=/{u=substr($0,11)} END{if(ok&&u!="")print u}' ~/.config/kioslaverc 2>/dev/null)
  if test -n "$url"
    echo "http://"(string replace -r '^[a-zA-Z0-9+.-]+://' '' -- $url)
    return 0
  end
  return 1
end

function proxycfg --description "proxy config management"
  set -l PROXY_ENV \
    http_proxy https_proxy ftp_proxy rsync_proxy all_proxy \
    HTTP_PROXY HTTPS_PROXY FTP_PROXY RSYNC_PROXY ALL_PROXY

  switch $argv[1]
    case on
      set -l addr $argv[2]
      test -n "$addr"; or set addr (_proxycfg_detect)
      if test -z "$addr"
        echo "proxycfg: no active system proxy found (gsettings / kioslaverc); usage: proxycfg on [host:port]" >&2
        return 1
      end
      string match -q '*://*' -- $addr; or set addr "http://$addr"
      set -gx proxy   "$addr"
      set -gx noproxy "localhost,127.0.0.1,127.0.0.0/8,::1,10.0.0.0/8,172.16.0.0/12,192.168.0.0/16"
      for envar in (string split ' ' $PROXY_ENV)
        set -gx $envar $proxy
      end
      set -gx no_proxy $noproxy
      set -gx NO_PROXY $noproxy
      git config --global http.proxy  $proxy
      git config --global https.proxy $proxy
      echo "Proxy enabled: $proxy"

    case off
      for envar in (string split ' ' $PROXY_ENV)
        set -eg $envar
      end
      set -eg no_proxy NO_PROXY
      git config --global --unset http.proxy
      git config --global --unset https.proxy
      echo "Proxy disabled"

    case status
      echo "=== Proxy Status ==="
      for envar in (string split ' ' $PROXY_ENV) no_proxy NO_PROXY
        set -l val (printenv $envar 2>/dev/null)
        printf '%-12s %s\n' $envar (set -q $envar && echo $val || echo "(not set)")
      end
      set -l val (git config --global --get http.proxy 2>/dev/null)
      printf '%-12s %s\n' git_http (test -n "$val" && echo $val || echo "(not set)")
      set -l val (git config --global --get https.proxy 2>/dev/null)
      printf '%-12s %s\n' git_https (test -n "$val" && echo $val || echo "(not set)")
      set -l sys (_proxycfg_detect)
      printf '%-12s %s\n' sys_proxy (test $status -eq 0 && echo $sys || echo "(inactive)")
      echo "==================="

    case '*'
      echo "Usage: proxycfg {on|off|status} [host:port]"
  end
end
