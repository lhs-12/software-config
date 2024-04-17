# <center>VSCode配置</center>

# 插件

```shell
# 对以下内容使用vi命令编辑, 并执行编辑后的结果. 命令:%s/\^.*/^/

code ^
# 通用
--install-extension vscodevim.vim ^                                   # Vim                                 Vim模拟器
--install-extension alefragnani.bookmarks ^                           # Bookmarks                           书签
--install-extension liwenkun.translation ^                            # Translation                         翻译
--install-extension visualstudioexptteam.vscodeintellicode ^          # IntelliCode                         代码提示
--install-extension donjayamanne.githistory ^                         # Git History                         Git历史
--install-extension james-yu.latex-workshop ^                         # LaTeX Workshop                      LaTeX与PDF支持
--install-extension fabiospampinato.vscode-open-in-application ^      # Open in Application                 默认程序打开文件
--install-extension ms-vscode-remote.vscode-remote-extensionpack ^    # Remote Development                  远程开发套件(WSL/容器/SSH...)
--install-extension ms-vsliveshare.vsliveshare ^                      # Live Share                          实时共享

# Markdown及笔记
--install-extension shd101wyy.markdown-preview-enhanced ^             # Markdown Preview Enhanced           Markdown功能集成
--install-extension takumii.markdowntable ^                           # Markdown Table                      Markdown表格输入
--install-extension mushan.vscode-paste-image ^                       # Paste Image                         Markdown图片复制
--install-extension oorzc.mind-map ^                                  # vscode-mindmap(oorzc)               Mindmap支持
--install-extension hediet.vscode-drawio ^                            # Draw.io Integration                 图表编辑(.drawio)
--install-extension ms-toolsai.jupyter ^                              # Jupyter                             Jupyter套件

# 容器
--install-extension ms-azuretools.vscode-docker ^                     # Docker                              容器支持
--install-extension ms-kubernetes-tools.vscode-kubernetes-tools ^     # Kubernetes                          容器编排支持

# 前端
--install-extension xabikos.javascriptsnippets ^                      # JavaScript (ES6) code snippets      代码提示
--install-extension vue.volar ^                                       # Vue-Official                        Vue支持
--install-extension sdras.vue-vscode-snippets ^                       # Vue VSCode Snippets                 代码提示
--install-extension dbaeumer.vscode-eslint ^                          # ESLint                              代码检查
--install-extension esbenp.prettier-vscode ^                          # Prettier                            代码格式
--install-extension ritwickdey.liveserver ^                           # Live Server                         实时网页
--install-extension formulahendry.auto-rename-tag ^                   # Auto Rename Tag                     标签更改
--install-extension ecmel.vscode-html-css ^                           # Html CSS Support                    CSS支持
--install-extension zignd.html-css-class-completion ^                 # IntelliSense for CSS class names    CSS提示
--install-extension pranaygp.vscode-css-peek ^                        # CSS Peek                            CSS预览

# Java
--install-extension vscjava.vscode-java-pack ^                        # Extension Pack for Java             Java支持
--install-extension vmware.vscode-boot-dev-pack ^                     # Spring Boot Extension Pack          Spring支持
--install-extension redhat.vscode-xml ^                               # XML                                 XML支持
--install-extension redhat.vscode-yaml ^                              # YAML                                YAML支持
# 其他可选: SonarLint, Tools for MicroProfile, Quarkus...

# Python
--install-extension ms-python.python ^                                # Python                              Python支持
--install-extension ms-python.isort ^                                 # isort                               依赖整理
--install-extension kevinrose.vsc-python-indent ^                     # Python Indent                       缩进
--install-extension njpwerner.autodocstring ^                         # autoDocstring                       文档格式
```

# 配置

