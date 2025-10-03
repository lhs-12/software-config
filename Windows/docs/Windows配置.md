# <center>Windows 环境设置</center>

# 基础设置

win11: 资源管理器 -> 选项 -> 常规 -> 打开文件资源管理器时打开"此电脑"  
win11: 资源管理器 -> 选项 -> 查看 -> 高级设置 -> 导航窗格 -> 勾选"显示所有文件夹"

执行脚本 `win11_menu_switch.cmd`

# 日常软件

```
等宽字体: 更纱黑体(https://github.com/be5invis/Sarasa-Gothic)
Nerd字体: Maple Mono(https://github.com/subframe7536/maple-font)
VC++运行库(`winget search Microsoft.VCRedist`, 或搜索"The latest supported Visual C++ downloads")
Office(用Office Tool Plus,搜kms.loli.beer)
AutoHotkey, Everything(Alpha版本)
PixPin(仅保留截图和贴图快捷键: F1,F3)
360压缩, RIME输入法, 有道翻译
网盘: 百度, 阿里, 夸克
网易云音乐, PotPlayer
微信, QQ
Notion
Z-Library + Koodo-Reader
系统美化: TranslucentTB(透明化任务栏) + material-design-cursors(鼠标光标主题) + (个性化->颜色->深色)
```

浏览器插件:  
`AdBlock`, `Dark Mode`, `Vimium`, `Xget Now`, `PageTurn Book Reader`,  
`划词翻译`, `沉浸式翻译`, `篡改候`, `Vue.js devtools`

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
