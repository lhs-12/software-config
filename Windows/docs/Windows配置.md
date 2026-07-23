<h1><center>Windows 环境设置</center></h1>

# 基础设置

win11: 资源管理器 -> 选项 -> 常规 -> 打开文件资源管理器时打开"此电脑"  
win11: 资源管理器 -> 选项 -> 查看 -> 高级设置 -> 导航窗格 -> 勾选"显示所有文件夹"

执行脚本 `win11_menu_switch.cmd`

# 日常软件

```
VC++运行库(`winget search Microsoft.VCRedist`, 或搜索"The latest supported Visual C++ downloads")
Office(用Office Tool Plus,搜kms.loli.beer)
Everything
PixPin(仅保留截图和贴图快捷键: F1,F3)
360压缩, 有道翻译
网盘: 百度, 阿里, 夸克
网易云音乐, PotPlayer
微信, QQ
Notion
Z-Library + Koodo-Reader
系统美化: TranslucentTB(透明化任务栏) + material-design-cursors(鼠标光标主题) + (个性化->颜色->深色)
```

浏览器插件:  
`AdBlock`, `Dark Mode`, `Vimium`, `KeePassXC`, `Xget Now`, `PageTurn Book Reader`,  
`简易翻译`, `Tampermonkey`, `WebRTC Protect`, `Vue.js devtools`

# 代理

