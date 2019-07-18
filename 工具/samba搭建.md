## samba安装

* 下载源码：wget "http://hetu.baidu.com:80/api/tool/getFile?toolId=1145&fileId=925" -O "samba-3.5.8.tar.gz" 
* 编译安装，多线程编译会出现连接bin/net失败，单线程编译就好了：cd samba-3.5.8/source3 && ./configure && make && make install
* 配置：cd /usr/local/samba/ （默认安装到该路径下）
vi lib/smb.conf（默认的配置文件路径），workgroup、netbios、server string都不用配置
* 设置密码：LD_LIBRARY_PATH=/usr/local/samba/lib /usr/local/samba/bin/smbpasswd -a zhangliqiang01
* 启动：LD_LIBRARY_PATH=/usr/local/samba/lib /usr/local/samba/sbin/smbd -D
* 查看：ps auxf | grep smbd

## 注意：

valid users要和设置密码中的用户名相同
一般是root用户启动smbd的进程，所以path设置到哪个级别都行
windows连接输入网络地址格式：\\${host}\xxx，xxx必须写，随便写一个就行