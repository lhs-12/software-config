# <center>daed 使用指南</center>

适用于 Arch 个人桌面系统

# 安装

```bash
sudo pacman -S daed-avx2-bin # Optimized for x86-64 v3 / AVX2
sudo systemctl enable --now daed
# 浏览器访问 http://localhost:2023 , 配置
# journalctl -xfu daed.service # 查日志
```

# 常用配置

---

**配置** (对应 dae 的 `global` 配置块)

1. 开启 "启用本地TCP快速重定向"
2. 填写 "LAN接口" 和 "WAN接口" (LAN接口可选加入docker虚拟网卡)
3. "TLS实现" 改为 `utls`, "uTLS模仿" 用 `edge_auto`

---

**DNS** (对应 dae 的 `dns` 配置块)

```lua
upstream {
  alidns: 'https://dns.alidns.com:443/dns-query'
  googledns: 'https://dns.google:443/dns-query'
}
routing {
  request {
    qname(geosite:category-ads-all) -> reject
    qtype(https) -> reject
    qname(geosite:cn) -> alidns
    fallback: googledns
  }
  response {
    upstream(googledns) -> accept
    ip(geoip:private) && !qname(geosite:cn) -> googledns
    fallback: accept
  }
}
```

---

**路由** (对应 dae 的 `routing` 配置块)

```lua
pname(NetworkManager, systemd-resolved, dnsmasq, sshd) -> must_direct
l4proto(udp) && dport(443) -> block
dip(224.0.0.0/3, 'ff00::/8') -> direct
dip(geoip:private) -> direct
domain(geosite:category-ads-all) -> block
domain(geosite:cn) -> direct
dip(geoip:cn) -> direct
dscp(0x04) -> direct
fallback: proxy
```