# <center>VSCode配置</center>

# 插件
|               插件名               | 功能                   |
| :--------------------------------: | ---------------------- |
|        Open in Application         | 默认程序打开文件       |
|     Visual Stuido IntelliCode      | 代码提示               |
|             Live Share             | 实时共享               |
|                Vim                 | Vim支持                |
|            Git History             | Git历史查看            |
|        Draw.io Integration         | 图表编辑(.drawio)      |
|       vscode-mindmap(oorzc)        | Mindmap                |
|     Markdown Preview Enhanced      | Markdown集成功能       |
|           Markdown Table           | Markdown表格输入增强   |
|            Paste Image             | Markdown图片复制增强   |
|               Docker               | Docker支持             |
|             Kubernetes             | Kubernetes支持         |
|         Remote Development         | WSL/容器/SSH的远程支持 |
| Python + Pylance + isort + Jupyter | Python支持             |
|           Volar + ESLint           | 前端支持               |
|             vscode-pdf             | PDF支持                |
|           LaTeX Workshop           | LaTeX与PDF支持         |

# 配置
VSCode配置: settings.json
```json
{
    "explorer.compactFolders": false,
    "workbench.iconTheme": "vscode-icons",
    "editor.fontFamily": "'Sarasa Term SC Regular'", // 中文等宽字体(https://github.com/be5invis/Sarasa-Gothic)
    "editor.mouseWheelZoom": true,
    "editor.minimap.enabled": false,
    // "editor.formatOnSave": true, // 不建议搭配files.autoSave为 onFocusChange 使用
    "files.autoSave": "onFocusChange", // 前端开发时建议注释该配置,并打开editor.formatOnSave
    "markdown-preview-enhanced.enablePreviewZenMode": true, // 去除多余预览功能
    "markdown-preview-enhanced.hideDefaultVSCodeMarkdownPreviewButtons": false, // 取消劫持默认markdown预览
    "markdown-preview-enhanced.breakOnSingleNewLine": false, // 要求Markdown行末两空格表示换行
    "markdown-preview-enhanced.printBackground": true, // 导出时使用preview的css
    "markdown-preview-enhanced.previewTheme": "github-dark.css",
    "markdown-preview-enhanced.mermaidTheme": "dark",
    "markdown-preview-enhanced.revealjsTheme": "blood.css",
    "pasteImage.path": "${currentFileDir}/pictures/${currentFileNameWithoutExt}/",
    "pasteImage.defaultName":"x",
}
```
快捷键配置: keybindings.json
```json
[
    // 解决Markdown图片快速复制快捷键冲突
    {
        "key": "ctrl+alt+v",
        "command": "-editor.action.codeAction",
        "when": "editorTextFocus"
    },
    // 切换Vim
    {
        "key": "ctrl+k",
        "command": "toggleVim"
    },
    // 注释后换行
    {
        "key": "ctrl+/",
        "command": "runCommands",
        "args": {"commands": ["editor.action.commentLine", "cursorDown"]},
        "when": "editorTextFocus"
    },
    // 使用Vim时, 仿IDEA
    // --打开命令
    {
        "key": "ctrl+shift+a",
        "command": "workbench.action.showCommands"
    },
    // --插入换行
    {
        "key": "shift+Enter",
        "command": "editor.action.insertLineAfter",
        "when": "editorTextFocus && !editorReadonly"
    },
]
```
Vim插件配置
```json
{
    "vim.easymotion": true,
    "vim.incsearch": true,
    "vim.hlsearch": true,
    "vim.visualstar": true,
    "vim.highlightedyank.enable": true,
    "extensions.experimental.affinity": {"vscodevim.vim": 1},
    "vim.handleKeys": {"<C-x>": false, "<C-c>": false},
    "vim.leader": "<space>",
    "vim.normalModeKeyBindings": [
        {"before": ["H"], "after": ["^"]},
        {"before": ["L"], "after": ["$"]},
        {"before": ["g", "r"], "commands": ["workbench.action.quickOpen"]},
        {"before": ["<leader>", "f"], "commands": ["revealInExplorer"]},
        {"before": ["<leader>", "t"], "commands": ["translation.translate"]},
        {"before": ["<leader>", "p"], "commands": ["editor.action.showContextMenu"]},
        {"before": ["<leader>", "c","f"], "commands": ["editor.action.formatDocument"]},
        {"before": ["<leader>", "e"], "commands": ["workbench.action.toggleSidebarVisibility"]},
        {"before": ["<leader>", "v","w"], "commands": ["workbench.action.closeActiveEditor"]},
        {"before": ["<leader>", "v","o"], "commands": ["workbench.action.closeOtherEditors"]},
    ],
    "vim.visualModeKeyBindings": [
        {"before": ["H"], "after": ["^"]},
        {"before": ["L"], "after": ["$"]},
        {"before": [">"], "commands": ["editor.action.indentLines"]},
        {"before": ["<"], "commands": ["editor.action.outdentLines"]},
    ],
    "vim.insertModeKeyBindingsNonRecursive": [
        {"before": ["j", "k"], "after": ["<Esc>"]},
        {"before": ["<Esc>"], "after": ["<Esc>", "a"]}
    ],
    "vim.operatorPendingModeKeyBindings": [
        {"before": ["H"], "after": ["^"]},
        {"before": ["L"], "after": ["$"]},
    ]
}
```
修改主题：执行 Markdown Preview Enhanced: Customize CSS(Global)
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
LaTeX Workshop 的配置, 按需添加
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
            "args": [
                "-synctex=1",
                "-interaction=nonstopmode",
                "-file-line-error",
                "-pdf",
                "-outdir=%OUTDIR%",
                "%DOC%"
            ],
            "env": {}
        },
        {
            "name": "xelatex",
            "command": "xelatex",
            "args": [
                "-synctex=1",
                "-interaction=nonstopmode",
                "-file-line-error",
                "%DOC%"
            ]
        },
        {
            "name": "pdflatex",
            "command": "pdflatex",
            "args": [
                "-synctex=1",
                "-interaction=nonstopmode",
                "-file-line-error",
                "%DOC%"
            ],
            "env": {}
        },
        {
            "name": "bibtex",
            "command": "bibtex",
            "args": [
                "%DOCFILE%"
            ],
            "env": {}
        }
    ],
    // 编译组合配置(这里是为了加入xelatex配置, 其他配置与默认值保持一致)
    "latex-workshop.latex.recipes": [
        {
            "name": "xelatex",
            "tools": ["xelatex"]
        },
        {
            "name": "latexmk",
            "tools": ["latexmk"]
        },
        {
            "name": "pdflatex -> bibtex -> pdflatex*2",
            "tools": ["pdflatex","bibtex","pdflatex","pdflatex"]
        }
    ],
}
```