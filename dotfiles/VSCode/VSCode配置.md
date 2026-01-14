# <center>VSCode配置</center>

# 插件

```bash
# 对以下内容使用vi命令编辑
# Windows 用 PowerShell执行. 命令:g/^s*$\|^#.*/d | %s/\\.*/`/
# Linux 命令:g/^s*$\|^#.*/d | %s/\\.*/\\/

code \
# 通用
--install-extension vscode-icons-team.vscode-icons \                  # vscode-icons                        图标
--install-extension asvetliakov.vscode-neovim \                       # VSCode Neovim                       NeoVim合成扩展
--install-extension alefragnani.bookmarks \                           # Bookmarks                           书签
--install-extension donjayamanne.githistory \                         # Git History                         Git历史
--install-extension james-yu.latex-workshop \                         # LaTeX Workshop                      LaTeX与PDF支持
--install-extension fabiospampinato.vscode-open-in-application \      # Open in Application                 默认程序打开文件
--install-extension ms-vscode-remote.vscode-remote-extensionpack \    # Remote Development                  远程开发套件(WSL/容器/SSH...)
--install-extension ms-vsliveshare.vsliveshare \                      # Live Share                          实时共享
--install-extension mark-wiemer.vscode-autohotkey-plus-plus \         # AutoHotkey Plus Plus                AutoHotkey支持
--install-extension johnnymorganz.stylua \                            # StyLua                              Lua支持
--install-extension redhat.vscode-xml \                               # XML                                 XML支持
--install-extension tamasfe.even-better-toml \                        # Even Better TOML                    TOML支持
--install-extension redis.redis-for-vscode \                          # Redis for VS Code                   Redis
--install-extension github.copilot \                                  # GitHub Copilot                      GitHub Copilot AI

# 笔记, 图表
--install-extension shd101wyy.markdown-preview-enhanced \             # Markdown Preview Enhanced           Markdown功能集成
--install-extension takumii.markdowntable \                           # Markdown Table                      Markdown表格输入
--install-extension mushan.vscode-paste-image \                       # Paste Image                         Markdown图片复制
--install-extension oorzc.mind-map \                                  # vscode-mindmap(oorzc)               Mindmap支持
--install-extension hediet.vscode-drawio \                            # Draw.io Integration                 图表编辑(.drawio)
--install-extension pomdtr.excalidraw-editor \                        # Excalidraw                          图表编辑(.excalidraw)
# 其他可选: Jupyter...

# 容器
--install-extension ms-azuretools.vscode-docker \                     # Docker                              Docker支持
--install-extension ms-kubernetes-tools.vscode-kubernetes-tools \     # Kubernetes                          容器编排支持

# Python
--install-extension ms-python.python \                                # Python                              Python支持
--install-extension charliermarsh.ruff \                              # Ruff                                代码格式
--install-extension njpwerner.autodocstring \                         # autoDocstring                       文档格式
--install-extension kevinrose.vsc-python-indent \                     # Python Indent                       自动缩进

# 前端
--install-extension xabikos.javascriptsnippets \                      # JavaScript (ES6) code snippets      JS提示
--install-extension formulahendry.auto-complete-tag \                 # Auto Complete Tag                   标签更改
--install-extension vue.volar \                                       # Vue (Official)                      Vue支持
--install-extension sdras.vue-vscode-snippets \                       # Vue VSCode Snippets                 Vue提示
--install-extension dbaeumer.vscode-eslint \                          # ESLint                              代码检查
--install-extension esbenp.prettier-vscode \                          # Prettier                            代码格式
--install-extension ms-vscode.live-server \                           # Live Preview                        实时网页
--install-extension ecmel.vscode-html-css \                           # Html CSS Support                    CSS支持
--install-extension zignd.html-css-class-completion \                 # IntelliSense for CSS class names    CSS提示
--install-extension pranaygp.vscode-css-peek \                        # CSS Peek                            CSS预览

# Java
--install-extension vscjava.vscode-java-pack \                        # Extension Pack for Java             Java支持
--install-extension vmware.vscode-boot-dev-pack \                     # Spring Boot Extension Pack          Spring支持
# 其他可选: Red Hat Dependency Analytics, SonarLint, Tools for MicroProfile, Quarkus...

# C/C++
--install-extension ms-vscode.cpptools-extension-pack \               # C/C++ Extension Pack                C/C++支持
```

# 配置

使用`settings.json`和`keybindings.json`

Windows 环境在`settings.json`额外增加配置,  
还有 Markdown Preview Enhanced: Customize CSS(Global) 的配置
```json
{
  // Terminal
  "terminal.integrated.profiles.windows": {
    "Bash(UCRT64)": {
      "path": "cmd.exe",
      "args": ["/k", "C:\\msys64\\msys2_shell.cmd -defterm -here -no-start -ucrt64 -shell bash -l -i"],
      "icon": "terminal-bash"
    },
    "Git Bash": null
  },
  "markdown-preview-enhanced.plantumlJarPath": "D:/Program Files/tools/plantuml.jar",
  "markdown-preview-enhanced.chromePath": "C:/Program Files (x86)/Microsoft/Edge/Application/msedge.exe",
}
```

可选配置: LaTeX Workshop 配置
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

可选配置: Markdown渲染折叠显示内容: Markdown Preview Enhanced: Extend Parser(Workspace)
```js
// 修改parser.js文件
  onDidParseMarkdown: async function (html) {
    const regex = /<h3([^>]*)>([^<]*)<\/h3>([\s\S]*?)(?=<h|$)/gi;
    return html.replace(regex, (_, attrs, content, nextContent) => {
      return `<details><summary><h3 style="display:inline"${attrs}>${content}</h3></summary><br>\n${nextContent.trim()}\n</details><br>`;
    });
  },
```
```less
// 修改style.less
.markdown-preview.markdown-preview {
  font-family: "仓耳华新体";
  font-size: 18px;
  counter-reset: h2 h3-independent;
  h2 {
    counter-increment: h2;
    counter-reset: h3;
  }
  h2::before {
    content: counter(h2) ".";
    font-size: 1.2rem;
  }
  h2 ~ * h3::before {
    counter-increment: h3;
    content: counter(h2) "." counter(h3);
    font-size: 1rem;
  }
  h3:not(h2 ~ * h3)::before {
    counter-increment: h3-independent;
    content: counter(h3-independent) ".";
    font-size: 1rem;
  }
}
```