[FlClash](https://github.com/chen08209/FlClash)

基本配置:

1. 下载便携软件包到自定义目录, 启动程序
2. `配置` -> `添加配置` -> 导入 URL 配置
3. `代理` -> `设置` -> 修改显示样式为紧凑标签页
4. `代理` -> 设置不同场景使用的节点. (不在乎隐私想省流量时 `漏网之鱼` 可选 `DIRECT`)
5. `工具` -> `资源` -> `同步` 更新数据
6. `工具` -> `应用程序` -> 开启 `退出时最小化`, `自启动`, `静默启动`, `自动运行`
7. `仪表盘` -> 开启 `虚拟网卡`, 点击右下角启动按钮打开

> 出现问题可尝试修改虚拟网卡栈模式为 gvisor

> 使用 WSL 需要加覆写配置 `config.tun.mtu = 1500;`

---

[v2rayN](https://github.com/2dust/v2rayn)

基本配置:

1. 菜单里的 v2rayN 的快捷方式, 右键属性, 打开 "用管理员身份运行"
2. 设置 -> 参数设置 -> 基础设置 -> 打开 "允许来自局域网的连接"
3. 设置 -> 参数设置 -> v2rayN 设置 -> 打开 "开机启动"
4. 设置 -> 参数设置 -> Core 类型设置 -> 全部改成 sing_box
5. 设置 -> 参数设置 -> Tun 模式设置 -> MTU 改为 1408

功能不正常时可尝试:

1. 检查防火墙中是否放行了 xray/v2ray/singbox 之类的程序的公用和专用网络的访问
2. 设置 -> 参数设置 -> Tun 模式设置 -> 切换 "协议栈"

# 字体

| 字体                                                                        | 文件                           |
| --------------------------------------------------------------------------- | ------------------------------ |
| [IosevkaTerm](https://github.com/be5invis/Iosevka/releases)                 | PkgTTC-SGr-IosevkaTerm-xxx.zip |
| [MiSans](https://hyperos.mi.com/font/zh/download/)                          | MiSans{,TC,L3}                 |
| [LxgwNeoXiZhi-Screen](https://github.com/lxgw/LxgwNeoXiZhi-Screen/releases) | LXGWNeoZhiSongScreenFull.ttf   |
| [SarasaTermSC](https://github.com/be5invis/Sarasa-Gothic/releases)          | SarasaTermSC-TTF-xxx.7z        |
| [NerdFontsSymbolsOnly](https://github.com/ryanoasis/nerd-fonts/releases)    | NerdFontsSymbolsOnly.zip       |
| [Noto Color Emoji](https://fonts.google.com/noto/specimen/Noto+Color+Emoji) | Noto_Color_Emoji.zip           |

# RIME输入法

1. 下载[RIME输入法](https://github.com/rime/weasel)
2. git clone [雾凇拼音](https://github.com/iDvel/rime-ice) 到 RIME 用户目录
3. 将配置文件放进 RIME 用户目录 (可通过脚本软链接过去)
4. 执行 `disable-ctrl-space.reg`(禁用系统默认快捷键 Ctrl + Space)

> `default.custom.yaml` 配置中包含了 AUR 包的特殊配置, 需要注释掉或放一个空 patch 文件(脚本已处理)

# 改键

建议使用 Kanata:

1. 从 [kanata](https://github.com/jtroo/kanata) 下载 `windows-binaries-x64.zip`
2. 解压得到 `kanata_windows_gui_winIOv2_x64.exe`
3. 将 exe 文件和配置文件`capslock+.kbd`放到 `D:\Program Files\tools\kanata`
4. 配置 Windows 的 任务计划程序(Task Scheduler)

任务计划程序配置:

1. 按 `Win + R`, 运行 `taskschd.msc`
2. 右侧点击 "创建任务..." (注意不是基本任务)
3. `常规`选项卡 -> 名称: `Kanata CapsLock+`, 勾选 "只在用户登录时运行" 和 "使用最高权限运行"
4. `触发器`选项卡 -> 点击 "新建", 选择 "登录时", 选择 "特定的用户". 设置 "延迟任务时间" 10 秒
5. `操作`选项卡 -> 点击 "新建", 操作选 "启动程序"
   - "程序或脚本": `kanata_windows_gui_winIOv2_x64.exe`
   - "添加参数": `-c capslock+.kbd`
   - "起始于": `D:\Program Files\tools\kanata\`
6. `条件`选项卡 -> 取消勾选 "只有在计算机使用交流电源时才启动此任务"
7. `设置`选项卡 -> 取消勾选 "如果任务运行时间超过以下时间, 停止任务"
8. 立即使用: 右键点击运行任务计划程序库中的 Kanata 任务

> 废弃:  
> AutoHotkey(不稳定): 安装软件并将配置文件 CapsLock+.ahk 放 `$APPDATA/Microsoft/Windows/Start Menu/Programs/Startup/`

# 开发环境

## 系统设置

`Windows 设置` -> `系统` -> `高级` -> `开发者选项` -> 打开 `开发人员模式` (让普通用户也可以创建 Symbolic Link)

## 开发相关软件

| 软件名            | 作用               |
| ----------------- | ------------------ |
| Pwsh              | 微软 Shell         |
| WezTerm(Nightly)  | 模拟终端           |
| MobaXterm         | 远程管理           |
| VSCode            | 编辑器             |
| JetBrains Toolbox | JetBrains 管理工具 |
| DBX               | 数据库管理         |
| ApiFox            | 网络访问           |
| Fiddler           | 抓包工具           |

> JDK 的安装和环境变量建议用 Mise 管理, 或使用 `jdk_path.ps1` 脚本

## MSYS2 环境

1. 下载 `MSYS2` 安装包执行安装
2. 添加系统变量 Path(放末尾): `C:\msys64\ucrt64\bin\` 和 `C:\msys64\usr\bin`
3. 统一 `HOME` 目录: 用 `pwsh` 执行 `edit C:\msys64\etc\nsswitch.conf`, 将 `db_home` 的值从 `cygwin desc` 改为 `windows`
4. 使用 `MSYS2` 的 `UCRT64` 环境启动, 检查修改并执行脚本: `bash setup-msys2.sh`
5. 执行 `gh auth login` 登录 Github (Git 和 Mise 相关配置会使 Mise 获得 Github 访问认证)

> `setup-msys2.sh` 脚本会自动添加 Mise 相关的用户变量 Path

MSYS2 的包管理工具是 `pacman`

| 常用命令      | 作用             |
| ------------- | ---------------- |
| `pacman -Syu` | 升级所有软件     |
| `pacman -Ss`  | 查询可用包       |
| `pacman -S`   | 安装包           |
| `pacman -Qs`  | 查询已安装包     |
| `pacman -Qi`  | 查询已安装包信息 |
| `pacman -Rns` | 卸载包及依赖     |
| `pacman -Sc`  | 清理缓存         |

## WSL 环境

详看 `WSL2配置.md`, WSL2 安装与 MSYS2 安装的内容有少数耦合, 建议先装 MSYS2
