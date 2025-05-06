# <center>VSCode配置</center>

# 插件

```bash
# 使用Vim编辑以下文本并使用Bash执行
# 编辑命令:g/^s*$\|^#.*/d | %s/\\.*/\\/

code \
# 通用
--install-extension asvetliakov.vscode-neovim \                       # VSCode Neovim                       NeoVim合成扩展
--install-extension alefragnani.bookmarks \                           # Bookmarks                           书签
--install-extension visualstudioexptteam.vscodeintellicode \          # IntelliCode                         代码提示
--install-extension donjayamanne.githistory \                         # Git History                         Git历史
--install-extension james-yu.latex-workshop \                         # LaTeX Workshop                      LaTeX与PDF支持
--install-extension fabiospampinato.vscode-open-in-application \      # Open in Application                 默认程序打开文件
--install-extension ms-vscode-remote.vscode-remote-extensionpack \    # Remote Development                  远程开发套件(WSL/容器/SSH...)
--install-extension ms-vsliveshare.vsliveshare \                      # Live Share                          实时共享
--install-extension mark-wiemer.vscode-autohotkey-plus-plus \         # AutoHotkey Plus Plus                AutoHotkey支持
--install-extension johnnymorganz.stylua \                            # StyLua                              Lua支持
--install-extension tamasfe.even-better-toml \                        # Even Better TOML                    TOML支持
--install-extension redis.redis-for-vscode \                          # Redis for VS Code                   Redis

# Markdown及笔记
--install-extension shd101wyy.markdown-preview-enhanced \             # Markdown Preview Enhanced           Markdown功能集成
--install-extension takumii.markdowntable \                           # Markdown Table                      Markdown表格输入
--install-extension mushan.vscode-paste-image \                       # Paste Image                         Markdown图片复制
--install-extension oorzc.mind-map \                                  # vscode-mindmap(oorzc)               Mindmap支持
--install-extension hediet.vscode-drawio \                            # Draw.io Integration                 图表编辑(.drawio)
--install-extension pomdtr.excalidraw-editor \                        # Excalidraw                          图表编辑(.excalidraw)
--install-extension ms-toolsai.jupyter \                              # Jupyter                             Jupyter套件

# 容器
--install-extension ms-azuretools.vscode-containers \                 # 容器                                容器支持
--install-extension ms-kubernetes-tools.vscode-kubernetes-tools \     # Kubernetes                          容器编排支持

# 前端
--install-extension xabikos.javascriptsnippets \                      # JavaScript (ES6) code snippets      代码提示
--install-extension vue.volar \                                       # Vue-Official                        Vue支持
--install-extension sdras.vue-vscode-snippets \                       # Vue VSCode Snippets                 代码提示
--install-extension dbaeumer.vscode-eslint \                          # ESLint                              代码检查
--install-extension esbenp.prettier-vscode \                          # Prettier                            代码格式
--install-extension ms-vscode.live-server \                           # Live Preview                        实时网页
--install-extension formulahendry.auto-rename-tag \                   # Auto Rename Tag                     标签更改
--install-extension ecmel.vscode-html-css \                           # Html CSS Support                    CSS支持
--install-extension zignd.html-css-class-completion \                 # IntelliSense for CSS class names    CSS提示
--install-extension pranaygp.vscode-css-peek \                        # CSS Peek                            CSS预览

# Java
--install-extension vscjava.vscode-java-pack \                        # Extension Pack for Java             Java支持
--install-extension vmware.vscode-boot-dev-pack \                     # Spring Boot Extension Pack          Spring支持
--install-extension redhat.vscode-xml \                               # XML                                 XML支持
--install-extension redhat.fabric8-analytics \                        # Red Hat Dependency Analytics        依赖分析
# 其他可选: SonarLint, Tools for MicroProfile, Quarkus...

# Python
--install-extension ms-python.python \                                # Python                              Python支持
--install-extension charliermarsh.ruff \                              # Ruff                                格式化
--install-extension kevinrose.vsc-python-indent \                     # Python Indent                       缩进
--install-extension njpwerner.autodocstring \                         # autoDocstring                       文档格式
```

# 配置

