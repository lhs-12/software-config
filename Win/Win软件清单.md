# <center>Win10软件清单</center>

# 基本软件
```
VC++运行库(搜"The latest supported Visual C++ downloads")
Office(用Office Tool Plus,搜kms.loli.beer)
字体(sarasa-mono/term-sc-regular/semi, JetBrainsMono Nerd Font, Noto Mono)
RIME输入法
gsudo
360压缩
Snipaste
Everything
Notion
百度网盘
网易云音乐
PotPlayer
微信,QQ
系统美化: TranslucentTB(透明化任务栏) + material-design-cursors(鼠标光标主题) + (个性化->颜色->深色)
```

# 开发软件
```
Git
WSL2
VSCode
JetBrains Toolbox -> IDEA
MobaXterm
Navicat(DeltaFoX)
RedisDesktopManager(Github找安装包)
Node.js
Docker
ApiFox/Postman
AutoHotkey
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

# 脚本

Windows11新旧右键菜单切换
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