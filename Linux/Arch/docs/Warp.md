# Warp

Arch Linux 配置步骤

```bash
# 1. 安装启动 cloudflare-warp
yay -S cloudflare-warp-bin
warp-cli --version
sudo systemctl start warp-svc # or enable --now

# 2. 注册设备, 连接
warp-cli registration new # 初次执行: 生成设备id, 绑定到Cloudflare

# 3. 开启代理
warp-cli mode proxy # 可选: 视情况切换模式(warp+doh/proxy), warp模式无需singbox
warp-cli connect
warp-cli status
sudo ss -lntp | grep warp-svc # proxy模式: 查看warp-svc占用端口, 默认40000
curl --socks5 127.0.0.1:40000 https://ipinfo.io # 查看ip信息

# 4. 安装配置 sing-box
sudo pacman -S sing-box
sing-box version
lsmod | grep tun # 确认允许 TUN
sudo modprobe tun # 如果没有 TUN, 开启
# 放置配置文件: /etc/sing-box/config.json
# 修改里面端口 "server_port" 为前面的查到的warp-svc端口
sing-box check -c /etc/sing-box/config.json # 测试配置正确
sudo sing-box run -c /etc/sing-box/config.json # 启动singbox配置
# sudo systemctl enable --now sing-box # 启用 sing-box 服务

# 屏蔽自启动的 /etc/xdg/autostart/com.cloudflare.WarpTaskbar.desktop , 取消: unmark
systemctl --user mask warp-taskbar

# 如果安装了 v2rayN, 在/opt/v2rayn-bin/bin/sing_box下面就有sing-box, 可以临时用
# 右下角图标禁用: systemctl --user disable --now warp-taskbar.service
```

sing-box 配置文件 `config.json`  
基于 TUN 的透明代理 + Cloudflare WARP 出站 + 国内直连分流 + DNS 走远程DoH

```json5
{
  "log": {
    "level": "debug",
    "timestamp": true
  },
  "dns": {
    "rules": [
      {
        "rule_set": [
          "geosite-cn"
        ],
        "server": "local"
      }
    ],
    "servers": [
      {
        "type": "https",
        "server": "8.8.8.8",
        "detour": "warp-local",
        "tag": "remote"
      },
      {
        "type": "hosts",
        "path": [],
        "predefined": {},
        "tag": "host"
      },
      {
        "type": "local",
        "tag": "local"
      }
    ],
    "strategy": "prefer_ipv4"
  },
  "inbounds": [
    {
      "interface_name": "sing-box-tun",
      "address": [
        "172.20.0.1/30",
        "fdfe:dcba:9876::1/126"
      ],
      "route_address": [
        "0.0.0.0/1",
        "128.0.0.0/1",
        "::/1",
        "8000::/1"
      ],
      "route_exclude_address": [
        "192.168.0.0/16",
        "10.0.0.0/8",
        "172.16.0.0/12",
        "172.17.0.0/16",
        "172.19.0.0/12",
        "fc00::/7",
        "172.18.0.1/30",
        "162.159.197.0/24",
        "2606:4700:102::/48"
      ],
      "auto_route": true,
      "auto_redirect": true,
      "strict_route": true,
      "type": "tun"
    }
  ],
  "outbounds": [
    {
      "type": "socks",
      "tag": "warp-local",
      "server": "127.0.0.1",
      "server_port": 40000,
      "udp_over_tcp": false
    },
    {
      "type": "direct",
      "tag": "direct"
    }
  ],
  "route": {
    "final": "warp-local",
    "auto_detect_interface": true,
    "default_domain_resolver": "remote",
    "rules": [
      {
        "action": "sniff"
      },
      {
        "protocol": "dns",
        "action": "hijack-dns"
      },
      {
        "domain": [
          "zero-trust-client.cloudflareclient.com",
          "notifications.cloudflareclient.com"
        ],
        "outbound": "direct"
      },
      {
        "rule_set": [
          "geosite-cn",
          "geoip-cn"
        ],
        "outbound": "direct"
      },
      {
        "ip_is_private": true,
        "outbound": "direct"
      },
      {
        "process_path": [
          // "/usr/bin/warp-svc",
          "/usr/bin/cloudflared"
        ],
        "outbound": "direct"
      }
    ],
    "rule_set": [
      {
        "tag": "geoip-cn",
        "type": "remote",
        "format": "binary",
        "url": "https://raw.githubusercontent.com/SagerNet/sing-geoip/rule-set/geoip-cn.srs",
        "download_detour": "warp-local"
      },
      {
        "tag": "geosite-cn",
        "type": "remote",
        "format": "binary",
        "url": "https://raw.githubusercontent.com/SagerNet/sing-geosite/rule-set/geosite-cn.srs",
        "download_detour": "warp-local"
      }
    ]
  },
  "experimental": {
    "cache_file": {
      "enabled": true
    }
  }
}
```

## DNS 常用命令速查

```bash
# 查看DNS管理者
# 指向 `/run/systemd/...` → systemd-resolved
# 普通文件 → NetworkManager 直接写
# 127.0.0.1 → 本地代理接管（sing-box / dnsmasq）
ls -l /etc/resolv.conf
# 查看当前DNS服务器
cat /etc/resolv.conf

# 查看 NetworkManager 当前连接 DNS
nmcli dev show | grep DNS

# 查看 sing-box 是否在监听 DNS
ss -lpnt | grep :53 # 有输出就是接管了

# 查看几个相关服务的状态
systemctl status sing-box
systemctl status systemd-resolved
systemctl status NetworkManager

# 重启 NetworkManager(清理 DNS)
sudo systemctl restart NetworkManager

# 测试DNS解析
dig google.com # 需要pacman -S bind
# 测试真实路径
getent hosts google.com
# 测试DNS污染
dig google.com @8.8.8.8
dig google.com @127.0.0.1
# 测试IP
ping 8.8.8.8 # 如果能 ping IP 但不能 ping 域名 -> DNS问题

# 查看谁在修改 resolv.conf
sudo lsof /etc/resolv.conf # 查看DNS文件持有者
journalctl -u NetworkManager # NetworkManager 服务日志
journalctl -u sing-box # singbox 服务日志

# 清理DNS
#   浏览器DNS缓存
# chrome: 打开 chrome://net-internals/#dns 清理
# firefox: 打开 about:networking#dns 清理
#   如果用NetworkManager, 重启
sudo systemctl restart NetworkManager
#   如果用systemd-resolved
systemctl status systemd-resolved
resolvectl flush-caches # 清理
resolvectl statistics # 查看缓存状态
#   可能还需要重启singbox
sudo systemctl restart sing-box
```