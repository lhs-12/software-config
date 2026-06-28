<h1><center>WSL2 配置</center></h1>

# 常用命令

日常使用 WSL 的时候可以使用 Bash/Fish,  
但涉及修改 WSL 安装/配置修改/数据迁移...等高级行为, 请使用 `Pwsh` 运行.

安装

```sh
# 升级 WSL
wsl --update
# 查看可安装的发行版
wsl -l -o
# 安装
wsl --install [DistributionName]
# 查看拥有的发行版
wsl -l
# 查看运行状态
wsl -l -v
# 设置默认启动的发行版
wsl -s [DistributionName]
# 注销发行版
wsl --unregister [DistributionName]
```

备份/恢复/迁移 (Pwsh 运行)

```sh
# 创建备份目录
mkdir -p "D:\ProgramData\wsl-data"

# vhdx: 虚拟硬盘镜像, 体积大, 适合本地快速备份恢复
# wsl --export <DistributionName> <FileName.vhdx> --vhd
# wsl --import-in-place <DistributionName> <FileName.vhdx>
wsl --export archlinux "D:\ProgramData\wsl-data\archlinux.vhdx" --vhd
wsl --import-in-place archlinux "D:\ProgramData\wsl-data\archlinux.vhdx"

# tar: 压缩归档, 体积小, 适合跨机器迁移
# wsl --export <DistributionName> <FileName.tar>
# wsl --import <DistributionName> <InstallLocation> <FileName.tar> --version 2
wsl --export archlinux "D:\ProgramData\wsl-data\archlinux.tar"
wsl --import archlinux "D:\WSL\archlinux" "D:\ProgramData\wsl-data\archlinux.tar" --version 2

# 迁移步骤: 导出 -> 注销原发行版 -> 导入 -> 重新设置默认登录用户
wsl --export archlinux "D:\ProgramData\wsl-data\archlinux.vhdx" --vhd
wsl --unregister archlinux
wsl --import-in-place archlinux "D:\ProgramData\wsl-data\archlinux.vhdx"
wsl --manage archlinux --set-default-user 用户名
```

# 安装

## 前置条件

1. 系统版本达到 Windows 11 以上
2. BIOS 启用虚拟化(Intel VT-x / AMD-V), 大部分电脑已默认开启

> 查看 Windows 系统版本: `Win + R` 输入 `winver`  
> 查看虚拟化是否开启: 任务管理器 → 性能 → CPU → 虚拟化: 已启用

参考:

