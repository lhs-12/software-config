<h1><center>Mise Bootstrap 计划方案</center></h1>

> 目标: 从现有的"脚本+stow"模式转向mise一站式管理

# dotfiles 配置目录

> 参考来源: https://github.com/teruyamato0731/dotfiles ; https://github.com/david-driscoll/dotfiles

> 之前用 Stow 为了软件配置分包, 目录设计为`dotfiles/Mise/.config/mise/`, 层级较多.  
> Mise Dotfiles 配置结构很细致, 可考虑简化目录层级. 不过暂时不改, 保持 Stow 兼容.

```
~/software-config/
└── dotfiles/
    ├── mise_bootstrap_init.sh           # 初始化脚本
    └── Mise/
        └── .config/
            └── aube/                    # aube 和 mise tools 关联较大, 暂时放一起管理
            └── mise/
                ├── miserc.toml          # Mise 前提配置
                ├── config.toml          # 基础配置
                ├── config.linux.toml    # Linux 通用
                ├── config.arch.toml     # Arch 特定
                ├── config.wsl-arch.toml # WSL-Arch 特定
                ├── config.msys2.toml    # Windows MSYS2 特定
                └── tasks/
                    └── bootstrap-linux/ # Tasks 命名空间
                        └── ...          # Task 脚本
                    └── bootstrap-arch/
                        └── ...
```

> 可用 `local` 后缀表示不提交 git 的配置: `config.local.toml`、`config.<env>.local.toml`
>
> 同目录优先级(低到高): `config.toml` < `config.<env>.toml`(按 env 列表顺序, 后者覆盖前者) < `config.local.toml` < `config.<env>.local.toml`  
> 注意 `config.local.toml` 会覆盖所有 env 专属文件, 跨平台共享的本机覆盖需谨慎放置

# 初始化脚本 `mise_bootstrap_init.sh`

使用方式: git clone 项目, 执行脚本

新系统初次调用使用 `mise_bootstrap_init.sh`, 后续再执行就可以直接用 `mise bootstrap` 命令(走全局配置)

作用:
1. 若 Mise 还没安装, 调用官方安装脚本
2. 软链接 dotfiles 的 mise 目录, 或使用 `$MISE_CONFIG_DIR`. 待定
3. 选择合适的 MISE_ENV, 设置到脚本环境变量, 并写入到 `miserc.toml`. 实现方式待定: 提供预设列表 或 检测已有配置做多选
4. 设置后续脚本需要用到的隐私环境变量 (如 GIT_USERNAME, GIT_EMAIL 等), 非空才导出
5. 调用 `mise bootstrap`

> 暂时不用 mise bootstrap secrets, 因为目前场景简单, 仅新机器首次部署时需要设置, 在初始化脚本中用环境变量即可, 无需引入更复杂的机制

# miserc.toml

前提配置, 可用于指定生效的配置, 比如指定 `env = ["arch", "kde"]` (平台层比如 "unix", "linux" 由 auto_env 补上)

要写上 `auto_env = true`, 它会自动加载平台配置文件(`unix`/`linux`/`windows` 及 `{os}-{arch}`), 与 `env` 互补.  
粒度止于 os-arch (如 bare Arch 与 WSL-Arch 同为 `linux-x64`), 无法表达机器身份, 所以机器身份仍写在 `env` 里.  
Mise 2027.6.0 起将默认开启, 现在提前写上, 保持未来兼容性

另一种替代 miserc.toml 的方式是设置 MISE_ENV 环境变量, 但写入 shell 配置的话, 文件太多太分散, 不合适.

`dotfiles/Mise/.config/mise/miserc.toml` 的配置要写 auto_env + env, 其他用不上, 而两个都属于本机配置,  
且 miserc.toml 不支持 `.local` 本地文件变体, 无法拆分, 所以放 `.gitignore`,  
`miserc.toml` 文件生成依赖 `mise_bootstrap_init.sh`.

# repos

```toml
[bootstrap.repos]
"~/software-config" = { url = "git@github.com:user/software-config.git" }
[settings]
dotfiles.root = "~/software-config/dotfiles"
```

# Bootstrap + Hooks + Tasks 功能联动

1. `mise bootstrap` 命令执行后, 会按固定顺序执行 `[bootstrap]` 中定义的配置: packages → repos → dotfiles → systemd → tools 等
2. `[bootstrap.hooks]` 用于在 bootstrap 步骤的执行之间设定一些前后的执行项目, 只能执行命令, 如需调用 task 可通过 `mise run taskname`
3. 如果存在名为 `bootstrap` 的 task (在配置中定义或独立文件), 会在 bootstrap 步骤完成后自动执行
4. `[bootstrap.hooks.final]` 在 `bootstrap` task 之后执行

