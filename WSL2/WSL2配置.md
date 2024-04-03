# <center>WSL2配置</center>

# 安装

安装Ubuntu为例:
1. 根据官方文档,使用 wsl 命令安装好WSL2环境
2. Microsoft Store 或 Github 搜索 WSL, 下载Linux-WSL发行版(.appx文件)
3. 若是appx文件, 改后缀为zip解压到指定目录并打开
4. 启动后设置root密码`sudo passwd root`
5. `sudo apt-get update`

用户目录下新建wsl配置文件, 如 `C:/Users/L/.wslconfig`    
参考官方文档进行配置, 注意版本  
使用mirrored网络, windows和wsl可以互相通过localhost访问
```
[wsl2]
networkingMode=mirrored
dnsTunneling=true
firewall=true
autoProxy=true
[experimental]
autoMemoryReclaim=dropcache
sparseVhd=true
```

# 安装软件

```
nvim
mise
tldr
```

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

# VSCode编辑调试WSL项目
> Windows的硬盘挂载在了wsl系统的`/mnt`目录下

> 由于 Windows 和 Linux 的文件行尾不一致, Git会报一堆文件修改, 
可通过`.gitattributes`或命令去禁用Git行尾转换解决, 具体操作参考WSL官方文档

1. Windows下的VSCode添加环境变量即可(别在linux里面装VSCode)
2. 在VSCode内通过WSL插件访问目录, 或在linux目录执行`code .`启动

# 自制WSL发行版

以下操作以ArchLinux为例

* 去github下载`LxRunOffline.exe`放到C盘system32目录中
* 去国内的源下载`archlinux-bootstrap-yyyy.MM.dd-x86_64.tar.gz`
* 安装发行版`LxRunOffline i -n ArchLinux -f E:\archlinux-bootstrap-yyyy.MM.dd-x86_64.tar.gz -d E:\ArchLinux  -r root.x86_64`
* 设置wsl版本`wsl --set-version ArchLinux 2`
* 删除网络配置`wsl -d ArchLinux`, `rm /etc/resolv.conf`,`exit`
* 重启`wsl --shutdown ArchLinux`, `wsl -d ArchLinux`
* 修改下载源
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

* 修改密码`passwd`
* 新建一个账户,作为常用的账户
```
useradd -m -G wheel -s /bin/bash l
passwd l

vim /etc/sudoers
将'wheel ALL=(ALL) ALL'这行的注释去掉
```
* 获取用户id`id -u <用户名>`, `exit`退出Linux, 执行`lxrunoffline su -n ArchLinux -v <用户id>`
