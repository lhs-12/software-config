# <center>Arch Linux 常用命令</center>

# 包管理

## 1. 官方仓库(Pacman)

```bash
sudo pacman -S archlinux-keyring
sudo pacman -S archlinuxcn-keyring
```

### 1.1 安装与更新

```bash
sudo pacman -Syu              # 完全系统更新（同步数据库并升级所有包）
sudo pacman -S <package_name> # 安装指定软件包
sudo pacman -S --needed <pkg> # 仅当需要时才安装（避免重复安装）
```

### 1.2 查询与搜索

```bash
pacman -Ss <keyword>      # 在官方仓库中搜索软件包
pacman -Qs <keyword>      # 在已安装的包中搜索
pacman -Qi <package_name> # 显示已安装包的详细信息
pacman -Ql <package_name> # 列出该包安装的所有文件
pacman -Qe                # 列出所有显式安装的包（非依赖）
pacman -F <filename>      # 查询哪个包提供了某个文件（需先运行 sudo pacman -Fy）
```

### 1.3 删除

```bash
sudo pacman -Rs <package_name>  # 删除软件包及其不再需要的依赖（推荐）
sudo pacman -Rns <package_name> # 删除软件包、依赖及其配置文件
```

### 1.4 清理

```bash
sudo pacman -Sc  # 清理缓存，仅保留当前安装的版本
sudo pacman -Scc # 彻底清空缓存（无法再降级软件包）
```

## 2. AUR

下面使用 `paru` 作为 AUR 助手，它是 `yay` 的替代品

### 2.1 安装与更新

```bash
paru -Syu              # 更新所有包（包括官方和 AUR）
paru -S <package_name> # 从官方仓库或 AUR 安装软件包
```

### 2.2 查询与搜索

```bash
paru -Ss <keyword>      # 同时在官方仓库和 AUR 中搜索
paru -Qs <keyword>      # 在已安装的包中搜索（包括 AUR 包）
paru -Si <package_name> # 显示软件包信息（包括 AUR 包）
```

### 2.3 清理

```bash
paru -Sc # 清理包构建文件和未使用的依赖
paru -c  # 清理 AUR 构建缓存目录
```

# 系统与服务管理

## 3. 系统服务（Systemd）

```bash
sudo systemctl start <service_name>   # 启动一个服务
sudo systemctl stop <service_name>    # 停止一个服务
sudo systemctl restart <service_name> # 重启一个服务
sudo systemctl enable <service_name>  # 设置服务开机自启
sudo systemctl disable <service_name> # 取消服务开机自启
sudo systemctl status <service_name>  # 查看服务状态和日志
systemctl --failed                    # 列出启动失败的服务
```

---

## 4. 系统信息与监控

```bash
htop                         # 交互式进程查看器（需安装）
df -h                        # 显示磁盘空间使用情况（人类可读）
du -sh <directory>           # 查看目录磁盘使用总量
free -h                      # 显示内存和交换空间使用情况
journalctl -u <service_name> # 查看特定服务的日志
journalctl -f                # 实时跟踪系统日志
uname -r                     # 显示当前内核版本
lsblk                        # 以树形格式列出所有块设备
```

---

## 5. 网络管理

```bash
ip addr 或 ip a                       # 查看网络接口和 IP 地址
ping <host>                           # 测试网络连接
sudo systemctl restart NetworkManager # 重启 NetworkManager 服务
```

---

## 6. 文件与目录操作

```bash
ls -la                           # 列出目录内容（详细信息 + 隐藏文件）
cd <path>                        # 切换目录
pwd                              # 显示当前工作目录
cp -r <source> <dest>            # 复制文件或目录（-r 递归）
mv <source> <dest>               # 移动或重命名文件/目录
rm -rf <file/dir>                # [危险] 强制递归删除
chmod +x <file>                  # 给文件添加可执行权限
sudo chown <user>:<group> <file> # 改变文件的所有者和组
```

---

## 7. 用户和权限

```bash
sudo passwd <username>         # 修改用户密码
useradd -m -G wheel <username> # 创建新用户并加入 wheel 组（可 sudo）
usermod -aG <group> <username> # 将用户添加到附加组
groups <username>              # 查看用户所属的组
```

---

# 最佳实践与提醒

1. **定期更新**  
   使用 `paru -Syu` 或 `sudo pacman -Syu` 保持系统最新
2. **查看官方新闻**  
   更新前访问：[https://archlinux.org/news/](https://archlinux.org/news/)，检查是否需要手动干预
3. **依赖 Arch Wiki**  
   遇到问题，首先查阅 Arch Wiki，它是终极宝典
4. **谨慎使用 AUR**  
   安装 AUR 包前，请检查 `PKGBUILD` 脚本以确保安全
5. **理解命令含义**  
   在执行任何命令（尤其是 `rm -rf`）前，请确认你完全理解其作用
