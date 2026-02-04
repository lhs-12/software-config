# <center>WSL2 配置</center>

# 常用命令

```
查看运行状态
wsl -l -v
查看拥有的发行版
wsl --list
设置默认启动的发行版
wslconfig /setdefault [发行版名称, 如CentOS7]
注销发行版
wsl --unregister [发行版名称]
```

# 安装

根据官方文档,使用 wsl 命令配置前置环境

> 参考文档：https://learn.microsoft.com/zh-cn/windows/wsl/networking#mirrored-mode-networking

---

新建配置文件: `%HOMEPATH%/.wslconfig`  
参考官方文档进行配置, 注意版本(如有需要, 使用 `wsl --update` 升级)

```toml
[wsl2]
networkingMode=mirrored # mirrored 网络模式, win和wsl可互相通过localhost访问
autoProxy=false
dnsTunneling=true
firewall=true
[experimental]
autoMemoryReclaim=dropcache
sparseVhd=true
```

---

安装发行版, 以 FedoraLinux-42 为例

- 查看可安装的 Linux 发行版: `wsl --list --online`
- 执行安装: `wsl --install -d FedoraLinux-42`
- 指定默认使用: `wsl -s FedoraLinux-42`
- 启动: `wsl -d FedoraLinux-42`
- 配置用户名 (可选配置密码: `sudo passwd [用户名]`)

> 也可以 Github 搜索下载 Linux-WSL 发行版(.appx 文件), 改后缀为 zip 解压到指定目录并打开

# 配置网络代理

配置 v2rayN:

1. 设置 -> 基础设置 -> 勾选"允许来自局域网的连接"
2. 注意确保防火墙中允许 V2ray 进行公用和专用网络的访问

进入 WSL

- 修改配置: `vi ~/.bashrc`
- 使配置生效: `source ~/.bashrc`
- 执行`proxy`和`unproxy`实现代理开关

```bash
# proxy setting
# export hostip=$(ip route | grep default | awk '{print $3}')
export hostip=127.0.0.1
export hostport=10808
alias proxy='
    export HTTPS_PROXY="http://${hostip}:${hostport}";
    export HTTP_PROXY="http://${hostip}:${hostport}";
    export ALL_PROXY="http://${hostip}:${hostport}";
    git config --global http.proxy "http://${hostip}:${hostport}";
    git config --global https.proxy "http://${hostip}:${hostport}";
    sudo sed -i "/proxy=http:/d" /etc/dnf/dnf.conf;
    echo -e "proxy=http://${hostip}:${hostport}" | sudo tee -a /etc/dnf/dnf.conf > /dev/null;
'
alias unproxy='
    unset HTTPS_PROXY;
    unset HTTP_PROXY;
    unset ALL_PROXY;
    git config --global --unset http.proxy;
    git config --global --unset https.proxy;
    sudo sed -i "/proxy=http:/d" /etc/dnf/dnf.conf;
'
```

WSL 启动时是登录 shell（login shell），它默认读取 ~/.bash_profile，而不是 ~/.bashrc。

```bash
if [ -f ~/.bashrc ]; then
    source ~/.bashrc
fi
```

验证代理情况:

- `env | grep -E 'hostip|hostport|HTTP_PROXY|HTTPS_PROXY|ALL_PROXY'`
- `alias | grep -E 'proxy|unproxy'`
- `git config --global --get http.proxy`

对于Chrome, 加参数: `chromium-browser --proxy-server=localhost:10808`

# 安装配置

```sh
# 打开Docker Desktop, 设置WSL集成

# 可参考 https://kskroyal.com/10-important-things-to-do-right-after-installing-fedora-40/

# 设置真彩色
echo 'export COLORTERM=truecolor' >> ~/.bashrc
# 更新仓库元数据
sudo dnf makecache
# 更新所有包
sudo dnf upgrade -y
# 安装常用包
sudo dnf install -y @core development-tools gcc-c++ net-tools git tldr --exclude=plymouth*
# 取消软件边框修改参考: https://github.com/microsoft/wslg/issues/530#issuecomment-2628240995
sudo dnf install -y fontconfig gnome-text-editor nautilus libglvnd-gles chromium
# 安装字体
sudo dnf install -y google-noto-sans-mono-cjk-vf-fonts
sudo mkdir -p /usr/share/fonts/sarasa
sudo find /mnt/c/Windows/Fonts -name "*Sarasa*" -exec cp {} /usr/share/fonts/sarasa \;
sudo chown -R root: /usr/share/fonts/sarasa
sudo chmod 644 /usr/share/fonts/sarasa/*
sudo restorecon -vFr /usr/share/fonts/sarasa
sudo fc-cache -fv
# 安装mise(多语言版本控制)
curl https://mise.run | sh
echo 'eval "$(~/.local/bin/mise activate bash)"' >> ~/.bashrc
source ~/.bashrc
```

# 输入法

```sh
sudo dnf install fcitx5 fcitx5-rime fcitx5-configtool

vi ~/.bashrc # 修改内容
export INPUT_METHOD=fcitx
export GTK_IM_MODULE=fcitx
export QT_IM_MODULE=fcitx
export XMODIFIERS=@im=fcitx
source ~/.bashrc

cd ~/.local/share/fcitx5/rime
sudo cp -r /mnt/c/Users/L/AppData/Roaming/Rime/* .
rm -rf ./build

fcitx5 --disable=wayland & # 启动
fcitx5-configtool # 输入法选项框添加Rime
fcitx5-remote -r # 重置
pkill fcitx5
fcitx5 --disable=wayland &
fcitx5-diagnose # Rime不生效的时候用
```