快捷键配置: keybindings.json
```json
[
  // 打开命令
  { "key": "ctrl+shift+a", "command": "workbench.action.showCommands" },
  // 换行
  { "key": "shift+Enter", "command": "editor.action.insertLineAfter", "when": "editorTextFocus && !editorReadonly" },
  // 打开类
  { "key": "ctrl+n", "command": "workbench.action.showAllSymbols" },
  // Quick Fix
  { "key": "alt+enter", "command": "editor.action.quickFix", "when": "editorHasCodeActionsProvider && editorTextFocus && !editorReadonly" },
  // 代码生成
  { "key": "alt+insert", "command": "editor.action.sourceAction", "when": "editorHasCodeActionsProvider && editorTextFocus && !editorReadonly" },
  // NeoVim
  { "key": "ctrl+alt+k", "command": "vscode-neovim.stop", "when": "neovim.init" },
  { "key": "ctrl+alt+k", "command": "vscode-neovim.restart", "when": "!neovim.init" }
]
```

VSCode配置: settings.json
```json
{
  "files.autoSave": "onFocusChange",
  "notebook.formatOnSave.enabled": true,
  "explorer.compactFolders": false,
  "workbench.startupEditor": "none",
  "workbench.layoutControl.enabled": false,
  "window.commandCenter": false,
  "editor.fontFamily": "'Sarasa Term SC Regular','Maple Mono NF CN'",
  "editor.fontSize": 15,
  "editor.mouseWheelZoom": true,
  "editor.smoothScrolling": true,
  "editor.minimap.enabled": false,
  "editor.lineNumbers": "relative",
  "editor.wordSeparators": "`~!@#$%^&*()=+[{]}\\|;:'\",.<>/?。，；：“”‘’、！（）", // 去掉英文-, 增加中文符号
  "debug.showBreakpointsInOverviewRuler": true,
  // Markdown
  "markdown-preview-enhanced.enablePreviewZenMode": true, // 去除多余预览功能
  "markdown-preview-enhanced.hideDefaultVSCodeMarkdownPreviewButtons": false, // 取消劫持默认markdown预览
  "markdown-preview-enhanced.breakOnSingleNewLine": false, // 要求Markdown行末两空格表示换行
  "markdown-preview-enhanced.printBackground": true, // 导出时使用preview的css
  "markdown-preview-enhanced.previewTheme": "github-dark.css",
  "markdown-preview-enhanced.mermaidTheme": "dark",
  "markdown-preview-enhanced.revealjsTheme": "blood.css",
  "markdown-preview-enhanced.plantumlJarPath": "D:/Program Files/tools/plantuml.jar",
  "pasteImage.path": "${currentFileDir}/pictures/${currentFileNameWithoutExt}/",
  "pasteImage.defaultName": "x",
  // 画图
  "hediet.vscode-drawio.appearance": "dark",
  "excalidraw.theme": "dark",
  "excalidraw.language": "zh-CN",
  // 格式化配置
  "editor.defaultFormatter": "esbenp.prettier-vscode",
  "prettier.configPath": "C:/Users/L/.prettierrc",
  "[html]": { "files.autoSave": "off", "editor.formatOnSave": true },
  "[javascript]": { "files.autoSave": "off", "editor.formatOnSave": true },
  "[typescript]": { "files.autoSave": "off", "editor.formatOnSave": true },
  "[css]": { "files.autoSave": "off", "editor.formatOnSave": true },
  "[less]": { "files.autoSave": "off", "editor.formatOnSave": true },
  "[vue]": { "files.autoSave": "off", "editor.formatOnSave": true },
  "[toml]": { "editor.defaultFormatter": "tamasfe.even-better-toml" },
  "[lua]": { "editor.defaultFormatter": "JohnnyMorganz.stylua" },
  "[java]": { "editor.defaultFormatter": "redhat.java" },
  "[python]": { "editor.defaultFormatter": "charliermarsh.ruff", "editor.formatOnSave": true },
  "ruff.configuration": "${env:USERPROFILE}/ruff.toml",
  // NeoVim
  "extensions.experimental.affinity": { "asvetliakov.vscode-neovim": 1 },
  "vscode-neovim.ctrlKeysForInsertMode": ["d", "o", "r", "t", "u", "w"],
  "vscode-neovim.ctrlKeysForNormalMode": /*prettier-ignore*/ [ // 保留 c, n, s, x, z
    "a", "b", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "o", "p", "q", "r", "t", "u", "v", "w", "y",
    "up", "right", "left", "down", "backspace", "delete", "]",
  ]
}
```

安装NeoVim, 配置文件
```lua
-- %LOCALAPPDATA%/nvim/init.lua
if not vim.g.vscode then
  require("vscode-nvim")
  return
