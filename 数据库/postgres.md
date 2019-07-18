# postgres
[toc]
## 安装
jumbo install postgresql
## 配置
```bash
initdb -D /home/work/postgresql/data #初始化
 pg_ctl -D /home/work/postgresql/data -l logfile start #启动
```
会自动生成配置，在data下

## 操作
### 创建db
```bash
createdb dongfeng
```
### 操作用户
```bash
createuser worrk #添加用户
dropuser worrk #删除用户
```
### 连接
```bash
psql -d dongfeng #连接数据库dongfeng
\password  # 设置数据库密码
```
### 常用命令
```bash
# 创建表
CREATE TABLE resources(datetime timestamp NOT NULL, idc varchar(15) NOT NULL, resource jsonb) 
# 显示表
\d
# 创建新表 
CREATE TABLE user_tbl(name VARCHAR(20), signup_date DATE);
# 插入数据 
INSERT INTO user_tbl(name, signup_date) VALUES('张三', '2013-12-22');
# 选择记录 
SELECT * FROM user_tbl;
# 更新数据 
UPDATE user_tbl set name = '李四' WHERE name = '张三';
# 删除记录 
DELETE FROM user_tbl WHERE name = '李四' ;
# 添加栏位 
ALTER TABLE user_tbl ADD email VARCHAR(40);
# 更新结构 
ALTER TABLE user_tbl ALTER COLUMN signup_date SET NOT NULL;
# 更名栏位 
ALTER TABLE user_tbl RENAME COLUMN signup_date TO signup;
# 删除栏位 
ALTER TABLE user_tbl DROP COLUMN email;
# 表格更名 
ALTER TABLE user_tbl RENAME TO backup_tbl;
# 删除表格 
DROP TABLE IF EXISTS backup_tbl;
```
### 设置多主键
```bash
 CREATE TABLE resources(datetime bigint NOT NULL, idc varchar(15) NOT NULL, resource jsonb, PRIMARY KEY(idc, datetime));
```

### 更新
```bash
#非重复插入，注意ON CONFLICT 后必须跟主键或者唯一性约束
INSERT INTO resources(idc, datetime, resource) VALUES($1,$2,$3) ON CONFLICT(idc, datetime) DO NOTHING
#插入或更新
INSERT INTO resources(idc, datetime, resource) VALUES($1,$2,$3) ON CONFLICT(idc, datetime) DO UPDATE SET resource = $3
```

## 配置 
### pg_hba.conf  [参见](https://blog.csdn.net/yaoqiancuo3276/article/details/80404883)
- TYPE 参数设置
```bash
TYPE 表示主机类型，值可能为：
若为 `local` 表示是unix-domain的socket连接，
若为 `host` 是TCP/IP socket 
若为 `hostssl` 是SSL加密的TCP/IP socket
```
- DATABASE 参数设置
```bash
DATABASE 表示数据库名称,值可能为：
`all` ,`sameuser`,`samerole`,`replication`,`数据库名称` ,或者多个
数据库名称用 `逗号`，注意ALL不匹配 replication
```
- USER 参数设置
```bash
 USER 表示用户名称，值可以为：
 `all`,`一个用户名`，`一组用户名` ，多个用户时，可以用 `,`逗号隔开，
 或者在用户名称前缀 `+` ;在USER和DATABASE字段，也可以写一个单独的
 文件名称用 `@` 前缀，该文件包含数据库名称或用户名称
```
- ADDRESS 参数设置
```bash
该参数可以为 `主机名称` 或者`IP/32(IPV4) `或 `IP/128(IPV6)`，主机
名称以 `.`开头，`samehost`或`samenet` 匹配任意Ip地址
```
- METHOD 参数设置
```bash
该值可以为"trust", "reject", "md5", "password", "scram-sha-256",
"gss", "sspi", "ident", "peer", "pam", "ldap", "radius" or "cert"
注意 若为`password`则发送的为明文密码
```
- 注意
```bash
修改该配置文件中的参数，必须重启 `postgreSql`服务,若要允许其它IP地址访问
该主机数据库，则必须修改 `postgresql.conf` 中的参数 `listen_addresses` 为 `*`
重启：pg_ctl reload 或者 执行 SELECT pg_reload_conf()
```

## 问题
### Connection refused
- data/postgresql.conf 下添加
    listen_addresses = '*'
- data/pg_hba.conf 下添加
  host    all             all             0.0.0.0/0               md5