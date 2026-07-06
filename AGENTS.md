<h1><center>软件配置仓库 Agent 指南</center></h1>

# 仓库概述

这是个人软件配置仓库, 管理跨平台(Linux/Windows/WSL)环境配置, 文档, 容器服务.

目录结构(部分):

```
├── .temp/                 # 临时文件, 待办事项
├── Linux/                 # Linux 配置资料
├── Windows/               # Windows 配置资料
├── dotfiles/              # 所有 dotfiles 配置
│   ├── setup-dotfiles.sh  # 通用 Stow 部署脚本
│   ├── setup-msys2.sh     # MSYS2 部署脚本
│   ├── setup-wsl-*.sh     # 各 WSL 发行版部署脚本 (如 setup-wsl-arch.sh)
│   ├── dotfiles-*.conf    # Stow 清单 (用于 setup-dotfiles.sh)
│   ├── [软件名]/          # 通用配置 (Linux 桌面等标准环境)
│   ├── MSYS2/             # MSYS2 环境专用配置
│   │   └── [软件名]/      #   MSYS2 版, 由 setup-msys2.sh 部署
│   └── WSL-<发行版>/      # WSL 各发行版专用配置
│       └── [软件名]/      #   由对应的 setup-wsl-*.sh 部署
├── Container/             # 容器配置
│   ├── README.md          # 容器环境规范
```

# Dotfiles 管理

使用 GNU Stow 进行 dotfiles 管理 (通用 Linux 环境).  
MSYS2/WSL 等特殊环境使用专用脚本部署, 见对应的 `setup-*.sh`.

目录分布说明:

- `dotfiles/软件名/` — 通用配置 (Linux 桌面等标准环境)
- `dotfiles/MSYS2/软件名/` — MSYS2 环境专用配置
- `dotfiles/WSL-<发行版>/软件名/` — 各 WSL 发行版专用配置 (如 WSL-Arch)

查找配置: 先找平台专用目录, 没有再找通用目录.

setup 脚本规范:

- `setup-dotfiles.sh`: 通用 Stow 脚本, 搭配 `dotfiles-<环境>.conf`
- `setup-msys2.sh`: MSYS2 专用配置脚本
- `setup-wsl-<发行版>.sh`: 各 WSL 发行版专用配置脚本

# 环境管理

原则: 系统 CLI 工具用系统包管理器, 开发环境和特定工具用 Mise.

Mise 安装全局工具适用范围:

- 需要版本管理的开发环境 (java/nodejs 等)
- 需要最新版本的开发工具 (lint/format 等)
- 编程语言生态全局包管理 (支持 npm/pipx/cargo/go 等后端)
- AI Agent
- Mise 生态配套工具

安装命令:

- 全局安装: `mise use -g <tool>`
- NPM 包: `mise use -g npm:<pkg>` (Aube 后端)
- Python CLI: `mise use -g pipx:<tool>` (UV 后端)
- Rust 工具: `mise use -g cargo:<tool>` (Cargo 后端)
- Go 工具: `mise use -g go:<tool>` (Go 后端)

工具优先级: 持久安装优先用 Mise, 没有则回退到对应语言的包管理器; 临时运行用 uvx/aubx 等

NPM 原则: 不直接使用 npm, 用 aube 替代 (命令风格类似 pnpm).

- 临时执行: `aubx <pkg>` (替代 npx)
- 运行脚本: `aubr <script>` (替代 npm run)

Python 原则: 保留系统 Python, 不引入全局依赖, 需要依赖时用 UV 替代.

- 临时脚本: `uv run script.py` (隔离环境, 用完即弃)
- 临时依赖: `uv run --with <pkg> script.py`
- CLI 工具: `uvx <tool>` (临时) / `mise use -g pipx:<tool>` (持久, 替代 `uv tool install`)

# 文档编写规范

## 统一使用英文标点符号

即便是中文内容, 也统一使用英文标点符号.

## 标题

页面开头的大标题使用: `<h1><center>页面标题</center></h1>`,  
不要使用 Markdown 一级标题(`#`)作为页面标题.  
正文从 `#` 开始, 不要整体向下缩一级.

## 内容组织

一个章节应尽量表达一个完整主题, 不要过度拆分. 同一主题尽量放到一个章节中.

连续的操作/命令/配置, 优先放在同一个代码块里, 使用空行和注释划分逻辑, 不要拆成多个标题或代码块.

只有当内容属于完全不同的话题时, 才拆分章节.  
如果内容有关但又想有所分别时, 可用 `---` 分隔线替代拆分章节.

## 换行逻辑

避免连续的大段正文.  
主动拆分长句提高可读性. 一行表达一个相对独立的逻辑, 多行组合成一个完整说明.  
或视情况选择使用列表, 表格, 代码块等方法表达内容.

普通文本换行遵循 Markdown 规范, 行尾保留两个空格.  
列表/表格/代码块等 Markdown 语法按自身规则处理.

## 保持语言精炼

直接描述操作, 尽量减少没有实际意义的描述, 比如: "我们需要", "下面介绍" ...

不要为了完整性主动扩写内容. 除非用户要求.

避免重复解释已经明显的内容.

保证文档简洁, 紧凑, 容易查阅.