快捷键配置: keybindings.json
```json
[
    // 打开命令
    { "key": "ctrl+shift+a", "command": "workbench.action.showCommands" },
    // 新建文件
    { "key": "alt+insert", "command": "workbench.action.files.newUntitledFile", "when": "!editorTextFocus || editorTextFocus && !editorHasCodeActionsProvider" },
    // 替换
    { "key": "ctrl+r", "command": "editor.action.startFindReplaceAction", "when": "editorFocus || editorIsOpen" },
    { "key": "ctrl+shift+r", "command": "workbench.action.replaceInFiles" },
    // 切换Vim
    { "key": "ctrl+alt+k", "command": "toggleVim" },
    // 插入换行
    { "key": "shift+Enter", "command": "editor.action.insertLineAfter", "when": "editorTextFocus && !editorReadonly" },
    // 注释后换行
    { "key": "ctrl+/", "command": "runCommands", "args": { "commands": [ "editor.action.commentLine", "cursorDown" ] }, "when": "editorTextFocus" },
    // 打开类
    { "key": "ctrl+n", "command": "workbench.action.showAllSymbols" },
    // Quick Fix
    { "key": "alt+enter", "command": "editor.action.quickFix", "when": "editorHasCodeActionsProvider && editorTextFocus && !editorReadonly" },
    // 代码生成
    { "key": "alt+insert", "command": "editor.action.sourceAction", "when": "editorHasCodeActionsProvider && editorTextFocus && !editorReadonly" },
]
```

