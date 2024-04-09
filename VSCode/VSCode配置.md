# <center>VSCode配置</center>

# 插件

通用
| 插件名              | 功能                   |
| ------------------- | ---------------------- |
| Vim                 | Vim支持                |
| Bookmarks           | 书签                   |
| Translation         | 翻译                   |
| IntelliCode         | 代码提示               |
| Git History         | Git历史                |
| LaTeX Workshop      | LaTeX与PDF支持         |
| Open in Application | 默认程序打开文件       |
| Live Share          | 实时共享               |
| Remote Development  | WSL/容器/SSH的远程开发 |

Markdown及笔记
| 插件名                    | 功能                 |
| ------------------------- | -------------------- |
| Markdown Preview Enhanced | Markdown集成功能     |
| Markdown Table            | Markdown表格输入增强 |
| Paste Image               | Markdown图片复制增强 |
| vscode-mindmap(oorzc)     | Mindmap              |
| Draw.io Integration       | 图表编辑(.drawio)    |

Java
| 插件名                             | 功能         |
| ---------------------------------- | ------------ |
| Extension Pack for Java            | Java支持     |
| Spring Boot Extension Pack         | Spring支持   |
| SonarLint                          | 代码检查     |
| XML, YAML                          | 配置格式支持 |
| Tools for MicroProfile, Quarkus... | 其他可选     |

前端
| 插件名                           | 功能     |
| -------------------------------- | -------- |
| JavaScript (ES6) code snippets   | 代码提示 |
| Vue-Official                     | Vue前端  |
| Vue VSCode Snippets              | 代码提示 |
| ESLint                           | 代码检查 |
| Prettier                         | 代码格式 |
| Live Server                      | 网页服务 |
| Auto Rename Tag                  | 标签更改 |
| Html CSS Support                 | CSS支持  |
| IntelliSense for CSS class names | CSS提示  |
| CSS Peek                         | CSS预览  |

Python
| 插件名          | 功能       |
| --------------- | ---------- |
| Python          | Python支持 |
| Pylance         | 代码提示   |
| Python Debugger | 调试       |
| isort           | 依赖整理   |
| Jupyter         | 代码交互   |
| Python Indent   | 缩进       |
| autoDocstring   | 文档格式   |

容器
| 插件名     | 功能         |
| ---------- | ------------ |
| Docker     | 容器支持     |
| Kubernetes | 容器编排支持 |

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
    "[jsonc]": { "editor.defaultFormatter": "vscode.json-language-features" },
    "json.format.keepLines": true,
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
        { "before": [ "<C-q>" ], "after": [ "<C-x>" ] },
        { "before": [ "H" ], "after": [ "^" ] },
        { "before": [ "L" ], "after": [ "$" ] },
        { "before": [ "g", "f" ], "commands": [ "workbench.action.gotoSymbol" ] },
        { "before": [ "g", "i" ], "commands": [ "editor.action.goToImplementation" ] },
        { "before": [ "<leader>", "a", "f" ], "commands": [ "editor.action.organizeImports", "editor.action.formatDocument" ] },
        { "before": [ "<leader>", "a", "n" ], "commands": [ "editor.action.rename" ] },
        { "before": [ "<leader>", "a", "p" ], "commands": [ "editor.action.showContextMenu" ] },
        { "before": [ "<leader>", "a", "r" ], "commands": [ "editor.action.refactor" ] },
        { "before": [ "<leader>", "d", "b" ], "commands": [ "editor.debug.action.toggleBreakpoint" ] },
        { "before": [ "<leader>", "m", "m" ], "commands": [ "bookmarks.toggle" ] },
        { "before": [ "<leader>", "m", "e" ], "commands": [ "bookmarks.toggleLabeled" ] },
        { "before": [ "<leader>", "m", "s" ], "commands": [ "bookmarks.list" ] },
        { "before": [ "<leader>", "w", "p" ], "commands": [ "workbench.action.toggleSidebarVisibility" ] },
        { "before": [ "<leader>", "w", "r" ], "commands": [ "workbench.action.quickOpen" ] },
        { "before": [ "<leader>", "w", "w" ], "commands": [ "workbench.action.closeActiveEditor" ] },
        { "before": [ "<leader>", "w", "o" ], "commands": [ "workbench.action.closeOtherEditors" ] },
        { "before": [ "<leader>", "w", "c" ], "commands": [ "workbench.action.toggleCenteredLayout" ] },
        { "before": [ "<leader>", "w", "t" ], "commands": [ "translation.translate" ] },
    ],
    "vim.visualModeKeyBindings": [
        { "before": [ "H" ], "after": [ "^" ] },
        { "before": [ "L" ], "after": [ "$" ] },
        { "before": [ ">" ], "commands": [ "editor.action.indentLines" ] },
        { "before": [ "<" ], "commands": [ "editor.action.outdentLines" ] },
        { "before": [ "<leader>", "a", "r" ], "commands": [ "editor.action.refactor" ] },
    ],
    "vim.insertModeKeyBindingsNonRecursive": [
        { "before": [ "j", "k" ], "after": [ "<Esc>" ] },
        { "before": [ "<Esc>" ], "after": [ "<Esc>", "a" ] },
    ],
    "vim.operatorPendingModeKeyBindings": [
        { "before": [ "H" ], "after": [ "^" ] },
        { "before": [ "L" ], "after": [ "$" ] },
    ],
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