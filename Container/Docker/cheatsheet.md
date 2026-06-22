<h1><center>Docker 常用命令</center></h1>

镜像

```bash
docker images                 # 列出本地镜像
docker pull <image>           # 拉取镜像
docker rmi <image>            # 删除镜像
docker system prune -a        # 清理未使用的镜像和容器
```

容器生命周期

```bash
docker compose up -d          # 启动(后台)
docker compose down           # 停止并删除容器
docker compose down -v        # 停止并删除容器和数据卷
docker compose restart        # 重启
docker compose ps             # 查看状态
docker compose exec <svc> sh  # 进入容器
```

更新

```bash
# 进入 docker-compose.yml 的目录执行
docker compose pull && docker compose down && docker compose up -d  # 拉取+重启
```

日志

```bash
docker compose logs -f                    # 全部服务实时日志
docker compose logs -f <svc>              # 指定服务日志
docker compose logs --tail=100 <svc>      # 仅查看最近100行
docker compose logs --since=10m <svc>     # 查看最近10分钟的日志
docker compose logs -f -t <svc>           # 显示时间戳
docker logs -f <container>                # 使用容器名查看日志
```

数据卷

```bash
docker volume ls              # 列出卷
docker volume inspect <vol>   # 查看卷详情
```

网络

```bash
docker network ls             # 列出网络
docker network inspect <net>  # 查看网络详情
```

调试

```bash
docker logs <container>         # 查看日志
docker exec -it <container> sh  # 进入容器
docker inspect <container>      # 查看容器详情
docker stats                    # 实时资源占用
```
