<h1><center>Container</center></h1>

# 设计目标

- Linux 和 WSL 均使用相同方式安装, 配置尽量做到两边通用
- 支持新增不同运行时(如 Podman, K8s), 不影响已有结构
- 每个服务组的 compose, 配置放在一起, 一个目录搞定
- 需要区分版本时目录名能看出用的什么版本
- 仓库目录和数据卷目录结构对应, 方便定位

# 目录结构

```
Container/
├── Docker/
│   ├── mysql57-single/
│   ├── mysql57-master-slave/
│   ├── redis7-single/
│   ├── redis7-master-slave/
│   ├── redis7-sentinel/
│   ├── redis7-cluster/
│   ├── xunlei/
│   └── _archive/   # 归档
├── Podman/
└── K8s/

```

# 命名规则

`服务+版本+部署方式`, 全小写, `-` 连接:

```
mysql57-single    # 有版本并存需求, 带版本
redis7-cluster    # 同上
nginx-single      # 无版本需求, 不带版本
```

- 版本号按需加: 需要并存多版本或配置差异大时才带
- 统一加部署方式后缀(`-single`, `-cluster` 等)

# 数据卷

与仓库目录镜像, 统一放 `~/data-container/` 下, 按运行时分目录:

```
~/data-container/
├── docker/
│   ├── mysql57-single/
│   ├── mysql57-master-slave/
│   │   ├── m1-data/
│   │   └── s1-data/
│   ├── redis7-cluster/
│   │   ├── data-7001/
│   │   └── ...
│   ├── xunlei/
│   │   ├── data/
│   │   ├── cache/
│   │   └── downloads/
│   └── ...
├── podman/
└── k8s/
```

# 文件组织

每个服务目录内:

| 文件               | 说明        | 必须 |
| ------------------ | ----------- | ---- |
| 编排文件           | compose/yml | 是   |
| `*.cnf` / `*.conf` | 服务配置    | 按需 |

- 配置自包含, 不搞共享目录, 防止混乱
- 命令写在编排文件注释中, 常用命令汇总到对应运行时的 `cheatsheet.md`

# 注意事项

## 容器命名

Docker/Podman Compose 默认容器名格式: `<项目名>-<服务名>-<序号>`

- 项目名 = compose 所在目录名
- 服务名 = yml 中定义的 service name
- 序号 = 从 1 开始

例: 目录 `redis7-cluster`, 服务 `redis-1` → 容器名 `redis7-cluster-redis-1-1`

查看容器名: `docker compose ps`

## 容器网络与 DNS

bridge 网络中, 容器之间通过服务名解析. 但停止的容器会从 DNS 中移除, 导致其他容器无法通过服务名访问.

影响场景:
- Redis Sentinel: 主节点停止后, 哨兵和从节点无法解析主机名, 故障转移失败
- 任何依赖服务名通信的场景

解决方案: 创建自定义子网, 并在编排文件中为容器指定固定 IP, 不依赖 DNS. 注意子网地址不能和已有网络冲突.

## host 网络模式

`network_mode: host` 让容器直接使用宿主机网络栈, 没有端口映射.

适用场景:
- Redis Cluster: 所有节点共享网络, `127.0.0.1` 互达, 彻底避免 DNS 和端口映射问题

注意事项: 容器端口不要冲突
