# tmux 中文乱码
在.bashrc中添加以下
```
export LANG="zh_CN.UTF-8"
```
不能加
```
export LC_ALL="zh_CN.UTF-8"
```
注意：
系统的bash版本需要和tmux指定的一致