Task 使用方式:
1. task 可以写在脚本, 放在 `~/.config/mise/tasks/[命名空间]/[脚本名]`, 通过 `mise run [命名空间:脚本名]` 调用
2. task 里面可以设置 depends, 相当于 task 的前置钩子执行项目 (命令或 task)
3. 脚本可通过规范的注释 `#MISE` 提供元数据

`[tasks.bootstrap]` 用法示例:
```toml
[tasks.bootstrap]
depends = ["git-config", "yay-install"]
run = "echo 'all bootstrap tasks done'"
```

典型使用场景:
- hooks: 前置/后置操作 (如 `sudo systemctl enable docker`)
- tasks: 复杂逻辑 (如 yay 安装, 镜像源配置)
- depends: 任务编排

注意上面的示例只是演示 depends 语法, 实际顺序要求 git-config 早于 gh 登录,
不能靠 bootstrap task 编排, 需拆开: git-config 作为 pre-tools hook 或由 dotfiles 覆盖 ~/.gitconfig,
gh 登录也走 pre-tools hook (见 GitHub 认证顺序)

hooks 在当前进程环境执行, 此时 `[tools]` 尚未进 PATH, 依赖工具的 hook 需用 `mise exec -- <cmd>` 包裹

# GitHub 认证顺序 (鸡生蛋问题)

gh 是 mise 管理的工具, 但 mise 批量下载工具又要 gh 的凭证, 放 final/bootstrap task 都太晚:
auth 必须在第 15 步 `mise install` 之前完成, 用 `pre-tools` hook 解决.
hook 为 raw 模式执行, 继承终端 stdin/stdout, 交互式 `gh auth login` 可用

```toml
[bootstrap.hooks.pre-tools]
run = [
  "mise install gh",                                            # 只装 gh(限定参数, 不装全部), 不改写配置
  "mise exec -- gh auth status || mise exec -- gh auth login",  # 幂等: 已登录则短路
]
```

用 `mise install` 而非 `mise use -g`: use 会改写全局 config 的 [tools] 条目,
而全局 config 由 dotfiles 管理, 改写会造成状态漂移; install 只装不改配置, 重复执行跳过已装项

完整顺序: packages 装 git/GCM → dotfiles 交付 ~/.gitconfig(credential helper) → pre-tools hook 装 gh 并登录 → mise install 批量下载工具

GitHub token: 全局 config 配 `github.credential_command = "gh auth token"`, gh 登录后即可用, 无需其他配置

> mise 2026.8 起默认经 mise-versions 缓存取版本列表, 匿名安装基本不触发 GitHub API 限流,
> token 主要服务私有仓库与回退场景, auth 失败不会卡死 bootstrap

# systemd 功能

使用 `[bootstrap.services]` 管理已有的系统服务 (如 Docker、Nginx 等),  `state` 控制运行状态, `enabled` 控制开机自启

使用 `[bootstrap.linux.systemd.units]` 管理用户自己创建的服务, `start = true` 参数可指定自动启动

额外的开机脚本用 dotfiles 机制放 `~/.config/autostart/`

# Mise Bootstrap 使用功能整理

| 配置                              | 功能                 |
| --------------------------------- | -------------------- |
| `[bootstrap.packages]`            | 系统包管理           |
| `[bootstrap.repos]`               | git 仓库克隆/校验    |
| `[dotfiles]`                      | 软件配置             |
| `[bootstrap.services]`            | systemd 系统服务管理 |
| `[bootstrap.linux.systemd.units]` | systemd 用户服务管理 |
| `[bootstrap.hooks.*]`             | bootstrap 钩子命令   |

> `mise_shell_activate` 不用: shell 激活已由 dotfiles 的 rc 文件管理, 且该功能仅支持 bash/zsh/fish

常用命令:

```sh
mise bootstrap --dry-run                 # 全步骤预览, 不落盘
mise bootstrap status --missing          # 一站式漂移检查, 退出码 1 = 有缺失, 可用于巡检/CI
mise bootstrap plan --detailed-exitcode  # 资源依赖计划: 0=无变更 2=有变更 1=失败或 unknown
mise bootstrap dotfiles add ~/.zshrc     # 把现存文件收编进 dotfiles.root(相当于 stow adopt)
mise bootstrap dotfiles edit ~/.zshrc    # 编辑受管源文件(symlink 模式直达源)
mise bootstrap --force-dotfiles          # dotfiles 冲突时显式整文件替换(默认拒绝冲突)
```

# mise bootstrap 执行步骤

`mise bootstrap` 会按以下顺序执行:

1. `mise bootstrap accounts apply` 应用用户和组配置 (`[bootstrap.users]` 和 `[bootstrap.groups]`)
2. `mise bootstrap plugins apply` 安装包管理器插件 (`[bootstrap.plugins]`)
3. 内置包管理器安装缺失的系统包 (`[bootstrap.packages]`)
4. `mise bootstrap files apply` 应用文件和目录配置 (`[bootstrap.files]` 和 `[bootstrap.directories]`)
5. `mise bootstrap services apply` 应用 systemd 系统服务 (`[bootstrap.services]`)
6. `mise bootstrap firewall apply` 应用防火墙策略和规则 (`[bootstrap.linux.firewall]`)
7. `mise bootstrap compose apply` 应用 Docker Compose 项目 (`[bootstrap.compose]`)
8. `mise bootstrap repos apply` 克隆或更新 git 仓库 (`[bootstrap.repos]`)
9. `mise bootstrap dotfiles apply` 应用 dotfiles 配置 (`[dotfiles]`)
10. `mise bootstrap mise-shell-activate apply` 配置 shell 激活 (`[bootstrap.mise_shell_activate]`)
11. `mise bootstrap macos defaults apply` 写入 macOS 默认设置 (`[bootstrap.macos.defaults]`)
12. `mise bootstrap macos launchd-agents apply` 写入并加载 macOS LaunchAgent (`[bootstrap.macos.launchd.agents]`)
13. `mise bootstrap linux systemd-units apply` 应用 systemd 用户服务 (`[bootstrap.linux.systemd.units]`)
14. `mise bootstrap user apply` 应用用户配置 (`[bootstrap.user]`)
15. `mise install` 安装缺失的工具 (`[tools]`)
16. 插件包管理器在对应工具可用后应用
17. `mise run bootstrap` 运行名为 `bootstrap` 的 task (配置中定义或独立文件, 如果存在)
18. `[bootstrap.hooks.final]` 在 bootstrap task 之后执行 (如果配置)

> 已存在的配置会被跳过 (如已安装的包、已存在的仓库、已匹配的 dotfiles), 但 `bootstrap` task 每次都会执行, 所以需要保持幂等性

> 可用 `--skip <part>` 跳过特定步骤, `--only <part>` 只执行特定步骤

# Windows 情况

基于 v2026.8.8 源码核实(2026-08), 原两个限制现状:

1. 软链接机制(2026.8.6 #11978 已修复): 文件 symlink 先尝试真符号链接(开启开发者模式后普通权限即可), 失败回退 copy; 目录用 junction; `symlink-each` 的文件在 Windows 上仍是 copy. status 能识别链接与 copy 两种形态
2. `[bootstrap.packages]` 仍不支持 MSYS2 pacman: pacman 管理器硬编码仅 Linux; 内置管理器(apk/apt/dnf/pacman/brew/flatpak/mas)在 Windows 上全部不可用; 包插件机制已就绪但尚无 winget 官方插件. OS 包继续用 setup-msys2.sh, 不进 mise

Windows 迁移评估: 暂不迁移, 等 `symlink-each` 修复后再评估(同套全局配置 + env 隔离的架构仍然成立)

- 正常工作: repos/dotfiles/hooks/tasks/tools
- Linux-only 部分(services/firewall/accounts/systemd-units)在非 Linux 平台为惰性/unknown, 不报错; 但 packages 条目若写进基础配置会以 unknown 污染 plan 退出码, 必须隔离到 config.linux.toml/config.arch.toml
- `mise_shell_activate` 仅支持 bash/zsh/fish, 无 pwsh/PS5 target; 且 MSYS2 上 bash/fish 激活存在 PATH 格式 bug(discussion #3961 未修), 继续手动管理 rc 文件, 不启用此节

# Mise 方案对比 Stow 方案

优点:
1. 可集成 systemd, 软件包清单等更多装机配置
2. dotfiles 配置规则更细致

缺点:
1. Windows 无系统包管理
2. Windows `symlink-each` 仍是 copy 语义(#11978 评审时钉住, 链接归属持久化层未实现, 无修复跟踪), 没修好前 Windows 不迁移
3. 不像 Stow 那样按软件包拆包管理, Mise 更偏向按环境拆分配置
4. 不像 Stow 那样能方便地 adopt 一次拿到所有变更, 结合 git 快速处理冲突, 略麻烦

# 其他注意

1. 脚本编写注意幂等性
2. Mise Dotfiles Template 模式是模板渲染, 非软链接, 仅适合“单向管理”, 不适合“双向修改”场景
3. 信任机制: 全局配置(~/.config/mise)自动信任, 一般无需 mise trust