1. [WSL安装](https://learn.microsoft.com/zh-cn/windows/wsl/install)
2. [WSL网络](https://learn.microsoft.com/zh-cn/windows/wsl/networking#mirrored-mode-networking)
3. [WSL文档源码](https://github.com/MicrosoftDocs/WSL)

## 编写 WSL 配置

查看最新的配置文档, 编写配置文件: `%HOMEPATH%/.wslconfig`

> 使用镜像网络模式, win 和 wsl 可互相通过 localhost 访问

```toml
[wsl2]
networkingMode=mirrored
dnsTunneling=true
autoProxy=false
firewall=true
[experimental]
hostAddressLoopback=true
autoMemoryReclaim=dropCache
sparseVhd=true
```

## 安装发行版

- 建议先更新到最新版 WSL: `wsl --update`
- 查看可安装的 Linux 发行版: `wsl -l -o`
- 执行安装: `wsl --install -d [发行版]`
- 指定默认使用: `wsl -s [发行版]`
- 启动: `wsl -d [发行版]`

# 使用技巧

## 网络代理

使用系统代理的时候, 仅在 `~/.bashrc` 中配置了系统代理端口的设置是不够的,  
因为 WSL 启动时是 login shell, 它默认读取的是 `~/.bash_profile`,  
因此 `~/.bash_profile` 中需要存在: `[[ -f ~/.bashrc ]] && . ~/.bashrc`

---

使用 v2rayN 的 TUN 网络时,  
建议 core 类型选 singbox, MTU 调至 1408,  
原因:  
TLS ClientHello 包较大(1200-1800 bytes), TUN 的 MTU 过大会导致丢包.  
表现为 WSL 的 HTTPS 连接可能超时, 而 HTTP 正常

---

使用 FlClash 之类的 Mihomo 的 TUN 代理时,  
把 "DNS 模式" 从 `Fake-IP` 改为 `Redir-Host`,  
原因: FlClash 的排除规则会排除 WSL 的流量, Fake-IP 被排除后不处理导致超时

## VSCode 编辑调试 WSL 项目

> Windows 的硬盘挂载在了 WSL 系统的 `/mnt` 目录下

> 由于 Windows 和 Linux 的文件行尾不一致, Git 会报一堆文件修改,  
> 可通过 `.gitattributes` 或命令禁用 Git 行尾转换解决, 具体参考 WSL 文档

1. Windows 下的 VSCode 添加环境变量即可(别在 Linux 里面装 VSCode)
2. 在 VSCode 内通过 WSL 插件访问目录, 或在 Linux 目录执行 `code .` 启动

## GUI 应用边框问题

[参考](https://github.com/microsoft/wslg/issues/530#issuecomment-2628240995)

# Arch Linux 安装配置

流程: 先手动执行一部分安装设置, 重启后再调用脚本完成剩余自动安装

手动安装阶段:

```sh
# 安装 Arch WSL (安装完成会自动进入)
wsl --install -d archlinux

# 生成 locale
sed -i '/^#en_US.UTF-8/s/^#//' /etc/locale.gen
sed -i '/^#zh_CN.UTF-8/s/^#//' /etc/locale.gen
locale-gen
echo "LANG=en_US.UTF-8" > /etc/locale.conf
# Pacman 显示下载进度
sed -i 's/^NoProgressBar/# NoProgressBar/' /etc/pacman.conf
sed -i 's/^#Color/Color/' /etc/pacman.conf
# Pacman 换源
sed -i '1i Server = https://mirrors.tuna.tsinghua.edu.cn/archlinux/$repo/os/$arch' /etc/pacman.d/mirrorlist
sed -i '1i Server = https://mirrors.cloud.tencent.com/archlinux/$repo/os/$arch' /etc/pacman.d/mirrorlist
sed -i '1i Server = http://mirrors.aliyun.com/archlinux/$repo/os/$arch' /etc/pacman.d/mirrorlist
# 更新密钥环并初始化
pacman -Sy archlinux-keyring && pacman -Syyu
# 添加 CN 源
tee -a /etc/pacman.conf > /dev/null << 'EOF'
[archlinuxcn]
Server = https://mirrors.aliyun.com/archlinuxcn/$arch
Server = https://mirrors.cloud.tencent.com/archlinuxcn/$arch
Server = https://mirrors.tuna.tsinghua.edu.cn/archlinuxcn/$arch
EOF
pacman -Sy archlinuxcn-keyring
# 安装基础包
pacman -S --needed base-devel git neovim paru
# 启用 sudoers
sed -i 's/# %wheel ALL=(ALL:ALL) ALL/%wheel ALL=(ALL:ALL) ALL/' /etc/sudoers
# 禁用 Windows PATH 注入
tee -a /etc/wsl.conf > /dev/null << 'EOF'
[interop]
appendWindowsPath=false
EOF

# 创建普通用户
useradd -m -g wheel 用户名
passwd 用户名
# 修改 root 用户密码
passwd

# 退出 WSL
exit
wsl --shutdown
# 设置默认账号
wsl --manage archlinux --set-default-user 用户名
```

自动安装阶段:

```sh
# 普通用户进入 WSL
wsl
# 下载仓库
cd ~ && git clone --depth=1 https://github.com/lhs-12/software-config.git
cd ~/software-config
# 编辑脚本参数
nvim dotfiles/setup-wsl-arch.sh
# 运行脚本
mkdir -p .temp
bash dotfiles/setup-wsl-arch.sh 2>&1 | tee .temp/setup-wsl-arch.log
```