end
-- ...other config

-- %LOCALAPPDATA%/nvim/lua/vscode-nvim/init.lua
---@diagnostic disable-next-line: undefined-global
local vim = vim
if not vim.g.vscode then return end
local vscode = require('vscode')
local keymap = vim.keymap.set
local opts = { noremap = true, silent = true }
vim.g.mapleader = " "
keymap('n', '<esc>', '<cmd>noh<cr><esc>', opts)
keymap('n', 'x', '"_x', opts)
keymap('n', 'X', '"_X', opts)
keymap('n', '<C-q>', '<C-x>', opts)
keymap('n', 'H', function() vscode.call('workbench.action.previousEditor') end, opts)
keymap('n', 'L', function() vscode.call('workbench.action.nextEditor') end, opts)
keymap('n', 'K', function() vscode.call('editor.action.showHover') end, opts)
keymap('n', 'cd', function() vscode.call('editor.action.rename') end, opts)
keymap('v', '>', function() vscode.call('editor.action.indentLines') end, opts)
keymap('v', '<', function() vscode.call('editor.action.outdentLines') end, opts)
keymap('v', 'af', function() vscode.call('editor.action.smartSelect.grow') end, opts)
keymap('v', 'AF', function() vscode.call('editor.action.smartSelect.shrink') end, opts)

keymap('n', 'gf', function() vscode.call('workbench.action.gotoSymbol') end, opts)
keymap('n', 'gi', function() vscode.call('editor.action.goToImplementation') end, opts)
keymap('n', 'gp', function() vscode.call('workbench.explorer.fileView.focus') end, opts)
keymap('n', 'gy', function() vscode.call('editor.action.goToTypeDefinition') end, opts)
keymap('n', 'ge', function() vscode.call('remote-wsl.revealInExplorer') end, opts)

keymap('n', '<leader>af', function() vscode.call('editor.action.organizeImports') vscode.call('editor.action.formatDocument') end, opts)
keymap({'n', 'v'}, '<leader>ai', function() vscode.call('editor.action.quickFix') end, opts)
keymap({'n', 'v'}, '<leader>ap', function() vscode.call('editor.action.showContextMenu') end, opts)
keymap({'n', 'v'}, '<leader>ar', function() vscode.call('editor.action.refactor') end, opts)

keymap('n', '<leader>db', function() vscode.call('editor.debug.action.toggleBreakpoint') end, opts)

keymap('n', '<leader>mm', function() vscode.call('bookmarks.toggle') end, opts)
keymap('n', '<leader>me', function() vscode.call('bookmarks.toggleLabeled') end, opts)
keymap('n', '<leader>ms', function() vscode.call('bookmarks.listFromAllFiles') end, opts)

keymap('n', '<leader>wp', function() vscode.call('workbench.action.toggleSidebarVisibility') end, opts)
keymap('n', '<leader>wr', function() vscode.call('workbench.action.quickOpen') end, opts)
keymap('n', '<leader>wo', function() vscode.call('workbench.action.closeOtherEditors') end, opts)
keymap('n', '<leader>ww', function() vscode.call('workbench.action.closeActiveEditor') end, opts)
keymap('n', '<leader>wz', function() vscode.call('workbench.action.toggleZenMode') end, opts)
keymap('n', '<leader>wf', function() vscode.call('workbench.action.toggleFullScreen') end, opts)
keymap('n', '<leader>wc', function() vscode.call('workbench.action.toggleCenteredLayout') end, opts)
-- keymap('v', '<leader>wt', function() vscode.call('translation.translate') end, opts)

vim.api.nvim_create_autocmd("FileType", {
  pattern = "java",
  callback = function()
    vim.keymap.set('n', 'gs', function()
      vscode.call('java.action.navigateToSuperImplementation')
    end, { noremap = true, silent = true, buffer = true })
  end,
})

