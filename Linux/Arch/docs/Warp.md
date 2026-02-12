# Warp

Arch Linux 配置步骤

```bash
# 1. 安装启动 cloudflare-warp
yay -S cloudflare-warp-bin
warp-cli --version
sudo systemctl start warp-svc
# sudo systemctl enable --now warp-svc
sudo systemctl status warp-svc

# 2. 注册设备, 连接
warp-cli registration new # 生成设备id, 绑定到Cloudflare
warp-cli connect
warp-cli status

# 3. 开启代理
warp-cli mode proxy
warp-cli connect
warp-cli status
sudo ss -lntp | grep warp-svc # 查看warp-svc占用端口
curl --socks5 127.0.0.1:1080 https://ipinfo.io # 查看ip信息
# 后续可以考虑固定warp的启用端口

# 4. 安装 sing-box
sudo pacman -S sing-box
sing-box version
lsmod | grep tun # 确认允许 TUN
sudo modprobe tun # 如果没有 TUN, 开启

# 5. 放置配置文件
# /etc/sing-box/config.json
# 修改里面端口 "server_port" 为前面的查到的warp-svc端口
# 6. 启动 sing-box
sing-box check -c /etc/sing-box/config.json # 测试配置正确
sudo sing-box run -c /etc/sing-box/config.json # 配置启动
# sudo systemctl enable --now sing-box # 启用 sing-box 服务

# 注: 如果安装了 v2rayN, 在/opt/v2rayn-bin/bin/sing_box下面就有sing-box, 可以临时用
```

sing-box 配置文件 `config.json`  
基于 TUN 的透明代理 + Cloudflare WARP 出站 + 国内直连分流 + DNS 走远程DoH + 自建 Trojan 入站

> 注: 待测试: 可删除 trojan 入站配置

```json5
{
  "log": {
    "level": "debug", // 可改 info
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
        "server": "208.67.222.222",
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
        "172.18.0.1/30"
      ],
      "auto_route": true,
      "auto_redirect": true,
      "strict_route": true,
      "type": "tun"
    },
    {
      "type": "trojan",
      "tag": "trojan-in",
      "listen": "0.0.0.0",
      "listen_port": 2087,
      "users": [
        {
          "name": "hongchen",
          "password": "12345678"
        }
      ],
      "multiplex": {},
      "transport": {}
    }
  ],
  "outbounds": [
    {
      "type": "socks",
      "tag": "warp-local",
      "server": "127.0.0.1",
      "server_port": 1080,
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
        "ip_cidr": [
          "162.159.197.0/24",
          "2606:4700:102::/48"
        ],
        "port": [
          443,
          500,
          1701,
          4500,
          4443,
          8443,
          8095
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
          "/usr/bin/warp-svc",
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