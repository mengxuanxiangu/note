[TOC]
# 语法

## 循环

### 数组遍历

```python
#方法一
for i in arr:
  print i, arr[i]

# 方法二
for i in range(0,9):
  print i, arr[i]
```

# md5 计算

``` python
import hashlib
import sys

if __name__ == '__main__':
    if len(sys.argv)!= 2:
        sys.exit('argv error!')

    m = hashlib.md5()
    n = 1024*4
    inp = open(sys.argv[1],'rb')
    while True:
        buf = inp.read(n)
        if buf:
            m.update(buf)
        else:
            break
    print m.hexdigest()
```

# 格式转换

## 字符串转数据

``` python

```



## 进制转换

### int 转 二进制

``` python
    b = bin(32768).replace("0b", "")
```
### ip int转string

```python
import socket
import struct
import sys
print socket.inet_ntoa(struct.pack("!I", int(sys.argv[1])))
```



# datetime

## 获取当前时间
```python
import datetime
nowTime=datetime.datetime.now().strftime('%Y-%m-%d %H:%M:%S')#现在
pastTime = (datetime.datetime.now()-datetime.timedelta(hours=1)).strftime('%Y-%m-%d %H:%M:%S')#过去一小时时间
afterTomorrowTime = (datetime.datetime.now()+datetime.timedelta(days=2)).strftime('%Y-%m-%d %H:%M:%S')#后天
tomorrowTime = (datetime.datetime.now()+datetime.timedelta(days=1)).strftime('%Y-%m-%d %H:%M:%S')#明天
```
## string 转时间
``` python
import datetime
detester = '2017-01-01'
date = datetime.datetime.strptime(detester, '%Y-%m-%d')
```
## 时间转 string
``` python
import datetime
date = datetime.now()
detester = date.strftime(‘%Y-%m-%d')
```
# string

## 数组转字符串

```python
arr = [1, 2, 3]
print ",".join(arr)
```
## 判断子串

```python
a = "abc"
b = "bc"
print b in a
```

## int转ip

```python
import socket
import struct
import sys
data = int(sys.argv[1])
ip = data >> 32
ipstr = socket.inet_ntoa(struct.pack("!I", ip))
token = ipstr.split('.')
print ".".join(reversed(list(token)))
```

## 字符串逆序

```python
str = "abcde"
print ".".join(reversed(list(str)))
```

# logging

## 日志切割
使用TimedRotatingFileHandler
```python
    logger = logging.getLogger('record')
    logger.setLevel(level)
    recordFormat = "%(message)s"
    recordFormatter = logging.Formatter(recordFormat)
    handler = logging.handlers.TimedRotatingFileHandler(log_path + "record.log", when='S', backupCount=4)
    handler.suffix = "%Y%m%d%H%S"
    handler.setFormatter(recordFormatter)
    logger.addHandler(handler)
```
## 设置日志日期后缀
```python
    handler.suffix = "%Y%m%d%H%S"
```

## 设置日志内容
```python
format="%(levelname)s: %(asctime)s.%(msecs)d: %(module)s * %(thread)d %(message)s <%(filename)s:%(lineno)d>"
```
# 命令行解析
## 格式

```python
import argparse
parser = argparse.ArgumentParser(description='adjust bs app quota')
parser.add_argument('-c', '--cluster', required = True, help = 'the cluster')
parser.add_argument('-p', '--percent', required = False, action = 'store_true',help = 'use percent or absolute value')
args = parser.parse_args()
```
## 无值参数

只要添加action = 'store_true'

#文件

## 文件读写

```python
with open(data_file, 'r') as f:
    lines = f.readlines()
```

## 画图

```python
# !/usr/bin/env python
# -*- coding:utf-8 -*-
import time

import matplotlib.pyplot as plt
import requests
import json

ax = []                    
ay = []                    
plt.ion()                  
while True:
    # import pdb;pdb.set_trace()
    resp = requests.get("http://xx/FrequencyService/info?key=3b5bd1565a1f456e9d9f0b400389765f")
    now = int(time.time())
    dic = json.loads(resp.text)
    ax.append(now)
    ay.append(dic["info"]["download"])
    plt.clf()              
    plt.plot(ax,ay)        
    plt.pause(0.1)         
    plt.ioff()             
    time.sleep(1)
    
```

