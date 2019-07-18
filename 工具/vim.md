[toc]
# 替换
>:{作用范围}s/{目标}/{替换}/{替换标志}

例如:%s/foo/bar/g会在全局范围(%)查找foo并替换为bar，所有出现都会被替换（g）
# vim 状态栏中文乱码
在.vimrc中添加
``` bash
set termencoding=utf-8
```