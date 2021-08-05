# markdown

[TOC]
## 注释

 <!--aaaa-->

## 高亮

==高亮==

## 代码

`import` 

```go
import os
import fmt

int main() {
  fmt.Println("hello")
}
```

## 删除线

~~删除我~~



## mermaid

### 流程图
``` mermaid
graph TD
A[查zcache]-->|需要充cache|B[写入压力文件]
C[从压力文件中读数据]-->D[放入压力队列]

E[请求压力]-->F[从压力队列中取一个请求]
F-->|存在压力|G{ZCACHE节点压力超限}
F-->|不存在压力|I[sleep后更新压力源]
G-->|超限|H[请求放回压力队列]
H-->F
G-->|不超限|J[返回压力]
J-->K(成功)
```
### 时序图
``` mermaid
sequenceDiagram
A->> B: Query
B->> C: Forward query
Note right of C: Thinking...
C->> B: Response
B->> A: Forward response
```
### 甘特图
``` mermaid
gantt
dateFormat  YYYY-MM-DD
title Shop项目交付计划
 
section 里程碑 0.1 
数据库设计          :active,    p1, 2016-08-15, 3d
详细设计            :           p2, after p1, 2d
 
section 里程碑 0.2
后端开发            :           p3, 2016-08-22, 20d
前端开发            :           p4, 2016-08-22, 15d
 
section 里程碑 0.3
功能测试            :       p6, after p3, 5d
上线               :       p7, after p6, 2d
交付               :       p8, afterp7, 20d
```