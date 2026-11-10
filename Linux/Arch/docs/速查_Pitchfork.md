<h1><center>速查_Pitchfork</center></h1>

> 面向熟悉 pm2 的用户. 读完本文, 你将了解 Pitchfork 是什么, 怎么安装, 怎么用, 以及它和 pm2 的异同与迁移方式.  
> 本文基于 Pitchfork **v2.30.1**, 文档见 <https://pitchfork.jdx.dev>.

---

# 目录

1. [Pitchfork 是什么](#1-pitchfork-是什么)
2. [安装](#2-安装)
3. [核心概念](#3-核心概念)
4. [基本功能一览](#4-基本功能一览)
5. [上手使用](#5-上手使用)
6. [进阶功能](#6-进阶功能)
7. [界面: TUI / Web UI / MCP](#7-界面--tui--web-ui--mcp)
8. [与 pm2 的对比](#8-与-pm2-的对比)
9. [从 pm2 迁移(以 vcp-main / vcp-admin 为例)](#9-从-pm2-迁移以-vcp-main--vcp-admin-为例)
10. [常见问题](#10-常见问题)

---

# 1. Pitchfork 是什么

Pitchfork 是一个**通用型守护进程(daemon)管理器**, 口号是 _"Daemons with DX"_(为开发者体验而生的守护进程管理).  
它由 jdx(mise 的作者)开发, 用 **Rust** 编写, 发布为单一二进制 `pitchfork`.

它和 pm2 解决的是同一类问题 -- 把后台进程管起来(启动, 监控, 日志, 重启, 开机自启), 但设计理念完全不同:

|          | pm2                            | Pitchfork                                      |
| -------- | ------------------------------ | ---------------------------------------------- |
| 定位     | Node.js 进程管理器             | 语言无关的通用 daemon 管理器                   |
| 配置文件 | `ecosystem.config.js`(JS 脚本) | `pitchfork.toml`(声明式 TOML)                  |
| 核心卖点 | Node 生态, cluster 集群        | 开发体验: 声明式, 就绪检查, 依赖编排, 自动启停 |

Pitchfork 的典型使用场景:

- 启动开发服务(Web API, 数据库, 前端 dev server)
- 把服务启停和日志暴露给 AI 助手(MCP Server), 由 Claude/Cursor 统一调度
- 管理项目的后台任务(cron 定时任务, worker)
- 作为容器的 entrypoint(PID 1)

## 架构速览(为什么"命令这么快")

Pitchfork 是 **client-server 架构**:

```
你的命令 (pitchfork start/stop/logs/...)     ← CLI
        │  Unix Socket (~/.local/state/pitchfork/sock/main.sock)
        ▼
     Supervisor 守护进程                      ← 常驻后台, 管理一切子进程
        │
        ▼
   各个 daemon 子进程
```

- 你敲的每条命令都是轻量客户端, 通过 Unix socket 与 Supervisor 通信(JSON 序列化).
- Supervisor 没在运行? CLI 会自动把它拉起来(`settings.supervisor.auto_start`, 默认开), 你无感知.
- 状态持久化在 `~/.local/state/pitchfork/state.toml`(带文件锁, 并发安全).
- 日志存在 SQLite 数据库 `~/.local/state/pitchfork/logs/logs.db`, 由独立的 log sink 进程写入, Supervisor 意外退出也不丢日志.
- 状态目录可用 `PITCHFORK_STATE_DIR`(或 `XDG_STATE_HOME`)重定位.

---

# 2. 安装

三种方式任选:

```bash
# 方式一: mise(推荐, 和 node/python 等一起管理)
mise use -g pitchfork

# 方式二: cargo
cargo install pitchfork-cli --locked

# 方式三: 从 GitHub Releases 下载预编译二进制
# https://github.com/jdx/pitchfork/releases
```

验证:

```bash
pitchfork --version
```

可选: shell 补全和短别名:

```bash
# bash 补全
mkdir -p ~/.local/share/bash-completion/completions
pitchfork completion bash > ~/.local/share/bash-completion/completions/pitchfork

# 短别名 pf(之后 pf api 等价于 pitchfork start api)
echo 'alias pf=pitchfork' >> ~/.bashrc && source ~/.bashrc
```

---

# 3. 核心概念

## 3.1 daemon(守护进程)

Pitchfork 管理的每个后台进程叫 **daemon**, 有一个 ID(如 `vcp-main`).

## 3.2 pitchfork.toml(声明式配置)

项目的 `pitchfork.toml` 用声明方式定义 daemon, 这是和 pm2 最大的不同:

```toml
[daemons.vcp-main]
run = "node server.js"

[daemons.vcp-admin]
run = "node admin.js"
```

**写完配置, daemon 就"永久存在"了** -- 不需要像 pm2 那样 `pm2 save` 保存进程列表.

配置合并优先级(后者覆盖前者):

```
/etc/pitchfork/config.toml          # 系统级(global 命名空间)
~/.config/pitchfork/config.toml     # 用户级(global 命名空间)
.config/pitchfork.toml              # 项目级
.config/pitchfork.local.toml        # 项目级(本地覆盖)
pitchfork.toml                      # 项目级
pitchfork.local.toml                # 项目级(最高优先级, 通常 git 忽略)
```

外部生成的配置(如脚本产出的 TOML)不必写进仓库, 挂上去即可:  
`pitchfork config add /path/gen.toml --dir <项目目录>`(临时注入用 `PITCHFORK_CONFIG=<file>`), `pitchfork config list` / `config remove` 管理.

## 3.3 supervisor(守护进程的守护进程)

常驻后台的管理进程, 负责:

- 监控子进程存活, 执行重启策略
- 就绪检查, 健康探测, 依赖编排, cron 调度
- 文件监听, 资源限制, 日志写入
- 通过 interval watcher 周期性巡检(默认 10s, `settings.general.interval` 可调)

## 3.4 namespace(命名空间)

多个项目可能都有 `api` 这个 daemon 名, 冲突怎么办? Pitchfork 用命名空间自动隔离:

- 项目配置默认以 **配置文件所在目录名** 作为命名空间(`.config/` 下的配置取其父目录) → `frontend/api`, `backend/api`
- 全局配置(`~/.config/pitchfork/config.toml`)的命名空间是 `global`
- 在项目目录内可用短 ID(`pitchfork start api`); 从外部可用完整 ID(`pitchfork start frontend/api`)
- Git worktree 天然支持, 每个 worktree 自动独立命名空间, 互不干扰

## 3.5 数据存放位置

| 内容       | 路径                                                                  |
| ---------- | --------------------------------------------------------------------- |
| 状态文件   | `~/.local/state/pitchfork/state.toml`                                 |
| 日志数据库 | `~/.local/state/pitchfork/logs/logs.db`(SQLite)                       |
| IPC socket | `~/.local/state/pitchfork/sock/main.sock`                             |
| 代理证书   | `~/.local/state/pitchfork/proxy/`(CA 与各域名证书)                    |
| 开机自启   | Linux: `~/.config/systemd/user/pitchfork.service`; macOS: LaunchAgent |

---

# 4. 基本功能一览

| 功能         | 说明                                                                      |
| ------------ | ------------------------------------------------------------------------- |
| 后台运行     | `pitchfork run <id> -- <cmd>` 一行启动, 无需配置文件                      |
| 声明式管理   | `pitchfork.toml` 定义 daemon, `start` / `restart` / `stop` / `list`       |
| 幂等启动     | 已运行的 daemon 不会重复启动(`--force` 才会重启)                          |
| 日志         | SQLite 存储, 实时 tail, 按时间/级别/字段过滤, 轮转                        |
| 就绪检查     | delay / 输出正则 / HTTP / TCP 端口 / 自定义命令, 共 5 种                  |
| 健康检查     | `health_http` / `health_cmd` / `health_port` 周期探测, 连续失败自愈       |
| 依赖编排     | `depends` 拓扑排序, 同层依赖**并行**启动; `oneshot` 任务完成后才继续      |
| 崩溃重启     | `retry` 自动重启(启动期同步重试 + 运行期异步重试)                         |
| 文件监听     | `watch` glob 变化自动重启(防抖 1s)                                        |
| Cron 调度    | 6 字段 cron + `retrigger` 重触发策略 + `immediate` 补触发                 |
| 生命周期钩子 | `on_ready` / `on_fail` / `on_retry` / `on_stop` / `on_exit` / `on_output` |
| 资源限制     | `memory_limit`, `cpu_limit`, 超限自动杀掉                                 |
| 端口管理     | `port` + 自动 bump, 解析后注入 `$PORT`(`$PORT0..N`)环境变量               |
| 配置模板     | Tera 模板 `{{ daemons.x.port }}`, 跨 daemon 传端口/URL                    |
| 禁用/恢复    | `pitchfork disable` / `enable`, 禁用手动, cron, 重试, 开机启动            |
| 等待退出     | `pitchfork wait` 阻塞到 daemon 停止, 顺带实时输出日志                     |
| 外部配置     | `pitchfork config add` 挂载生成的 TOML, 不污染项目仓库                    |
| Shell Hook   | 进目录自动启动, 离开自动停止                                              |
| 开机自启     | `pitchfork boot enable`(生成 systemd/LaunchAgent 单元)                    |
| 界面         | TUI 终端仪表盘 + Web UI(默认关闭, 按需开)+ MCP Server(给 AI 助手用)       |
| 容器模式     | 作为 PID 1 运行, 僵尸进程回收 + 信号转发                                  |
| 反向代理     | 带 `port` 的项目 daemon 自动获得 `https://api.project.localhost`          |

---

# 5. 上手使用

## 5.1 一行启动后台进程(对应 `pm2 start app.js` 的最简形态)

不需要配置文件:

```bash
pitchfork run vcp-main -- node server.js
# 等价于 pm2 start server.js --name vcp-main
```

`--` 后面的命令原样执行. 常用参数:

```bash
pitchfork run vcp-main --retry 3 -- node server.js      # 崩溃自动重启 3 次
pitchfork run vcp-main --delay 5 -- node server.js      # 5 秒就绪检查
pitchfork run vcp-main --port 8080 -- node server.js    # 等 8080 端口监听即视为就绪
pitchfork run vcp-main -f -- node server.js             # 已运行则先停掉再启动
pitchfork run vcp-main -o 'Listening' -- node server.js # 输出匹配正则才算就绪
```

## 5.2 声明式配置: 推荐方式

在项目根目录创建 `pitchfork.toml`:

```toml
[daemons.vcp-main]
run = "node server.js"
dir = "main"                                    # 工作目录(相对 pitchfork.toml)
env = { NODE_ENV = "production", PORT = "8080" } # 环境变量
retry = 3                                       # 崩溃重启

[daemons.vcp-admin]
run = "node admin.js"
dir = "admin"
retry = 3
```

常用命令(注意 `pitchfork start` **幂等**, 已运行就跳过):

```bash
pitchfork start vcp-main                  # 启动单个
pitchfork start vcp-main vcp-admin        # 启动多个(并行)
pitchfork vcp-main                        # 简写! 等价于 start
pitchfork start --all                     # 启动所有(项目 + 全局)
pitchfork start --local                   # 只启动本项目的
pitchfork start --group backend           # 按组启动(见 6.9)
```

## 5.3 查看状态(对应 `pm2 status` / `pm2 jlist`)

```bash
pitchfork list          # 别名: pitchfork ls
# 输出:
# Name      Status
# vcp-main  running
# vcp-admin available
# vcp-old   errored  exit code 127

pitchfork list --json   # 对应 pm2 jlist(机器可读)
pitchfork status vcp-main               # 单个详情(PID, 端口, cron 上次/下次触发时间)
pitchfork status vcp-main --json
pitchfork list --status running         # 可重复 = OR; 状态含 running/stopped/waiting/stopping/restarting/failed/errored/completed/available/disabled
pitchfork list --namespace frontend     # 只看某个命名空间
pitchfork list --project                # 只看当前项目的
```

`list` 会同时展示**活跃 daemon**(运行/停止)和**可用 daemon**(配置里定义了但没启动过).

## 5.4 日志(对应 `pm2 logs` / `tail -f ~/.pm2/logs/...`)

```bash
pitchfork logs vcp-main                  # 查看日志(终端里超出屏高自动分页, 从末尾开始)
pitchfork logs vcp-main -t               # 实时跟随(别名 -f / --tail), Ctrl+C 退出
pitchfork logs vcp-main -n 100           # 最近 100 行(对应 pm2 --lines 100 --nostream)
pitchfork logs vcp-main --raw -n 100     # 无格式纯文本, 适合管道/grep
pitchfork logs vcp-main --since 1h       # 最近 1 小时(支持 5min/2h/1d, "10:30", "2024-01-15 09:00")
pitchfork logs vcp-main --level error    # 只看 error 及以上(结构化日志)
pitchfork logs vcp-main --grep timeout   # 按关键字过滤(--regex 用正则, 可重复 --grep = OR)
pitchfork logs vcp-main --since 10:30 --until 11:00   # 时间区间
pitchfork logs vcp-main --field component=api         # 结构化字段过滤
pitchfork logs vcp-main -n 100 --jq '.msg'            # jq 过滤 + 最近 100 条匹配
pitchfork logs vcp-main --clear          # 清空该 daemon 日志
pitchfork logs vcp-main vcp-admin        # 多 daemon 日志按时间交错合并
pitchfork logs pitchfork                 # Supervisor 自身的日志
```

**注意**: 与 pm2 不同, Pitchfork 的日志存在 SQLite 里(而不是 `~/.pm2/logs/*-out.log` 这样的纯文本文件), 所以没有 `tail -f 文件` 这种用法 -- 直接 `pitchfork logs vcp-main -t` 即可. 旧版本的文本日志会自动导入数据库, 无需手动迁移.

日志还能自动解析 JSON / logfmt 结构化输出, 支持 `--field`, `--jq` 过滤, 并可用 `[settings.logs]` 配置轮转(如 `time_retention = "7d"` 只保留 7 天).

## 5.5 重启与停止(对应 `pm2 restart` / `pm2 stop`)

```bash
pitchfork restart vcp-main                # 重启(SIGTERM 停止再按配置启动, 带依赖解析)
pitchfork restart vcp-main vcp-admin      # 同时重启多个
pitchfork restart --all                   # 重启所有运行中的
pitchfork stop vcp-main                   # 停止(别名: pitchfork kill vcp-main)
pitchfork stop vcp-main vcp-admin
pitchfork stop --all                      # 按依赖逆序停止
pitchfork start vcp-main --force          # 等价于 restart(停掉再启动)
```

停止策略是优雅停机: 把配置的停止信号(默认 **SIGTERM**)**发给整个进程组**, 等 `stop_signal.timeout` 或 `settings.supervisor.stop_timeout`(默认 5s)让整组退出, 超时再对整组发 **SIGKILL**.  
Supervisor 没在运行时, `stop` 只警告并退出 0, 清理脚本可以无条件调用; `stop --all/-l/-g` 按依赖(当初启动的顺序)逆序停止.

## 5.6 删除 daemon(对应 `pm2 delete`)

Pitchfork 里 daemon 来自配置,**"删除" 就是把配置删掉**:

```bash
# 1. 从 pitchfork.toml 删掉 [daemons.vcp-main] 这段
# 2. 如果之前 stop 过, 用 clean 清掉残留记录
pitchfork clean --daemon vcp-main   # 只清这一个; 不带参数清全部停止/失败的
pitchfork clean --prune             # 只清理工作目录已不存在的记录(含全局配置里的 namespace/slug/外部配置登记)
```

不想手写配置? 用命令添加/删除:

```bash
pitchfork daemons add vcp-main -- node server.js        # 写入最近的 pitchfork.toml
pitchfork daemons add vcp-main --run 'node server.js' --retry 3
pitchfork daemons add vcp-main --run 'node server.js' --global   # 写入用户全局配置
pitchfork daemons remove vcp-main
```

## 5.7 杀掉 Supervisor(对应 `pm2 kill`)

```bash
pitchfork supervisor stop        # 停止 Supervisor(等价 pm2 kill)
pitchfork supervisor start       # 重新启动
pitchfork supervisor status      # 查看运行状态
```

换 Node 版本等需要清场时, `pitchfork supervisor stop` 即可: Supervisor 退出前会**先停掉所有 daemon**(这就是它等价 `pm2 kill` 的原因). 下次任何命令会自动拉起 Supervisor, 但 daemon 不会自己回来, 需要 `pitchfork start --all`(靠 `auto` / `boot_start` 的除外).

## 5.8 开机自启(对应 `pm2 startup` + `pm2 save`)

```bash
pitchfork boot enable            # 生成 systemd 用户服务 / LaunchAgent(等价 pm2 startup)
sudo pitchfork boot enable       # 系统级(开机即启动, 所有用户)
pitchfork boot disable
pitchfork boot status
```

然后在全局配置里标记要随开机启动的 daemon:

```toml
# ~/.config/pitchfork/config.toml
[daemons.vcp-main]
run = "node server.js"
boot_start = true
```

**pm2 需要 `pm2 save` 配合 `pm2 startup` 才有用; Pitchfork 的配置本身就是持久的, `boot_start = true` 一个字段搞定.**  
用 mise/brew 这类版本化安装路径时, `settings.boot.executable` 可固定启动用的二进制路径, 升级版本后启动单元不用重写.

## 5.9 禁用与等待(disable / enable / wait)

```bash
pitchfork disable vcp-main    # 别名: pitchfork d; 禁用后手动启动, cron, 重试, 开机自启都不会拉起
pitchfork enable vcp-main     # 别名: pitchfork e; 恢复
pitchfork wait vcp-main       # 别名: pitchfork w; 阻塞到 daemon 停止, 期间实时输出日志
pitchfork wait --group backend
pitchfork wait --kill vcp-main  # 等待期间收到信号, 先按依赖逆序优雅停掉再退出
```

`wait` 面向脚本: 全部正常退出返回 0, 否则返回第一个失败 daemon 的退出码; daemon 被文件监听或 `restart` 重启时会跟着新进程继续等(`--exit-on-restart` 则立刻返回).

---

# 6. 进阶功能

## 6.1 就绪检查(Ready Checks) -- pm2 没有的杀手锏

`pitchfork start/run` 会**等 daemon 真正就绪才返回**. 5 种检查方式:

```toml
# 方式 1: 延时(默认 3 秒, 无其他检查时的兜底)
[daemons.vcp-main]
run = "node server.js"
ready_delay = 5

# 方式 2: 输出正则匹配
[daemons.postgres]
run = "postgres -D /var/lib/pgsql/data"
ready_output = "database system is ready to accept connections"

# 方式 3: HTTP 健康检查
[daemons.vcp-main]
run = "node server.js"
ready_http = "http://localhost:8080/health"

# 方式 4: TCP 端口监听
[daemons.vcp-main]
run = "node server.js"
ready_port = 8080

# 方式 5: 自定义命令(退出码 0 = 就绪)
[daemons.redis]
run = "redis-server"
ready_cmd = "redis-cli ping"
```

几点补充:

- 每种检查都可写成对象形式加超时, 如 `ready_http = { url = "...", timeout = "30s" }`; `ready_cmd` 还支持数组形式, 直接执行程序, 不经过 shell.
- 配了多个检查时**任意一个通过即就绪**, `ready_delay` 只在没有其他检查时兜底.
- 默认延时 3 秒可用 `[settings.general] ready_delay = "5"` 全局改(daemon 级优先).
- 命令行临时指定: `pitchfork start vcp-main --http http://localhost:8080/health`(另有 `--cmd` / `--port` / `--delay` / `--output`).

## 6.2 健康检查(Health Checks) -- 就绪之后持续探测

就绪只管启动, 健康检查管运行期: 周期探测, 连续失败就杀掉, 配上 `retry` 即可自愈.

```toml
[daemons.vcp-main]
run = "node server.js"
ready_http = "http://localhost:8080/health"
health_http = { url = "http://localhost:8080/health", interval = "10s", timeout = "5s", retries = 3 }
retry = 3
```

三种探测, 都有字符串简写(如 `health_port = 6379`): `health_http`(默认任意 2xx, `status = [200]` 可指定), `health_cmd`(退出码 0 = 健康, 支持数组免 shell), `health_port`(TCP 连接成功).

- `interval` 默认 10s, `retries` 默认 3(连续失败次数, 成功即清零)
- 全局默认在 `[settings.supervisor]`: `health_check_interval` / `health_check_retries` / `health_*_timeout`
- 没配 `retry` 时, 不健康的 daemon 只会被标成 errored, 不会重启
- CLI 临时覆盖: `pitchfork start vcp-main --health-http http://localhost:8080/health`

## 6.3 依赖编排(depends)

```toml
[daemons.database]
run = "postgres -D /var/lib/pgsql/data"
ready_port = 5432

[daemons.cache]
run = "redis-server"
ready_port = 6379

[daemons.vcp-main]
run = "node server.js"
depends = ["database", "cache"]    # 自动先启动依赖, 同层并行
ready_http = "http://localhost:8080/health"
```

`pitchfork start vcp-main` 会自动按 `database + cache(并行) → vcp-main` 的顺序启动, 已运行的依赖跳过. 支持传递依赖, 循环检测.

前置的一次性任务用 `oneshot = true`, 退出码 0 即算完成, 依赖它的 daemon 才继续启动(迁移, 初始化脚本常用):

```toml
[daemons.migrate]
run = "npm run migrate"
oneshot = true
depends = ["database"]

[daemons.vcp-main]
run = "node server.js"
depends = ["migrate"]    # migrate 成功才会启动
```

状态是 `completed` / `errored`; 不能和 `ready_*` / `health_*` 同用; 完成状态不跨启动缓存, 下次 `start`/`restart` 还会再跑, 命令要可重复执行.

## 6.4 崩溃自动重启(retry)

```toml
[daemons.vcp-main]
run = "node server.js"
retry = 3        # 崩溃后最多重试 3 次(共 4 次尝试)
# retry = true  # 无限重试
```

- **启动期失败**(就绪检查通过前): 同步重试, 指数退避(1s → 2s → 4s → ...), `start` 命令会阻塞等待
- **运行期崩溃**(就绪后): Supervisor 在后台异步重试(默认每 10s 巡检一次)

## 6.5 文件监听自动重启(watch)

```toml
[daemons.vcp-main]
run = "node server.js"
watch = ["src/**/*.ts", "package.json"]   # glob 变化 → 自动重启
```

- 只重启**正在运行**的 daemon(手动停掉的不理)
- 变化防抖 1 秒, 避免频繁重启
- 后端可选 native(默认)/ poll / auto

## 6.6 Cron 调度(比 pm2 cron_restart 更完整)

```toml
# 简写形式
[daemons.backup]
run = "./backup.sh"
cron = "0 0 2 * * *"    # 每天凌晨 2 点(6 字段: 秒 分 时 日 月 周)

# 完整形式
[daemons.backup]
run = "./backup.sh"
cron = { schedule = "0 */5 * * * *", retrigger = "always" }
```

`retrigger` 策略: `finish`(默认, 上一次跑完才再触发)/ `always` / `success` / `fail`.  
`immediate = true` 会回看 10 秒补上刚错过的触发点(不等于"立刻跑一次"); `pitchfork status backup` 可看 `Last run` / `Next run`(过期标 overdue).

## 6.7 生命周期钩子(hooks)

```toml
[daemons.vcp-main]
run = "node server.js"
retry = 3

[daemons.vcp-main.hooks]
on_ready = "curl -X POST https://alerts.example.com/ready"
on_fail  = "./scripts/cleanup.sh"
on_retry = "echo 'retrying...'"
on_stop  = "echo 'stopped'"
on_exit  = "echo 'exited'"
```

钩子命令可获得 `PITCHFORK_DAEMON_ID`, `PITCHFORK_RETRY_COUNT`, `PITCHFORK_EXIT_CODE`, `PITCHFORK_EXIT_REASON`, `PITCHFORK_PORT0..N` 等环境变量; `on_output` 还能拿 `PITCHFORK_MATCHED_LINE`, 并支持 `filter` / `debounce` 写成对象形式.  
注意 `on_exit` 在配了 `retry` 时只在重试耗尽后触发, 每次失败想响应用 `on_retry`.

## 6.8 资源限制, 端口管理与反向代理

```toml
[daemons.vcp-main]
run = "node server.js"

memory_limit = "512MB"      # RSS 超限自动杀(进程组)
cpu_limit = 80              # 连续 3 次采样超过 80% 单核才杀(避免误杀瞬时尖峰)

port = { expect = [3000], bump = 10 }     # 3000 被占用自动往后试 10 个; bump = true 表示不限次数
# 多端口写 port = [8080, 8443]; 解析结果注入 $PORT($PORT0), $PORT1, run/ready_cmd/health_cmd 里都能用
```

反向代理: 打开后, 每个带 `port` 的**项目** daemon 自动获得稳定域名, 如 `https://vcp-main.vcp.localhost` → `localhost:8080`:

```toml
[settings.proxy]
enable = true
```

首次使用先跑一次系统配置:

```bash
pitchfork proxy setup --dry-run   # 预览: 本机 DNS, CA 信任, 443 端口
pitchfork proxy setup
pitchfork proxy doctor            # 诊断域名解析与 HTTPS 信任
pitchfork proxy status            # 列出当前 hostname 与状态
```

daemon 级用 `proxy = false` 关掉自动域名, 或用 `proxy = "label"` 改标签; 旧的 `[slugs]` 机制仍可用但已过时.

## 6.9 分组

```toml
[groups.backend]
daemons = ["vcp-main", "vcp-admin"]

[groups.all]
daemons = ["postgres", "redis", "vcp-main", "vcp-admin"]
```

```bash
pitchfork start --group backend
pitchfork restart --group backend
pitchfork stop --group backend
```

## 6.10 配置模板(Tera)

配置字段里可以引用其他 daemon 的运行时值, 按依赖顺序在启动前渲染, 端口被 bump 之后也能对上:

```toml
[daemons.database]
run = "postgres -D data"
port = { expect = [5432], bump = 10 }

[daemons.vcp-main]
run = "node server.js"
env = { DATABASE_URL = "postgres://localhost:{{ daemons.database.port }}" }
depends = ["database"]
```

可用字段: `run`, `env`, hooks, `ready_*`, `health_*`; 自身信息用 `{{ name }}` / `{{ id }}` / `{{ namespace }}` / `{{ url }}` 等. 后层 daemon 才能引用先启动的值.

## 6.11 Shell Hook: 进目录自动起, 出目录自动停

把 hook 装进 shell:

```bash
echo 'eval "$(pitchfork activate bash)"' >> ~/.bashrc
echo 'eval "$(pitchfork activate zsh)"' >> ~/.zshrc
echo 'pitchfork activate fish | source' >> ~/.config/fish/config.fish
```

配置自动启停:

```toml
[daemons.vcp-main]
run = "node server.js"
auto = ["start", "stop"]   # 进目录自动启动, 离开自动停止
```

- `["start"]`: 只自动启动(离开不停止)
- `["stop"]`: 手动启动, 离开自动停止
- 离开目录后不会立即停, 会等 `general.autostop_delay`(默认 1 分钟, 防止你只是路过); 所有终端都离开才停
- IDE 也可以用 `pitchfork project enter --pid <pid>` / `project leave` 接入同样的机制, 宿主进程崩溃时自动清理(Unix)

---

# 7. 界面: TUI / Web UI / MCP

```bash
pitchfork tui      # 终端仪表盘: 实时状态, CPU/内存, 模糊搜索, vim 键位, 批量操作, 内置配置编辑器
```

Web UI **默认关闭**, 临时开一次:

```bash
pitchfork supervisor run --web-port 3120    # 前台
```

持久开(写进用户配置, 改完要重启 Supervisor 才生效):

```toml
# ~/.config/pitchfork/config.toml
[settings.web]
auto_start = true
bind_port = 3120     # 默认就是 3120, 被占用自动往后试 web.port_attempts 个
```

```bash
pitchfork supervisor start --force          # 让设置生效
```

打开 <http://127.0.0.1:3120>. Web UI 与 CLI/TUI 共用同一个 Supervisor; `[settings.api]` 的 `auto_start` + `bind_port` 可单独开 REST API.

MCP Server 走 stdio, 由 Claude/Cursor 等客户端拉起(命令就是 `pitchfork mcp`):

```json
{
  "mcpServers": {
    "pitchfork": { "command": "pitchfork", "args": ["mcp"] }
  }
}
```

提供 status / start / stop / restart / logs 等工具, 和 CLI 看到同一份状态; 客户端在项目目录内启动时可直接用短 daemon 名.

---

# 8. 与 pm2 的对比

## 8.1 命令对照表(重点)

| 你的 pm2 用法                              | Pitchfork 等价命令                                                         | 说明                                     |
| ------------------------------------------ | -------------------------------------------------------------------------- | ---------------------------------------- |
| `pm2 status`                               | `pitchfork list`(别名 `ls`)                                                | 表格列出所有 daemon                      |
| `pm2 jlist`                                | `pitchfork list --json` / `pitchfork status <id> --json`                   | JSON 详情                                |
| `pm2 logs vcp-main`                        | `pitchfork logs vcp-main -t`                                               | 实时跟随                                 |
| `pm2 logs vcp-main --lines 100 --nostream` | `pitchfork logs vcp-main -n 100`                                           | 最近 100 行                              |
| `tail -f ~/.pm2/logs/vcp-main-out.log`     | `pitchfork logs vcp-main -t`                                               | 日志在 SQLite 里, 用命令读               |
| `tail -f ~/.pm2/logs/vcp-main-error.log`   | `pitchfork logs vcp-main --level error`                                    | 只看错误(结构化日志)                     |
| `pm2 restart vcp-main`                     | `pitchfork restart vcp-main`                                               | 停止 + 按配置重启(带依赖)                |
| `pm2 restart vcp-main vcp-admin`           | `pitchfork restart vcp-main vcp-admin`                                     | 同时重启多个                             |
| `pm2 stop vcp-main`                        | `pitchfork stop vcp-main`(别名 `kill`)                                     | 优雅停止(SIGTERM → SIGKILL)              |
| `pm2 delete vcp-main`                      | 删除 `pitchfork.toml` 中配置; 残留记录 `pitchfork clean --daemon vcp-main` | 配置即进程列表, 删除 = 改配置            |
| `pm2 kill`                                 | `pitchfork supervisor stop`                                                | 杀 Supervisor(下次命令自动拉起)          |
| `pm2 save`                                 | **不需要**                                                                 | 配置天然持久化, 没有"保存进程列表"的概念 |
| `pm2 startup`                              | `pitchfork boot enable`                                                    | 生成 systemd/LaunchAgent 单元            |
| `pm2 start app.js --name vcp-main`         | `pitchfork run vcp-main -- node app.js`                                    | 一次性启动(不写配置)                     |
| `pm2 start app.js`(标准姿势)               | `pitchfork.toml` 里写 `[daemons.x] run = "..."` 再 `pitchfork start x`     | 声明式, 见 5.2                           |
| `pm2 monit`                                | `pitchfork tui`                                                            | 监控仪表盘                               |
| `pm2 describe vcp-main`                    | `pitchfork status vcp-main`                                                | 单个详情                                 |

## 8.2 设计理念差异

| 维度           | pm2                               | Pitchfork                                                             |
| -------------- | --------------------------------- | --------------------------------------------------------------------- |
| 配置文件       | `ecosystem.config.js`, 代码即配置 | `pitchfork.toml`, 纯声明式 TOML, 可读可校验                           |
| 进程列表持久化 | 需要 `pm2 save` 才会在重启后保留  | 配置即事实, 永远持久; `run` 的一次性 daemon 也记在 state 里           |
| 启动语义       | 命令驱动, 无幂等语义              | `pitchfork start` 幂等, 已运行则跳过; 要重启用 `restart` 或 `--force` |
| 语言绑定       | 面向 Node.js(也支持其他脚本)      | 完全语言无关, 任何命令都能管                                          |
| 架构           | Node 守护进程(God daemon)         | Rust 二进制 + 单二进制分发, 无运行时依赖                              |

## 8.3 功能对比表

| 功能                              | pm2                           | Pitchfork                                                   |
| --------------------------------- | ----------------------------- | ----------------------------------------------------------- |
| 语言无关                          | ⚠️ 偏 Node                    | ✅ 任意命令                                                 |
| Cluster 模式(Node 多进程负载均衡) | ✅ 内置                       | ❌ 无(多实例请配置多个 daemon, 或交给 nginx/systemd 多实例) |
| 声明式配置                        | ⚠️ JS 脚本                    | ✅ TOML                                                     |
| 就绪检查                          | ⚠️ 仅 `wait_ready` 信号       | ✅ 5 种(delay / output / http / port / cmd)                 |
| 健康检查(运行期持续探测)          | ⚠️ 无内建(靠脚本)             | ✅ health_http / health_cmd / health_port + 连续失败自愈    |
| 依赖编排(拓扑排序 + 并行启动)     | ❌                            | ✅ 含 `oneshot` 前置任务(迁移/初始化)                       |
| 崩溃自动重启                      | ✅                            | ✅(启动期同步退避 + 运行期异步)                             |
| 文件监听重启                      | ✅ `--watch`                  | ✅ glob + 防抖 + 只重启运行中的                             |
| Cron 调度                         | ⚠️ `cron_restart`(仅定时重启) | ✅ 完整 6 字段 cron + retrigger 策略 + `immediate` 补触发   |
| 生命周期钩子                      | ❌(仅事件日志)                | ✅ on_ready/on_fail/on_retry/on_stop/on_exit/on_output      |
| 资源限制                          | ⚠️ `max_memory_restart`       | ✅ memory_limit + cpu_limit(连续采样防误杀)                 |
| 端口管理/自动 bump                | ❌                            | ✅ `port` + `$PORT`/`$PORT0..N` 注入                        |
| 等待进程退出(脚本编排)            | ❌                            | ✅ `wait`(阻塞 + 顺带 tail 日志)                            |
| 环境变量                          | ✅ `env` / `--env` 环境切换   | ✅ `env` + Tera 模板 + mise 集成                            |
| 多项目隔离                        | ⚠️ 靠实例/命名                | ✅ namespace + Git worktree 自动隔离                        |
| Shell Hook 进出目录自动启停       | ❌                            | ✅                                                          |
| 日志存储                          | 文本文件(`~/.pm2/logs/`)      | SQLite + 结构化解析 + 时间/级别/字段过滤 + 轮转             |
| 开机自启                          | `pm2 startup` + `pm2 save`    | `pitchfork boot enable` + `boot_start = true`               |
| 监控界面                          | `pm2 monit` / PM2+ 云端       | TUI + Web UI(默认关闭, 按需开)                              |
| 远程部署                          | ✅ `pm2 deploy`               | ❌(用 systemd/ansible 等)                                   |
| 容器场景                          | ⚠️ 可跑但无 PID 1 支持        | ✅ container 模式(PID 1, 僵尸回收, 信号转发)                |
| AI 集成                           | ❌                            | ✅ MCP Server                                               |
| 反向代理                          | ❌                            | ✅ 自动 hostname + `proxy setup/doctor/trust`               |
| 生态成熟度                        | ✅✅ 多年生产验证             | ⚠️ 较新(v2.30.1, 活跃开发中)                                |

## 8.4 什么时候用哪个

**继续用 pm2 的场景:**

- 生产服务器上托管 Node.js 应用, 需要 **cluster 多进程负载均衡**
- 需要 `pm2 deploy` 做远程一键部署
- 团队/运维已经标准化在 pm2 生态(PM2+ 云端监控等)
- 需要 Node 进程的精细化重启策略(`max_memory_restart`, `autorestart` 等)

**用 Pitchfork 的场景:**

- 本地开发: 一套命令管数据库 + API + 前端 + worker 等**混合语言**服务
- 想要"进目录自动起, 出目录自动停"的开发流
- 想要声明式配置进 git, 团队成员 clone 下来 `pitchfork start --all` 即得环境
- 需要就绪检查 + 依赖编排保证服务真正可用再继续
- 不想装 Node 环境, 想要单一 Rust 二进制的工具
- 容器 entrypoint, 通用后台任务, cron 任务调度
- 想给每个服务固定本地 HTTPS 域名(`https://api.project.localhost`)直接点开调试

---

# 9. 从 pm2 迁移(以 vcp-main / vcp-admin 为例)

假设你现在的 pm2 配置是这样的:

```bash
pm2 start server.js --name vcp-main
pm2 start admin.js --name vcp-admin
pm2 save
```

## 步骤 1: 安装并初始化

```bash
mise use -g pitchfork
```

## 步骤 2: 写 pitchfork.toml

在项目根目录创建:

```toml
# pitchfork.toml
[daemons.vcp-main]
run = "node server.js"
dir = "main"
env = { NODE_ENV = "production" }
retry = 3
ready_http = "http://localhost:8080/health"

[daemons.vcp-admin]
run = "node admin.js"
dir = "admin"
retry = 3
ready_http = "http://localhost:4000/health"
```

## 步骤 3: 停掉 pm2, 交给 pitchfork

```bash
pm2 delete vcp-main vcp-admin
# 或: pm2 kill(连同 pm2 守护进程一起停)

pitchfork start --all        # 启动配置里的全部 daemon
pitchfork list               # 确认状态
```

## 步骤 4: 日常操作对照

```bash
pitchfork status vcp-main              # 看状态
pitchfork logs vcp-main -n 100         # 最近 100 行日志
pitchfork logs vcp-main -t             # 实时日志
pitchfork restart vcp-main vcp-admin   # 配置修改后重启
pitchfork stop vcp-main                # 停止
```

## 步骤 5(可选): 开机自启

```bash
pitchfork boot enable
# 并在 pitchfork.toml / ~/.config/pitchfork/config.toml 中给 daemon 加 boot_start = true
```

## 步骤 6(可选): 更多 pm2 没有的能力

```toml
[daemons.vcp-main]
run = "node server.js"
depends = ["postgres", "redis"]                # 依赖编排
health_http = "http://localhost:8080/health"   # 运行期健康检查
watch = ["src/**/*.js"]                        # 改代码自动重启
cron = "0 0 3 * * *"                           # 定时任务
```

---

# 10. 常见问题

**Q: pitchfork start 提示已在运行, 想重启怎么办?**  
A: 用 `pitchfork restart vcp-main` 或 `pitchfork start vcp-main --force`.

**Q: 日志在哪个文件? 我想 tail -f.**  
A: 日志在 SQLite(`~/.local/state/pitchfork/logs/logs.db`)里, 没有文本文件. 实时看用 `pitchfork logs vcp-main -t`, 导出用 `pitchfork logs vcp-main --raw > vcp-main.log`.

**Q: 怎么对应 pm2 kill?**  
A: `pitchfork supervisor stop`. 它会先停掉所有 daemon 再退出; 下次任何命令会自动重启 Supervisor, 之后用 `pitchfork start --all` 恢复服务.

**Q: run 起来的一次性 daemon, 重启机器后还在吗?**  
A: 进程不会自己回来, 只有状态记录持久化在 state.toml. 要常驻就写进 `pitchfork.toml` 并加 `boot_start = true`, 这才是声明式管理的正确姿势.

**Q: 需要 Node 的 cluster 多进程模式, 怎么办?**  
A: Pitchfork 不做进程集群. 可以配置多个 daemon 实例, 或用 nginx/系统负载均衡. 这是 pm2 的核心差异化能力, 迁移时请评估.

**Q: 换 Node 版本后?**  
A: 和 pm2 kill 类似, `pitchfork supervisor stop && pitchfork start --all`(如有需要再 `pitchfork boot disable && boot enable` 重新生成启动单元).

**Q: Web UI 打不开?**  
A: Web UI 默认关闭. 临时用 `pitchfork supervisor run --web-port 3120`, 持久用配置 `[settings.web] auto_start = true` 后 `pitchfork supervisor start --force`, 见 7.

**Q: 想暂时不让某个 daemon 跑, 又不想删配置?**  
A: `pitchfork disable vcp-main`(别名 `d`). 禁用后手动启动, cron, 重试, 开机自启都不会拉起; `pitchfork enable vcp-main` 恢复.

**Q: 更多资料?**  
A: 官方文档 <https://pitchfork.jdx.dev>; 指南 <https://pitchfork.jdx.dev/guides>; CLI 参考 <https://pitchfork.jdx.dev/cli>; 配置文件参考 <https://pitchfork.jdx.dev/reference/configuration>.

---

_本教程依据 pitchfork v2.30.1 源码与官方文档编写._
