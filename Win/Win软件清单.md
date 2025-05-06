# <center>Win10软件清单</center>

# 基本软件
```
等宽字体: 更纱黑体(https://github.com/be5invis/Sarasa-Gothic)
Nerd字体: Maple Mono(https://github.com/subframe7536/maple-font)
VC++运行库(`winget search Microsoft.VCRedist`, 或搜索"The latest supported Visual C++ downloads")
Office(用Office Tool Plus,搜kms.loli.beer)
RIME输入法
360压缩
Snipaste
Everything Alpha版本
Notion
百度网盘, 夸克网盘, 阿里网盘
网易云音乐
PotPlayer
Z-Library + Koodo-Reader
AutoHotkey
微信,QQ
系统美化: TranslucentTB(透明化任务栏) + material-design-cursors(鼠标光标主题) + (个性化->颜色->深色)
```

# 开发软件
```
Git
WezTerm, MobaXterm
WSL2
Docker
VSCode, JetBrains Toolbox
Navicat(DeltaFoX), RedisInsight, ApiFox/Postman/Hoppscotch
UV(Python)
Node.js

winget install lsd-rs.lsd tldr-pages.tlrc ajeetdsouza.zoxide bootandy.dust \
Neovim.Neovim  junegunn.fzf BurntSushi.ripgrep.MSVC sharkdp.fd

修改配置 vi ~/.bashrc
eval "$(zoxide init bash)"
alias ls='lsd'
```

# 浏览器插件
```
AdBlock
Dark Mode
Vimium
划词翻译
沉浸式翻译
篡改候
Vue.js devtools
```

# 设置

win11: 资源管理器 -> 选项 -> 常规 -> 打开文件资源管理器时打开"此电脑"  
win11: 资源管理器 -> 选项 -> 查看 -> 高级设置 -> 导航窗格 -> 勾选"显示所有文件夹"

---

执行Windows11新旧右键菜单切换脚本
```bat
@echo off
title Windows 11 新旧右键菜单切换

>NUL 2>&1 REG.exe query "HKU\S-1-5-19" || (
    ECHO SET UAC = CreateObject^("Shell.Application"^) > "%TEMP%\Getadmin.vbs"
    ECHO UAC.ShellExecute "%~f0", "%1", "", "runas", 1 >> "%TEMP%\Getadmin.vbs"
    "%TEMP%\Getadmin.vbs"
    DEL /f /q "%TEMP%\Getadmin.vbs" 2>NUL
    Exit /b
)

:menu
cls
echo ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
echo ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
echo.
echo 请选择项目: 
echo.&echo 【1】Win11转回旧版右键菜单
echo.&echo 【2】Win11恢复新版右键菜单
echo.&echo 请输入数字回车确认
echo.

set /p user_input=请输入数字:
if %user_input% equ 1 goto old
if %user_input% equ 2 goto new
echo 输入错误, 请重新输入数字.
pause
goto menu

:old
reg add "HKCU\Software\Classes\CLSID\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}\InprocServer32" /f /ve
taskkill /f /im explorer.exe & start explorer.exe
echo 已成功转到旧版右键菜单
pause
goto menu

:new
reg delete "HKCU\Software\Classes\CLSID\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}" /f
taskkill /f /im explorer.exe & start explorer.exe
echo 已成功恢复新版右键菜单
pause
goto menu
```