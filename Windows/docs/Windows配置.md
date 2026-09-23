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

下载便携软件包到自定义目录, 启动并配置, 参考 "代理.md"

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

使用 Kanata 做改键  
PowerShell(管理员身份) 执行自动部署脚本: `powershell -ExecutionPolicy Bypass -File Windows\scripts\setup-kanata-task.ps1`

---

废弃方案: 安装 AutoHotkey 并将配置 CapsLock+.ahk 放 `$APPDATA/Microsoft/Windows/Start Menu/Programs/Startup/`

# 开发环境

## 系统设置

`Windows 设置` -> `系统` -> `高级` -> `开发者选项` -> 打开 `开发人员模式` (让普通用户也可以创建 Symbolic Link)

`Windows 设置` -> `时间和语言` -> `语言和区域` -> 点击 `Windows 显示语言`, 开启 `UTF-8 全球语言支持`

> UTF-8 设置若遇到程序兼容性问题, 可尝试右键程序 -> 属性 -> 兼容性 -> 勾选 "以兼容模式运行此程序"

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
5. 脚本执行中会引导用 gh 登录 GitHub 获取凭证, 手工操作

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
