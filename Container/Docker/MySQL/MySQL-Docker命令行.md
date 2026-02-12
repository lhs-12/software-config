# MySQL(单节点)

如果使用了WSL2的mirrored网络模式, 客户端连接的时候要加ssl参数, 不然很慢
```
docker pull mysql:5.7

docker run -itd ^
--name mysql5.7 ^
-p 3306:3306 ^
-v D:/ProgramData/mysql/mysql-data:/var/lib/mysql ^
-v D:/ProgramData/mysql/my.cnf:/etc/mysql/my.cnf ^
-e MYSQL_ROOT_PASSWORD=root ^
percona/percona-server:5.7

以下是my.cnf配置
注意: mysql会忽略具有任意操作权限的配置文件, 所以使用mysql的时候,需要改my.cnf的权限 -> 右键my.cnf, 属性, 设置为只读

[mysqld]
skip-name-resolve
pid-file = /var/run/mysqld/mysqld.pid
socket = /var/run/mysqld/mysqld.sock
datadir = /var/lib/mysql
character-set-server = utf8mb4
default-storage-engine = INNODB
lower_case_table_names=1
[mysql]
default-character-set = utf8mb4
[client]
default-character-set = utf8mb4
```

# MySQL(主从)

使用WSL网络模式为mirrored

```
拉取镜像
docker pull percona/percona-server:5.7

搭建主一节点
docker run -itd --name percona-m1 ^
-v D:/ProgramData/mysql/mysql-data-m1:/var/lib/mysql ^
-v D:/ProgramData/mysql/my-m1.cnf:/etc/mysql/my.cnf ^
-p 13306:3306 ^
-e MYSQL_ROOT_PASSWORD=root ^
percona/percona-server:5.7

主一配置
[mysqld]
skip-name-resolve
pid-file = /var/run/mysqld/mysqld.pid
socket = /var/run/mysqld/mysqld.sock
datadir = /var/lib/mysql
character-set-server = utf8mb4
default-storage-engine = INNODB
lower_case_table_names = 1
server-id = 1
log-bin=mysql-bin
[mysql]
default-character-set = utf8mb4
[client]
default-character-set = utf8mb4

主一执行SQL
grant replication slave on *.* to 'root'@'%';
flush privileges;
show master status; #拿到bin文件和位置

搭建从一节点
docker run -itd --name percona-s1 ^
-v D:/ProgramData/mysql/mysql-data-s1:/var/lib/mysql ^
-v D:/ProgramData/mysql/my-s1.cnf:/etc/mysql/my.cnf ^
-p 13307:3306 ^
-e MYSQL_ROOT_PASSWORD=root ^
percona/percona-server:5.7

从一配置
[mysqld]
skip-name-resolve
pid-file = /var/run/mysqld/mysqld.pid
socket = /var/run/mysqld/mysqld.sock
datadir = /var/lib/mysql
character-set-server = utf8mb4
default-storage-engine = INNODB
lower_case_table_names = 1
server-id = 2
[mysql]
default-character-set = utf8mb4
[client]
default-character-set = utf8mb4

从一执行SQL
CHANGE MASTER TO master_host = 'host.docker.internal',
master_user = 'root',
master_password = 'root',
master_port = 13306,
master_log_file = 'xxx', # 填入master拿到的bin文件
master_log_pos = xxx;    # 填入master拿到的bin文件位置

start slave;
show slave status; # Slave_IO_Running 和 Slave_SQL_Running 都是Yes就正常了

若要取消主从
stop slave;
reset slave;
```