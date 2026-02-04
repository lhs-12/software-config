# <center>Windows 环境设置</center>

# 基础设置

win11: 资源管理器 -> 选项 -> 常规 -> 打开文件资源管理器时打开"此电脑"  
win11: 资源管理器 -> 选项 -> 查看 -> 高级设置 -> 导航窗格 -> 勾选"显示所有文件夹"

执行脚本 `win11_menu_switch.cmd`

# 日常软件

```
VC++运行库(`winget search Microsoft.VCRedist`, 或搜索"The latest supported Visual C++ downloads")
Office(用Office Tool Plus,搜kms.loli.beer)
AutoHotkey, Everything(Alpha版本)
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
`划词翻译`, `沉浸式翻译`, `Tampermonkey`, `WebRTC Protect`, `Vue.js devtools`

# 字体

[SarasaTermSC](https://github.com/be5invis/Sarasa-Gothic)
> 注: Sarasa Fixed无连字, Mono的中文破折号更美观但表格对不齐

[MapleMonoNormalNL-NF-CN](https://github.com/subframe7536/maple-font)

# RIME输入法

1. 下载[RIME输入法](https://github.com/rime/weasel)
2. git clone [雾凇拼音](https://github.com/iDvel/rime-ice) 到 RIME 用户目录
3. 将配置文件放进 RIME 用户目录

# 开发软件

手动安装软件:  
`WezTerm(Nightly)`, `MobaXterm`,  
`VSCode`, `JetBrains Toolbox`,  
`Navicat(DeltaFoX)`, `Postman/Hoppscotch/ApiFox`, `Fiddler`,  
`WSL2`, `Docker`

安装配置 MSYS2 环境

1. 下载安装 MSYS2, 添加系统变量 Path: `C:\msys64\ucrt64\bin\` 和 `C:\msys64\usr\bin`
2. 使用 UCRT64 环境启动, 检查修改脚本并执行: `bash setup-windows.sh`(里面包含了`setup-msys2.sh`)

pacman 常用命令参考

```
升级所有软件: pacman -Syu
查询可用包: pacman -Ss xxx
安装包: pacman -Sy xxx
查询已安装包: pacman -Qe 或 -Qs
删除包及相关无用依赖: pacman -Rs xxx
清理下载缓存: pacman -Sc
```