# GUI 应用无边框

对于 JetBrains 系列产品, 可增加 VM 参数解决: `-Dawt.toolkit.name=WLToolkit`

通用方案:  
执行: `sudo dnf install -y wmctrl xdotool xorg-x11-utils`  
保存脚本: `vi ~/fullscreen.sh`, 执行`~/fullscreen.sh [应用名]`

```bash
#!/bin/bash
# Check if any arguments were passed
if [ $# -eq 0 ]; then
  echo "Usage: $0 <window_name>"
  exit 1
fi
# Use the passed argument as the window name
window_name="$1"
# Find all windows matching the window name
window_ids=$(xdotool search --name "$window_name")
# Check if any windows were found
if [ -z "$window_ids" ]; then
  echo "No windows found with the name '$window_name'"
  exit 1
fi
# Loop through all found window IDs and perform the operations
for window_id in $window_ids; do
  echo "Processing window ID: $window_id"
  # Remove window borders
  xprop -id $window_id -f _MOTIF_WM_HINTS 32c -set _MOTIF_WM_HINTS "2, 0, 0, 0, 0"
  # Set window to fullscreen
  wmctrl -ir $window_id -b add,fullscreen
done
echo "All windows have been processed"
```

# 在 WSL 安装 Docker 

安装 docker 和 docker-compose

```bash
pacman -S --noconfirm docker docker-compose
```

配置 Docker 代理

```bash
# 1. 创建配置目录
mkdir -p /etc/systemd/system/docker.service.d

# 2. 写入代理配置文件
cat > /etc/systemd/system/docker.service.d/http-proxy.conf << 'EOF'
[Service]
Environment="HTTP_PROXY=http://127.0.0.1:10808"
Environment="HTTPS_PROXY=http://127.0.0.1:10808"
Environment="NO_PROXY=localhost,127.0.0.1,【自己的docker仓库】"
EOF

# 3. 重新加载 systemd 配置
systemctl daemon-reload

# 4. 重启 Docker 服务
systemctl restart docker

# 5. 验证配置
systemctl show --property=Environment docker
```

# VSCode 编辑调试 WSL 项目

> Windows 的硬盘挂载在了 wsl 系统的`/mnt`目录下

> 由于 Windows 和 Linux 的文件行尾不一致, Git 会报一堆文件修改,
> 可通过`.gitattributes`或命令去禁用 Git 行尾转换解决, 具体操作参考 WSL 官方文档

1. Windows 下的 VSCode 添加环境变量即可(别在 linux 里面装 VSCode)
2. 在 VSCode 内通过 WSL 插件访问目录, 或在 linux 目录执行`code .`启动

# 自制 WSL 发行版

以 ArchLinux 为例

- 去 github 下载 `LxRunOffline.exe` 放到 C 盘 system32 目录中
- 去国内的源下载 `archlinux-bootstrap-yyyy.MM.dd-x86_64.tar.gz`
- 安装发行版 `LxRunOffline i -n ArchLinux -f E:\archlinux-bootstrap-yyyy.MM.dd-x86_64.tar.gz -d E:\ArchLinux  -r root.x86_64`
- 设置 wsl 版本 `wsl --set-version ArchLinux 2`
- 删除网络配置 `wsl -d ArchLinux`, `rm /etc/resolv.conf`, `exit`
- 重启 `wsl --shutdown ArchLinux`, `wsl -d ArchLinux`
- 修改下载源

> 现在已经有官方Arch镜像: https://github.com/yuk7/ArchWSL/  
> 下载ArchWSL，然后安装 Arch.exe 即可

-

```
cd /etc/
explorer.exe .

修改pacman.conf,在文件最后加入
[archlinuxcn]
Server = https://mirrors.tuna.tsinghua.edu.cn/archlinuxcn/$arch

进入下一级pacman.d目录,编辑mirrolist文件,把China的部分的注释去掉

更新pacman
pacman -Syy
pacman-key --init
pacman-key --populate
pacman -S archlinuxcn-keyring

安装基础包
pacman -S base base-devel vi vim git wget glibc
```

- 修改密码`passwd`
- 新建一个账户,作为常用的账户

```
useradd -m -G wheel -s /bin/bash l
passwd l

vim /etc/sudoers
将'wheel ALL=(ALL) ALL'这行的注释去掉
```

- 获取用户 id`id -u <用户名>`, `exit`退出 Linux, 执行`lxrunoffline su -n ArchLinux -v <用户id>`

# 备份WSL

```bash
# 备份
# wsl --export 会自动停止 WSL, 然后把整个 WSL 容器打包成一个 tar 文件,
# 包含所有配置文件/已安装的软件/用户的设置等.
# 虽然有一些 socket 文件的警告(比如 gnupg 的 socket), 但这些都是运行时文件, 不影响备份完整性.
wsl --export [wsl名称] "D:/arch-wsl-backup.tar"

# 恢复
# 参数含义: 指定名称 ; 解压目录 ; 备份文件 ; 设置 WSL version 为 2
wsl --import [wsl名称] "D:/WSL_Test" "D:/arch-wsl-backup.tar" --version 2
```

# 卸载 WSL

`wsl --unregister [wsl名称]`