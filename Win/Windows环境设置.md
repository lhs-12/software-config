# <center>Windows 环境设置</center>

# 基础设置

win11: 资源管理器 -> 选项 -> 常规 -> 打开文件资源管理器时打开"此电脑"  
win11: 资源管理器 -> 选项 -> 查看 -> 高级设置 -> 导航窗格 -> 勾选"显示所有文件夹"

执行脚本 `Win11切换右键菜单.cmd`

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
微信,QQ
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

将配置文件`.wezterm.lua`放到`%HOMEPATH%`中

---

MSYS2 环境及软件安装

```bash
# 1. 下载安装MSYS2, 添加Windows系统变量Path: C:\msys64\usr\bin 和 C:\msys64\ucrt64\bin\
# 2. 使用UCRT64环境启动
# 3. 更换清华源(https://mirror.tuna.tsinghua.edu.cn/help/msys2/)
sed -i "s#https\?://mirror.msys2.org/#https://mirrors.tuna.tsinghua.edu.cn/msys2/#g" /etc/pacman.d/mirrorlist*
# 4. 安装基础工具
pacman -Syu
pacman -S --needed base-devel mingw-w64-ucrt-x86_64-toolchain
pacman -S --needed mingw-w64-ucrt-x86_64-ca-certificates && update-ca-trust
pacman -S --needed fish zip unzip \
mingw-w64-ucrt-x86_64-{neovim,lsd,bat,zoxide,dust,python-tldr} \
mingw-w64-ucrt-x86_64-{yazi,ffmpeg,jq,imagemagick,mdbook} \
mingw-w64-ucrt-x86_64-{fzf,fd,ripgrep,bottom}
# 5. 安装配置Git
pacman -S --needed git
# 安装Git LFS
pacman -S mingw-w64-ucrt-x86_64-git-lfs && git lfs install
# 安装Git Credential Manager(建议先检查文件是否正确)
curl -L -o gcm-latest.zip $(curl -s https://api.github.com/repos/git-ecosystem/git-credential-manager/releases/latest | \
jq -r '.assets[] | select(.name | test("gcm-win-x86-(?!.*symbols).*\\.zip$")) | .browser_download_url') \
&& unzip -q -d /ucrt64/libexec/git-core/ gcm-latest.zip && rm gcm-latest.zip
# 配置Git
git config --global init.defaultBranch main
git config --global core.autocrlf true
git config --global core.editor "nvim --clean"
git config --global user.name "xxx"
git config --global user.email "xxx@xxx.com"
git config --global http.proxy "http://127.0.0.1:10808"
git config --global https.proxy "http://127.0.0.1:10808"
git config --global credential.helper "/ucrt64/libexec/git-core/git-credential-manager.exe"
# 6. 安装配置Python环境(UV)
pacman -S --needed mingw-w64-ucrt-x86_64-uv
uv tool install ruff@latest

# todo: Node.js, Mise

# 升级所有软件: pacman -Syu
# 查询可用包: pacman -Ss xxx
# 安装包: pacman -Sy xxx
# 查询已安装包: pacman -Qe 或 -Qs
# 删除包及相关无用依赖: pacman -Rs xxx
# 清理下载缓存: pacman -Sc
```

修改 bashrc 配置(MSYS2-UCRT64 环境)

```bashrc
export PATH="/d/Program Files/tools:$PATH" # 验证: echo $PATH |tr ':' '\n'
export PATH="$(cygpath -u "$(uv tool dir --bin)"):$PATH"
eval "$(zoxide init bash)"
alias ls='lsd'
alias la='lsd -a'
alias ll='lsd --long --header'
alias less='bat'
alias cat='bat --paging=never'
alias vi='nvim --clean'
alias vim='nvim'
alias yz='yazi'
alias cdg='cd_g() { cd $(fd --type directory $1 $2 | fzf);}; cd_g'
alias fdns='ipconfig -flushdns'
alias sva='source .venv/Scripts/activate'
```

yazi 配置

```toml
# mkdir -p $APPDATA/yazi/config
# vi $APPDATA/yazi/config/yazi.toml
[open]
append_rules = [{ name = "*/", use = ["open", "edit"], for = "windows" }]

[opener]
edit = [{ desc = "NeoVim", for = "windows", block = true, run = 'nvim %*' }]
play = [{ desc = "PotPlayer", for = "windows", orphan = true, run = '"C:/Program Files/DAUM/PotPlayer/PotPlayerMini64.exe" %0' }]
open = [
    { desc = "Open", for = "windows", orphan = true, run = 'start "" "%1"' },
    { desc = "VSCode", for = "windows", orphan = true, run = 'code %*' },
    { desc = "PotPlayer", for = "windows", orphan = true, run = '"C:/Program Files/DAUM/PotPlayer/PotPlayerMini64.exe" %0' },
]

[plugin]
prepend_previewers = [{ mime = "video/*", run = "noop" }]

# 执行命令: ya pkg add kmlupreti/ayu-dark
# vi $APPDATA/yazi/config/theme.toml
[flavor]
dark = "ayu-dark"
```