VSCode配置: settings.json
```json
{
    // "editor.formatOnSave": true,    // files.autoSave 为 onFocusChange 时关闭该配置
    "files.autoSave": "onFocusChange", // 前端开发时注释该配置, 并打开 editor.formatOnSave

    "explorer.compactFolders": false,
    "workbench.layoutControl.enabled": false,
    "window.commandCenter": false,
    // 等宽字体: 更纱黑体(https://github.com/be5invis/Sarasa-Gothic)
    // Nerd字体: JetBrainsMono Nerd(https://github.com/ryanoasis/nerd-fonts/tree/master/patched-fonts/JetBrainsMono)
    "editor.fontFamily": "'Sarasa Term SC Regular','JetBrainsMono Nerd Font'",
    "editor.mouseWheelZoom": true,
    "editor.minimap.enabled": false,
    "editor.wordSeparators": "`~!@#$%^&*()=+[{]}\\|;:'\",.<>/?。，；：“”‘’、！（）", // 去掉英文-, 增加中文符号
    // Markdown
    "markdown-preview-enhanced.enablePreviewZenMode": true, // 去除多余预览功能
    "markdown-preview-enhanced.hideDefaultVSCodeMarkdownPreviewButtons": false, // 取消劫持默认markdown预览
    "markdown-preview-enhanced.breakOnSingleNewLine": false, // 要求Markdown行末两空格表示换行
    "markdown-preview-enhanced.printBackground": true, // 导出时使用preview的css
    "markdown-preview-enhanced.previewTheme": "github-dark.css",
    "markdown-preview-enhanced.mermaidTheme": "dark",
    "markdown-preview-enhanced.revealjsTheme": "blood.css",
    "markdown-preview-enhanced.plantumlJarPath": "D:/Program Files/tools/plantuml-1.2024.3.jar",
    "pasteImage.path": "${currentFileDir}/pictures/${currentFileNameWithoutExt}/",
    "pasteImage.defaultName": "x",
    // 格式化配置
    "editor.defaultFormatter": "esbenp.prettier-vscode",
    "prettier.configPath": "C:/Users/L/.prettierrc",
    "[java]": { "editor.defaultFormatter": "redhat.java" },
    // Vim
    "vim.smartRelativeLine": true,
    "vim.incsearch": true,
    "vim.hlsearch": true,
    "vim.visualstar": true,
    "vim.easymotion": true,
    "vim.replaceWithRegister": true,
    "vim.highlightedyank.enable": true,
    "vim.highlightedyank.color": "#32593d",
    "vim.highlightedyank.duration": 400,
    "extensions.experimental.affinity": { "vscodevim.vim": 1 },
    "vim.handleKeys": { "<C-x>": false, "<C-c>": false },
    "vim.leader": "<space>",
    "vim.normalModeKeyBindings": [
        { "before": ["<C-q>"], "after": ["<C-x>"] },
        { "before": ["H"], "after": ["^"] },
        { "before": ["L"], "after": ["$"] },
        { "before": ["g", "f"], "commands": ["workbench.action.gotoSymbol"] },
        { "before": ["g", "i"], "commands": ["editor.action.goToImplementation"] },
        { "before": ["<leader>", "a", "f"], "commands": ["editor.action.organizeImports", "editor.action.formatDocument"] },
        { "before": ["<leader>", "a", "n"], "commands": ["editor.action.rename"] },
        { "before": ["<leader>", "a", "p"], "commands": ["editor.action.showContextMenu"] },
        { "before": ["<leader>", "a", "r"], "commands": ["editor.action.refactor"] },
        { "before": ["<leader>", "d", "b"], "commands": ["editor.debug.action.toggleBreakpoint"] },
        { "before": ["<leader>", "m", "m"], "commands": ["bookmarks.toggle"] },
        { "before": ["<leader>", "m", "e"], "commands": ["bookmarks.toggleLabeled"] },
        { "before": ["<leader>", "m", "s"], "commands": ["bookmarks.list"] },
        { "before": ["<leader>", "w", "p"], "commands": ["workbench.action.toggleSidebarVisibility"] },
        { "before": ["<leader>", "w", "r"], "commands": ["workbench.action.quickOpen"] },
        { "before": ["<leader>", "w", "w"], "commands": ["workbench.action.closeActiveEditor"] },
        { "before": ["<leader>", "w", "o"], "commands": ["workbench.action.closeOtherEditors"] },
        { "before": ["<leader>", "w", "c"], "commands": ["workbench.action.toggleCenteredLayout"] },
        { "before": ["<leader>", "w", "t"], "commands": ["translation.translate"] }
    ],
    "vim.visualModeKeyBindings": [
        { "before": ["H"], "after": ["^"] },
        { "before": ["L"], "after": ["$"] },
        { "before": [">"], "commands": ["editor.action.indentLines"] },
        { "before": ["<"], "commands": ["editor.action.outdentLines"] },
        { "before": ["<leader>", "a", "r"], "commands": ["editor.action.refactor"] }
    ],
    "vim.operatorPendingModeKeyBindings": [
        { "before": ["H"], "after": ["^"] },
        { "before": ["L"], "after": ["$"] }
    ]
}

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
            "name": "latexmk", "command": "latexmk",
            "args": [ "-synctex=1", "-interaction=nonstopmode", "-file-line-error", "-pdf", "-outdir=%OUTDIR%", "%DOC%" ],
            "env": { }
        },
        {
            "name": "xelatex", "command": "xelatex",
            "args": [ "-synctex=1", "-interaction=nonstopmode", "-file-line-error", "%DOC%" ]
        },
        {
            "name": "pdflatex", "command": "pdflatex",
            "args": [ "-synctex=1", "-interaction=nonstopmode", "-file-line-error", "%DOC%" ],
            "env": { }
        },
        {
            "name": "bibtex", "command": "bibtex",
            "args": [ "%DOCFILE%" ],
            "env": { }
        }
    ],
    // 编译组合配置(这里是为了加入xelatex配置, 其他配置与默认值保持一致)
    "latex-workshop.latex.recipes": [
        { "name": "xelatex", "tools": [ "xelatex" ] },
        { "name": "latexmk", "tools": [ "latexmk" ] },
        { "name": "pdflatex -> bibtex -> pdflatex*2", "tools": [ "pdflatex", "bibtex", "pdflatex", "pdflatex" ] }
    ],
}
```

Prettier配置文件
```json
{
  "useTabs": false,
  "tabWidth": 4,
  "printWidth": 180,
  "singleQuote": true,
  "semi": true,
  "bracketSpacing": true
}
```

修改主题：执行命令 Markdown Preview Enhanced: Customize CSS(Global)
```css
.markdown-preview.markdown-preview {
  font-family: "Sarasa Term SC Regular";
  font-size: 18px;
  line-height: 1.4;
  background-color: #1e1e1e;
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