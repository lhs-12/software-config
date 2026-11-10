<h1><center>软件配置仓库 Agent 指南</center></h1>

# 仓库概述

这是个人软件配置仓库, 管理跨平台(Linux/Windows/WSL)环境配置, 文档, 容器服务.

目录结构(部分):

```
├── .temp/                 # 临时文件, 待办事项
├── Linux/                 # Linux 配置资料
├── Windows/               # Windows 配置资料
├── dotfiles/              # dotfiles 配置
│   ├── setup-msys2.sh     # Windows(MSYS2) 部署脚本
│   ├── setup-wsl-*.sh     # 各 WSL 发行版部署脚本
│   ├── setup-dotfiles.sh  # 通用 Stow 部署脚本 (搭配 dotfiles-*.conf)
│   ├── dotfiles-*.conf    # Stow 清单
│   ├── [软件名]/          # 通用软件配置
│   ├── MSYS2/             # Windows(MSYS2) 环境专用软件配置
│   │   └── [软件名]/
│   └── WSL-<发行版>/      # WSL 各发行版专用软件配置
│       └── [软件名]/
├── Container/             # 容器配置
│   ├── README.md          # 容器环境规范
```

# Dotfiles 管理

使用 GNU Stow 进行 dotfiles 管理 (通用 Linux 环境).  
MSYS2/WSL 等特殊环境使用专用脚本部署, 见对应的 `setup-*.sh`.

查找配置: 先找平台专用目录, 没有再找通用目录.

# 环境管理

原则: 系统 CLI 工具用系统包管理器, 开发环境和特定工具用 Mise.

Mise 安装全局工具适用范围:

- 需要版本管理的开发环境 (java/nodejs 等)
- 需要最新版本的开发工具 (lint/format 等)
- 编程语言生态全局包管理 (支持 npm/pypi/cargo/go 等后端)
- AI Agent
- Mise 生态配套工具

安装命令:

- 全局安装: `mise use -g <tool>`
- NPM 包: `mise use -g npm:<pkg>` (Aube 后端)
- Python CLI: `mise use -g pypi:<tool>` (UV 后端)
- Rust 工具: `mise use -g cargo:<tool>` (Cargo 后端)
- Go 工具: `mise use -g go:<tool>` (Go 后端)

工具优先级: 持久安装优先用 Mise, 没有则回退到对应语言的包管理器; 临时运行用 uvx/aubx 等

NPM 原则: 不直接使用 npm, 用 aube 替代 (命令风格类似 pnpm).

- 临时执行: `aubx <pkg>` (替代 npx)
- 运行脚本: `aubr <script>` (替代 npm run)

Python 原则: 保留系统 Python, 不引入全局依赖, 需要依赖时用 UV 替代.

- 临时脚本: `uv run script.py` (隔离环境, 用完即弃)
- 临时依赖: `uv run --with <pkg> script.py`
- CLI 工具: `uvx <tool>` (临时) / `mise use -g pypi:<tool>` (持久, 替代 `uv tool install`)

---

私密环境变量管理(API_KEY 等)建议使用 Mise 配置目录里的 `config.local.toml` 文件的 `[env]` 表,  
等效命令: `mise set --file ~/.config/mise/config.local.toml KEY=VALUE`

# 文档编写规范

## 标点

正文自然语言统一使用英文半角 ASCII 标点, 即便是中文内容也用英文标点风格.

## 标题

文章开头大标题用 `<h1><center>页面标题</center></h1>` 而非 `#`.  
正文从 `#` 开始而不是 `##`(相当于所有正文标题都省一层 `#`)

## 内容组织

章节设计结构偏好平铺, 避免深层嵌套. 不要为了细碎内容拆分太多子标题章节, 尽量在章节内写完.  
相对独立但相关的段落可利用 `---` 断开, 而不是增加标题章节.

同一任务的连续命令/配置一般放同一个代码块, 用空行和注释划分步骤, 而不是拆成多个代码块或标题.

## 换行逻辑

避免连续的大段正文, 主动拆分长句提高可读性.  
一行表达一个相对独立的逻辑, 连续多行组合出完整逻辑, 段落内硬换行行尾要加两个空格.  
复杂情况考虑使用列表, 表格, 代码块等方法将内容拆分细粒度表达.

## 写作风格

结论先行: 先结论/操作, 后原因/解释.  
简洁直接, 一句话能说完的不用两句; 用词容易阅读理解且无歧义, 优先选短词. 注意术语一致性.  
直接描述操作; 不铺垫, 不过渡, 不总结, 不客套, 不写信息含量低的语句.

不要为了完整性主动扩写内容. 除非用户要求.

避免啰唆解释已知信息或常识内容.
