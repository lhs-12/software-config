<h1><center>New-API</center></h1>

# 使用

```bash
cd ~/software-config/Container/Docker/new-api # 进入目录
docker compose up -d # 启动服务
docker compose down  # 关闭服务

# 访问: http://localhost:3000

# 更新
cd ~/software-config/Container/Docker/new-api && docker compose pull && docker compose down && docker compose up -d

# 查看日志
docker compose logs -f
docker compose logs -f new-api
docker compose logs -f postgres-new-api
docker compose logs -f redis-new-api
```

# 配置

首次进入, 设置管理员账号, 选自用模式.

- `渠道管理` 添加各种渠道, 需要填写: 类型, 名称, 密钥, URL, 模型
- `令牌管理` 添加新令牌

# 自定义配置

相比[官方compose.yml](https://raw.githubusercontent.com/QuantumNous/new-api/main/docker-compose.yml)的修改:

| 配置项         | 说明                                                                                      |
| -------------- | ----------------------------------------------------------------------------------------- |
| version 字段   | 删除废弃的 compose `version` 字段                                                         |
| data/logs 挂载 | `./data` 和 `./logs` 改到 `~/data-container/docker/new-api` 目录下                        |
| postgres 挂载  | 取消 named volume `pg_data`, 改用 bind mount 到 `~/data-container/docker/new-api/pg_data` |
| 容器名         | 添加 `-new-api` 后缀, 防止冲突                                                            |
| 网络           | 添加 ipam 子网 `172.20.0.0/16`, 防止和代理软件冲突                                        |

# 数据备份

数据已使用 bind mount, 直接备份 `~/data-container/docker/new-api` 目录即可,  
其中最关键的是 postgres 数据: `pg_data`,  
但注意仅在数据库停止时使用(运行时直接复制可能导致数据有问题)

```bash
# 更稳妥的方式: 用 pg_dump 备份 (可在运行时使用)
docker exec postgres-new-api pg_dump -U root new-api > ~/data-container/docker/new-api/backup_$(date +%Y%m%d_%H%M%S).sql
# 恢复 (先清空数据库再导入)
docker exec postgres-new-api psql -U root -d new-api -c "DROP SCHEMA public CASCADE; CREATE SCHEMA public; GRANT ALL ON SCHEMA public TO root; GRANT ALL ON SCHEMA public TO public;"
docker exec -i postgres-new-api psql -U root new-api < backup.sql
```

# 常用渠道

- [魔搭](https://modelscope.cn)
- [Gitee](https://ai.gitee.com/serverless-api)