keymap('n', '<leader>?', function()
  vim.cmd("e $LOCALAPPDATA/nvim/lua/vscode-nvim/init.lua")
  vim.bo.modifiable = false
  vim.bo.readonly = true
end, opts)

vim.opt.ignorecase = true
vim.opt.smartcase = true

local leap_path = vim.fn.stdpath("config") .. "/lua/vscode-nvim/leap.nvim"
if vim.fn.isdirectory(leap_path) == 0 then
  vim.fn.system({ "git", "clone", "--depth=1", "https://github.com/ggandor/leap.nvim.git", leap_path })
end
vim.opt.rtp:append(leap_path)
vim.keymap.set({ 'n', 'x', 'o' }, 's', function()
  require('leap').leap({ target_windows = { vim.api.nvim_get_current_win() } })
end)
```

LaTeX Workshop 配置, 按需添加
```json
{
  // LaTeX Workshop 的配置
  // 打开标签页进行pdf预览
  "latex-workshop.view.pdf.viewer": "tab",
  // 关闭自动编译
  "latex-workshop.latex.autoBuild.run": "never",
  // 编译工具配置(这里是为了加入xelatex配置, 其他与默认值保持一致)
  "latex-workshop.latex.tools": [
    {
      "name": "latexmk",
      "command": "latexmk",
      "args": ["-synctex=1", "-interaction=nonstopmode", "-file-line-error", "-pdf", "-outdir=%OUTDIR%", "%DOC%"],
      "env": {}
    },
    {
      "name": "xelatex",
      "command": "xelatex",
      "args": ["-synctex=1", "-interaction=nonstopmode", "-file-line-error", "%DOC%"]
    },
    {
      "name": "pdflatex",
      "command": "pdflatex",
      "args": ["-synctex=1", "-interaction=nonstopmode", "-file-line-error", "%DOC%"],
      "env": {}
    },
    {
      "name": "bibtex",
      "command": "bibtex",
      "args": ["%DOCFILE%"],
      "env": {}
    }
  ],
  // 编译组合配置(这里是为了加入xelatex配置, 其他配置与默认值保持一致)
  "latex-workshop.latex.recipes": [
    { "name": "xelatex", "tools": ["xelatex"] },
    { "name": "latexmk", "tools": ["latexmk"] },
    { "name": "pdflatex -> bibtex -> pdflatex*2", "tools": ["pdflatex", "bibtex", "pdflatex", "pdflatex"] }
  ]
}
```

Prettier配置文件
```json
{
  "useTabs": false,
  "tabWidth": 2,
  "printWidth": 120
}
```

Ruff配置文件
```toml
line-length = 120
indent-width = 4
target-version = "py312"

[lint]
select = ["F", "E", "W", "A", "PLC", "PLE", "PLW", "I", "UP", "B", "SIM"]
ignore = []
```

修改主题：执行命令 Markdown Preview Enhanced: Customize CSS(Global)
```css
/* https://shd101wyy.github.io/markdown-preview-enhanced/#/customize-css */
.markdown-preview.markdown-preview {
  font-family: "Sarasa Term SC Regular";
  font-size: 18px;
  line-height: 1.4;
  background-color: #181818;
  /*prettier-ignore*/
  h1, h2, h3, h4, h5, h6, strong, table th, code, kbd { 
    color: #d1d1d1;
  }
  pre {
    background-color: #262626 !important;
  }
  code {
    font-family: "Sarasa Term SC Regular";
    display: inline-block;
    font-size: 16px;
    line-height: 1.2;
  }
}
```

可选配置: Markdown渲染折叠显示内容: Markdown Preview Enhanced: Extend Parser(Workspace)
```js
  // 修改parser.js文件
  onDidParseMarkdown: async function (html) {
    const regex = /<h3([^>]*)>([^<]*)<\/h3>([\s\S]*?)(?=<h|$)/gi;
    return html.replace(regex, (_, attrs, content, nextContent) => {
      return `<details><summary><h3 style="display:inline"${attrs}>${content}</h3></summary><br>\n${nextContent.trim()}\n</details><br>`;
    });
  },
  // 修改style.less: font-family: '仓耳华新体'; font-size: 20px;
```
