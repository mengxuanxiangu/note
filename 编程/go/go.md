# go

[TOC]
## 语法

### 数组

#### 数组定义

```go
var a [3]int   //3个int型的数组，初始值是3个0,数组“零值”状态
arr:=[5]int{1,2,3,4,5}   //定义并初始化长度为5的数组
var array2 = [...]int{6, 7, 8} //不声明长度
q := [...] int {1,2,3} //不声明长度
r := [...] int {99:-1}  //长度为100的数组，只有最后一个是-1，其他都是0
regArr := make([]string, 0，15) //容量为15，长度为0
```

#### 遍历

``` go
comPressTypeArr :=[...]string {"zip", "tar", "rar", "7z"}
for i, v := range comPressTypeArr {
    fmt.Println(i, v)
}
```

### map

#### 定义

```go
    //声名再初始化
    var m1 map[string]string
    m1 = make(map[string]string)
    m1["a"] = "aa"
    
    //直接创建
    m2 := make(map[string]string)
    m2["a"] = "aa"
    
    //创建并赋值
    m3 := map[string]string{
	    "a": "aa",
	    "b": "bb",
    }
// 注意：不能取 map 成员的地址
```
#### 遍历
```go
arr := [5]int{5, 4, 3}

for index, value := range arr {
    fmt.Printf("arr[%d]=%d \n", index, value)
}

for index := 0; index < len(arr); index++ {
    fmt.Printf("arr[%d]=%d \n", index, arr[index])
}
```



#### 获取map所有值

```go
  func GetValues(infoMap map[string]*CallgraphOrderedInfo) []*CallgraphOrderedInfo {
      if infoMap == nil {
          return nil
      }
      arr := make([]*CallgraphOrderedInfo, 0, len(infoMap))
      for _, info := range infoMap {
          arr = append(arr, info)
      }
      return arr
  }
```

### 引用

#### 引用类型

go 中五种引用类型有 slice， channel， function， map， interface

### channel

#### 定义
[link](http://colobu.com/2016/04/14/Golang-Channels/)
```go
aa := make(chan int) //无缓冲区
bb := make(chan int, 100) //带缓冲区
```

### 循环
#### for
```go
package main

import "fmt"

func main() {

    // 最基本的一种，单一条件循环
    // 这个可以代替其他语言的while循环
    i := 1
    for i <= 3 {
        fmt.Println(i)
        i = i + 1
    }

    // 经典的循环条件初始化/条件判断/循环后条件变化
    for j := 7; j <= 9; j++ {
        fmt.Println(j)
    }

    // 无条件的for循环是死循环，除非你使用break跳出循环或者
    // 使用return从函数返回
    for {
        fmt.Println("loop")
        break
    }
}
```
### 匿名组合

#### 初始化

```go
type Base struct {
    Name string
}

type Child struct {
    Name string
    Base
}

func main() {
    c := &Child{
        Name: "Tom",
        Base: Base{
            Name: "Joey",
        },
    }
}
```

#### 组合函数
```go
package main

import "fmt"

type Base struct {
        Name string
}

type Child struct {
        Name string
        Base
}

func (b *Base) Hello() {
        fmt.Println("Hello ", b.Name)
}

func (b *Base) Who() {
        fmt.Println("I'm base")
}

func (c *Child) Who() {
        fmt.Println("I'm child")
}

func main() {
        c := &Child{
                Name: "Tom",
                Base: Base{
                        Name: "Joey",
                },
        }
        //若外部与内部有相同函数，默认用外部
        fmt.Println("====run c.Who()=========")
        c.Who() 
        fmt.Println("========================")
        //可使用类名强制调用内部，但内部函数只能访问内部变量
        fmt.Println("====run c.Base.Who()====")
        c.Base.Who()
        fmt.Println("========================")
        //外部继承内部的函数，但内部函数只能访问内部变量
        fmt.Println("====run c.Hello()=======")
        c.Hello()
        fmt.Println("========================")
        fmt.Println("====run c.Base.Hello()==")
        c.Base.Hello()
        fmt.Println("========================")
}
```
##### 执行结果
```
====run c.Who()=========
I'm child
========================
====run c.Base.Who()====
I'm base
========================
====run c.Hello()=======
Hello  Joey
========================
====run c.Base.Hello()==
Hello  Joey
========================
```


### 字符串

#### 字符串截取

```go
package main

import (
	"fmt"
	"strings"
)

func main() {
	fmt.Print(strings.Trim("¡¡¡Hello, Gophers!!!", "!¡"))//在参数1中，去掉参数2中的字符
  //返回 Hello, Gophers
}
```

#### 数组转字符串

```go
package main

import (
	"fmt"
	"strings"
)

func main() {
	s := []string{"foo", "bar", "baz"}
	fmt.Println(strings.Join(s, ", "))
}
```

#### 字符串分隔

```go
import "strings"

strings.Split(alert.alertInterval, SPILITTER)
```

#### 字符串拼接性能比较

分别比较了 fmt.Sprintf，string +，strings.Join，bytes.Buffer，方法是循环若干次比较总时间。

- fmt.Sprintf 和 strings.Join 速度相当
- string + 比上述二者快一倍
- bytes.Buffer又比上者快约400-500倍
- 如果循环内每次都临时声明一个bytes.Buffer来使用，会比持续存在慢50%，但是仍然很快

```go
package main

import (
        "bytes"
        "fmt"
        "strings"
        "time"
)

func benchmarkStringFunction(n int, index int) (d time.Duration) {
    v := "ni shuo wo shi bu shi tai wu liao le a?"
    var s string
    var buf bytes.Buffer
    t0 := time.Now()
    for i := 0; i < n; i++ {
      switch index {
        case 0: // fmt.Sprintf
        s = fmt.Sprintf("%s[%s]", s, v)
        case 1: // string +
        s = s + "[" + v + "]"
        case 2: // strings.Join
        s = strings.Join([]string{s, "[", v, "]"}, "")
        case 3: // temporary bytes.Buffer
        b := bytes.Buffer{}
        b.WriteString("[")
        b.WriteString(v)
        b.WriteString("]")
        s = b.String()
        case 4: // stable bytes.Buffer
        buf.WriteString("[")
        buf.WriteString(v)
        buf.WriteString("]")
      }
      if i == n-1 {
        if index == 4 { // for stable bytes.Buffer
          s = buf.String()
        }
        fmt.Println(len(s)) // consume s to avoid compiler optimization
      }
    }
    t1 := time.Now()
    d = t1.Sub(t0)
    fmt.Printf("time of way(%d)=%v\n", index, d)
    return d
}

func main() {
    k := 5
    d := [5]time.Duration{}
    for i := 0; i < k; i++ {
      	d[i] = benchmarkStringFunction(10000, i)
    }
    for i := 0; i < k-1; i++ {
      fmt.Printf("way %d is %6.1f times of way %d\n", i, float32(d[i])/float32(d[k-1]), k-1)
    }
}

/*
执行结果:
410000
time of way(0)=747.642307ms
410000
time of way(1)=345.838829ms
410000
time of way(2)=430.388426ms
41
time of way(3)=1.137297ms
410000
time of way(4)=698.248µs
way 0 is 1070.7 times of way 4
way 1 is  495.3 times of way 4
way 2 is  616.4 times of way 4
way 3 is    1.6 times of way 4
*/
```

#### 生成随机字符串

```go
package main

import (
    "fmt"
    "math/rand"
    "time"
)

var letters = []byte("abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ")

func randSeq(n int) []byte {
    r := rand.New(rand.NewSource(time.Now().UnixNano()))
    data := make([]byte, n)
    lettersLen := len(letters)
    for i := range data {
      data[i] = letters[r.Intn(lettersLen)]
    }

    return data
}
```



### select

select就是用来监听和channel有关的IO操作，当 IO 操作发生时，触发相应的动作。

#### 基本用法

```go
select {
case <- chan1:
// 如果chan1成功读到数据，则进行该case处理语句
case chan2 <- 1:
// 如果成功向chan2写入数据，则进行该case处理语句
default:
// 如果上面都没有成功，则进入default处理流程
}
```

#### 执行顺序

如果有一个或多个IO操作可以完成，则Go运行时系统会随机的选择一个执行，否则的话，如果有default分支，则执行default分支语句，如果连default都没有，则select语句会一直阻塞，直到至少有一个IO操作可以进行

```go
    start := time.Now()
    c := make(chan interface{})
    ch1 := make(chan int)
    ch2 := make(chan int)

    go func() {
        time.Sleep(4 * time.Second)
        close(c)
    }()

    go func() {
        time.Sleep(3 * time.Second)
        ch1 <- 3
    }()

    go func() {
        time.Sleep(3 * time.Second)
        ch2 <- 5
    }()

    fmt.Println("Blocking on read...")
    select {
    case <-c:
        fmt.Printf("Unblocked %v later.\n", time.Since(start))
    case <-ch1:
        fmt.Printf("ch1 case...")
    case <-ch2:
        fmt.Printf("ch1 case...")
    default:
        fmt.Printf("default go...")
    }

/*
执行结果
Blocking on read...
default go...
Process finished with exit code 0
*/
```

#### 求值顺序

所有channel表达式都会被求值、所有被发送的表达式都会被求值。求值顺序：自上而下、从左到右

```go
var ch1 chan int
var ch2 chan int
var chs = []chan int{ch1, ch2}
var numbers = []int{1, 2, 3, 4, 5}

func main () {
    select {
    case getChan(0) <- getNumber(2):
        fmt.Println("1th case is selected.")
    case getChan(1) <- getNumber(3):
        fmt.Println("2th case is selected.")
    default:
        fmt.Println("default!.")
        }
    }

func getNumber(i int) int {
    fmt.Printf("numbers[%d]\n", i)
    return numbers[i]
}

func getChan(i int) chan int {
    fmt.Printf("chs[%d]\n", i)
    return chs[i]
}
/*
执行结果
chs[0]
numbers[2]
chs[1]
numbers[3]
default!.

Process finished with exit code 0
*/
```

### string slice 值拷贝还是指针拷贝

不修改时是指针拷贝，当有修改时就变成值拷贝了

```go
package main

import "fmt"

func main() {
    var str string = "12345"
    tmpstr := str
    fmt.Printf("%x %x\n", str, tmpstr)
    tmpstr = tmpstr + "x"
    fmt.Printf("%x %x\n", str, tmpstr)

    var a []byte = []byte("12345")
    b := a
    fmt.Printf("%x %x\n", a, b)
    b = append(b, 'a')
    fmt.Printf("%x %x\n", a, b)
}

/* 输出
3132333435 3132333435
3132333435 313233343578
3132333435 3132333435
3132333435 313233343561
*/
```



## 格式转换

### 字符串转int

```go
import "strconv"
request.STimestamp, _ = strconv.ParseInt(req.Form["start"][0], 10, 64)
```
### int 转string

```go
import "strconv"
a := strconv.Itoa(10)
var b int64
b = 16
str := strconv.FormatInt(b, 10)
```

### 时间戳与时间互转

```go
//时间戳转时间
var startTime int64
timeS := time.Unix(startTime, 0)
date := timeS.Format("2006-01-02 15:04:05")
//时间转时间戳
now :=time.Now()
timestamp:= now.Unix()
//字符串转时间
start, err := time.ParseInLocation("20060102", "20200101", time.Local)
```
### float64转int

```go
    var x float64 = 5.7
    var y int = int(x)
```
### float64转string

```go
    strconv.FormatFloat(capacity, 'f', 1, 64)
```
### IP int与string互转

```go
func InetAtoN(ipStr string) (int64, error) {
	ret := big.NewInt(0)
	ip := net.ParseIP(ipStr)
	if ip == nil {
		return -1, fmt.Errorf("invalid ip address")
	}
	ret.SetBytes(ip.To4())
	return ret.Int64(), nil
}

func InetNtoA(ip int64) string {
	return fmt.Sprintf("%d.%d.%d.%d",
		byte(ip>>24), byte(ip>>16), byte(ip>>8), byte(ip))
}
```



## os

### 判断目录或文件是否存在

```go
import os
func PathExist(path string) bool {
    _, err := os.Stat(path)
    if err != nil && os.IsNotExist(err) {
        return false
    }
    return true
}
```
### 创建目录

```go
dir="./haha"
err := os.Mkdir(dir, os.ModePerm)
if err != nil {
    fmt.Printf("mkdir failed![%v]\n", err)
} else {
    fmt.Printf("mkdir success!\n")
}
```
### 删除文件

```go
import os

err := os.Remove(logFile)
if err != nil {
  //删除失败
} else {
  //删除成功
}
```



### 写文件

如果文件不存在则自动创建，如果存在则清空写
```go
func Write1()  {
    fileName := "file/test2"
    strTest := "测试测试"
    var d = []byte(strTest)
    err := ioutil.WriteFile(fileName, d, 0666)
    if err != nil {
        fmt.Println("write fail")
    }
    fmt.Println("write success")
}
```
### 读文件
```go
func Read0()  (string){
    f, err := ioutil.ReadFile("file/test")
    if err != nil {
        fmt.Println("read fail", err)
    }
    return string(f)
}
```
### 获取当前主机名

```go
host, err := os.Hostname()
if err != nil {
    fmt.Printf("%s", err)
} else {
    fmt.Printf("%s", host)
}
```
### 获取当前主机IP

```go
func getLocalIP() (net.IP, error) {
    addrs, err := net.InterfaceAddrs()
    if err != nil {
      	return nil, err
    }
    for _, addr := range addrs {
        if ipnet, ok := addr.(*net.IPNet); ok && ipnet.IP.To4() != nil && !ipnet.IP.IsLoopback() {
          	return ipnet.IP, nil
        }
    }
    return nil, errors.New("no proper ip")
}
```



## bytes.Buffer

### 声明一个Buffer的四种方法：
```go
var b bytes.Buffer       //直接定义一个Buffer变量，不用初始化，可以直接使用
b := new(bytes.Buffer)   //使用New返回Buffer变量
b := bytes.NewBuffer(s []byte)   //从一个[]byte切片，构造一个Buffer
b := bytes.NewBufferString(s string)   //从一个string变量，构造一个Buffer
```
### 往Buffer中写入数据
```go
b.Write(d []byte)        //将切片d写入Buffer尾部
b.WriteString(s string)  //将字符串s写入Buffer尾部
b.WriteByte(c byte)     //将字符c写入Buffer尾部
b.WriteRune(r rune)     //将一个rune类型的数据放到缓冲器的尾部
b.WriteTo(w io.Writer)  //将Buffer中的内容输出到实现了io.Writer接口的可写入对象中
```
注：将文件中的内容写入Buffer,则使用ReadForm(i io.Reader)


### 从Buffer中读取数据到指定容器
```go
c := make([]byte,8)
b.Read(c)      //一次读取8个byte到c容器中，每次读取新的8个byte覆盖c中原来的内容
b.ReadByte()   //读取第一个byte，b的第1个byte被拿掉，赋值给a => a, _ := b.ReadByte()

b.ReadRune()   //读取第一个rune，b的第1个rune被拿掉，赋值给r => r, _ := b.ReadRune()
b.ReadBytes(delimiter byte)   //需要一个byte作为分隔符，读的时候从缓冲器里找第一个出现的分隔符（delim），找到后，把从缓冲器头部开始到分隔符之间的所有byte进行返回，作为byte类型的slice，返回后，缓冲器也会空掉一部分
b.ReadString(delimiter byte)  //需要一个byte作为分隔符，读的时候从缓冲器里找第一个出现的分隔符（delim），找到后，把从缓冲器头部开始到分隔符之间的所有byte进行返回，作为字符串返回，返回后，缓冲器也会空掉一部分
b.ReadForm(i io.Reader)  //从一个实现io.Reader接口的r，把r里的内容读到缓冲器里，n 返回读的数量
    file, _ := os.Open("./text.txt")    
buf := bytes.NewBufferString("Hello world")    
buf.ReadFrom(file)              //将text.txt内容追加到缓冲器的尾部    
fmt.Println(buf.String())
```
### 清空数据
b.Reset()

### 字符串化

b.String()
## runtime
#### SetFinalizer
```golang
runtime.SetFinalizer(obj, func(obj *typeObj))

func NewPostgresDB(config *conf.PostgresConfig) *PostgresDB {
    db := &PostgresDB{
        hostIp:     config.HostIP,
        dbUserName: config.DBUserName,
        dbPassword: config.DBPasswd,
        dbName:     config.DBName,
        tableName:  config.TableName,
        inited:     false,
    }
    db.Connection()
    runtime.SetFinalizer(db, (*PostgresDB).Close)
    return db
}
```
func(obj *typeObj) 需要一个 typeObj 类型的指针参数 obj，特殊操作会在它上面执行。func 也可以是一个匿名函数。

对象在被GC前，调用该函数
## reflect

### 示例

```go
  func CalAttrWeight(capacity interface{}, attrArr []string) {
      var ref reflect.Value
      switch capacity.(type) {
      case *BCCapacityInfo:
          ref = reflect.ValueOf(*capacity.(*BCCapacityInfo))
      case *BSCapacityInfo:
          ref = reflect.ValueOf(*capacity.(*BSCapacityInfo))
      }
      for _, str := range attrArr {
          attrValue := ref.FieldByName(str).Interface()
          switch attrValue.(type) {
          case map[string][]*InstsRealUsedInfo:
              value := attrValue.(map[string][]*InstsRealUsedInfo)
              InstsRealUsedInfoWeightUnit(value)
          }
      }

  }
```
注意：

    reflect.ValueOf()传入的一定要是对象，如果是指针，那么在ref.FieldByName时会报错。 
    原因是指针的ValueOf返回的是指针的Type，它是没有Field的，所以也就不能使用FieldByName

### 根据类名创建对象

```go

type ModuleFactory struct {
        moduleTypeMap map[string]reflect.Type
}

func (factory *ModuleFactory) Init() error {
        factory.moduleTypeMap = make(map[string]reflect.Type)
        factory.moduleTypeMap["BaseModule"] = reflect.TypeOf(BaseModule{})
        return nil
}

func (factory *ModuleFactory) GetModule(moduleName string) (Module, error) {
        if m, exist := factory.moduleTypeMap[moduleName]; exist {
                v := reflect.New(m).Elem().Addr().Interface()
                fmt.Println(reflect.TypeOf(v))
                return v.(Module), nil
        }
        return nil, fmt.Errorf("moduleName[%v] not found", moduleName)
}
```
注意：
>     Value.Addr()是获取这个 value 的指针。用于通过返射获取一个 struct 对象的指针，如果要获取的是 struct 对象，则不需要

### 校验struct是否存在成员

```go
ref := reflect.ValueOf(baidu_bos_seer.BucketResource{})
value := ref.FieldByName(param.Type)
if !value.IsValid() {
  return nil, fmt.Errorf("invalid type type=%v", param.Type)
}
```

## datetime

### 转换
```go
//时间戳转时间格式
time.Unix(timestamp, 0).Format("2006010203")

//时间格式转换时间戳
func TimeToTimestamp(layout,timestr string) (int64, error) {
    loc, err := time.LoadLocation("Local")
    if err != nil {
        return -1, err
    }
    times, err := time.ParseInLocation(layout, timestr, loc)
    if err != nil {
        return -1, err
    }
    trantimestamp := times.Unix()
    return trantimestamp, nil
}

//时间加减
end := time.Now()
duration := time.ParseDuration("-168h") //"ms", "s", "m", "h"
start := end.Add(duration)//7天前

//判断一个时间点是否在一个时间点之后
    stringToTime, _ := time.Parse("2006-01-02 15:04:05", "2017-12-12 12:00:00")
    beforeOrAfter := stringToTime.After(time.Now())
    if beforeOrAfter == true {
        fmt.Println("2017-12-12 12:00:00在tNow之后!")
    } else {
        fmt.Println("2017-12-12 12:00:00在tNow之前!")
    }
    
//判断一个时间相比另外一个时间点过去了多久
    beginTime :=time.Now()
    time.Sleep(time.Second*1)
    durtime:= time.Since(beginTime)
    fmt.Println("离现在过去了：",durtime)
```
### sleep

```go
time.Sleep(time.Duration(m.interval) * time.Millisecond) //sleep一段时间
```
## json

### 基础标记

```go
type Span struct {
	Qid            string  `json:"Q,omitempty"`
	IpPort         string  `json:"I"`
	BeginTimestamp uint64  `json:"B"`
	EndTimestamp   uint64  `json:"-"`
	Children       []*Span `json:"C,omitempty"`
```
其中omitempty 语义为，若该字段为空，则不输出
其中-语义为，该字段不输出

### 序列化与反序列化
```go
package main

import (
	"encoding/json"
	"fmt"
	"os"
)

func main() {
	type ColorGroup struct {
		ID     int
		Name   string
		Colors []string
	}
	group := ColorGroup{
		ID:     1,
		Name:   "Reds",
		Colors: []string{"Crimson", "Red", "Ruby", "Maroon"},
	}
	b, err := json.Marshal(group)
	if err != nil {
		fmt.Println("error:", err)
	}
	os.Stdout.Write(b)
}
```
## 协程间通信

### waitgroup
```go
package main
 
import (
	"fmt"
	"sync"
)
 
var waitgroup sync.WaitGroup
 
func test(shownum int) {
	fmt.Println(shownum)
	waitgroup.Done() //任务完成，将任务队列中的任务数量-1，其实.Done就是.Add(-1)
}
 
func main() {
	for i := 0; i < 10; i++ {
		waitgroup.Add(1) //每创建一个goroutine，就把任务队列中任务的数量+1
		go test(i)
	}
	waitgroup.Wait() //.Wait()这里会发生阻塞，直到队列中所有的任务结束就会解除阻塞
	fmt.Println("done!")
}
```
## 文件读取
### io/ioutil

```go
package main

import (
	"fmt"
	"io/ioutil"
	"log"
)

func main() {
	content, err := ioutil.ReadFile("testdata/hello")
	if err != nil {
		log.Fatal(err)
	}

	fmt.Printf("File contents: %s", content)

}
```
#### 遍历目录下所有文件

```go
func GetFiles(dirPath string) (files []string, err error) {
        dir, err := ioutil.ReadDir(dirPath)
        if err != nil {
                return nil, err
        }
        for _, file := range dir {
                if file.IsDir() {
                        continue
                }
                files = append(files, file.Name())
        }
        return files, err
}
```



## go test

### 测试单个文件
```bash
go test -v  wechat_test.go wechat.go
```
一定要带上原文件

-v 显示详细测试信息

### 测试单个函数

```bash
go test -v -test.run TestRefreshAccessToken
```
## match

### rand

```go
package main
import (
    "fmt"
    "math/rand"
    "time"
)
func init(){
    //以时间作为初始化种子
    rand.Seed(time.Now().UnixNano())
}
func main() {

    for i := 0; i < 10; i++ {
        a := rand.Int()
        fmt.Println(a)
    }
    for i := 0; i < 10; i++ {
        a := rand.Intn(100)
        fmt.Println(a)
    }
    for i := 0; i < 10; i++ {
        a := rand.Float32()
        fmt.Println(a)
    }

}
```

## regex

```go
USERIDREGSTR := "^[A-Fa-f0-9]{32}"
reg := regexp.MustCompile(USERIDREGSTR)
if reg.Match([]byte(key)) {
	return false
}
```



## redis

### conn

```go
client, err := redis.Dial("tcp", r.config.Host,
		redis.DialConnectTimeout(time.Duration(r.config.ConnTimeoutMs)*time.Millisecond),
		redis.DialReadTimeout(time.Duration(r.config.ReadTimeoutMs)*time.Millisecond),
		redis.DialWriteTimeout(time.Duration(r.config.WriteTimeoutMs)*time.Millisecond))
	if err != nil {
		log.Logger.Error("connect to reporter failed host:%v err:%v", r.config.Host, err)
		return err
}
```

### set

```go
	v, err := redis.String(r.client.Do("setex", key, ttl, value))
	if err != nil {
		return nil
	}
	if v != "OK" {
		return fmt.Errorf("set falied")
	}
	return nil
```

### get

```go
	v, err := r.client.Do("get", key)
	if err != nil {
		return nil, err
	}
	result, err := redis.Bytes(v, err)
	if err != nil {
		if err == redis.ErrNil {
			return []byte(""), nil
		}
		return nil, err
	}
	return result, nil
```



### scan

```go
func (r *Redis) scanKeys(keyReg string, logid int64) ([]string, error) {
	var (
		cursor int64
		result []string
	)
	result = make([]string, 0)
	for {
		var keys []string
		values, err := redis.Values(r.client.Do("SCAN", cursor, "MATCH", keyReg, "COUNT", r.config.ScanCount))
		if err != nil {
			log.Logger.Error("[logid:%v] scan keys failed err:%v", logid, err)
			return nil, err
		}
		for len(values) > 0 {
			values, err = redis.Scan(values, &cursor, &keys)
			if err != nil {
				log.Logger.Error("[logid:%v] scan keys failed err:%v", logid, err)
				return nil, err
			}
			result = append(result, keys...)
		}
		if cursor == 0 {
			break
		}
	}
	return result, nil
}
```



## 工具

### go tool vet

命令的作用是检查Go语言源代码并且报告可疑的代码编写问题。比如，在调用`Printf`函数时没有传入格式化字符串，以及某些不标准的方法签名，等等。该命令使用试探性的手法检查错误，因此并不能保证报告的问题确实需要解决。但是，它确实能够找到一些编译器没有捕捉到的错误。

```makefile
  lint:
      for pkg in "controller" "crawler" "data_process_framework"; do  \
          $(GO) tool vet -all -shadow "$(SRCDIR)/$${pkg}";  \
      done
```

## 性能

### regex 与grep

性能测试，对于复杂的正则表达式，regex是grep的9倍多

```go
package main                                                                                                                                                                                              [7/1889]

import (
        "bufio"
        "fmt"
        "os"
        "os/exec"
        "regexp"
        "strings"
        "time"
)

var reg *regexp.Regexp

func getQid(data []byte) string {
        loc := reg.FindSubmatchIndex(data)
        if loc != nil {
                return string(data[loc[2]:loc[3]])
        }
        return ""
}

func main() {
        f, _ := os.Open("./test.txt")
        reg, _ = regexp.Compile("logid=(\\d+)")
        defer f.Close()
        buf := bufio.NewScanner(f)
        qidArray := []string{"121920813", "12225553", "122162764", "122102689", "122182398", "122162541", "122200603", "122235696", "122180750", "122279671", "122213980", "122319640", "122322624", "12238844", "
122369732", "12235983", "122341934", "122442836", "122406810", "122410544", "122513441", "122497713", "122525537", "12250966", "122508542", "122537301", "122441875", "122582624", "122582906", "122624171", "1226
48385", "122665758", "122710168", "122671412", "12270842", "122696935", "122757315", "122820227", "122860895", "122896556", "122906111", "122993381", "122963882", "12313797", "12360658", "12372816", "12351786",
 "1239241", "123136110", "123182267", "123211360", "123282192", "123391826", "123326251", "123439420", "123407540", "123480350", "123453805", "123536215", "123582586", "123595642", "123637925", "123639769", "12
3707779", "123687121", "123714771", "123726376", "123519647", "123656389", "123739183", "123855954", "123811528", "123890768", "123938206", "123890169", "123961869", "123968504", "123993164", "12410252", "12463
5", "123986799", "12448368", "12474331", "124173629", "124191553", "124100217", "124239992", "124301311", "124285388", "124342703", "12432634", "124366891", "124411282", "124444166", "124469773", "124482448", "
124480431", "124560814", "124528953", "124598894"}

        //prepare grep
        CMD_FMT := "nice -n 19 grep -E '%s' %s/%s"

        now := time.Now()
        qidMap := make(map[string]int)
        for _, id := range qidArray {
                qidMap[id] = 1
        }
        for buf.Scan() {
                data := buf.Bytes()
                qid := getQid(data)
                if _, exist := qidMap[qid]; exist {
                }
        }
        fmt.Println("run with regex:", time.Since(now))
        now = time.Now()
        command := fmt.Sprintf(CMD_FMT, strings.Join(qidArray, "|"), "./", "test.txt")
                                     if output, err := cmd.Output(); err != nil {
        fmt.Printf("run cmd:%v failed err:%v output:%v \n", command, err, output)
        }
        fmt.Println("run with grep:", time.Since(now))
}
/*result
run with regex: 31.278593ms
run with grep: 239.16918ms
*/
```

## protobuf

### marshal

```go
info := &baidu_bos_seer.BucketResource{
  Download:         &vv.download,
  Upload:           &vv.upload,
  CrossAZDownload:  &vv.crossAZDownload,
  CrossAZUpload:    &vv.crossAZUpload,
  Mysql:            &vv.mysql,
  MysqlOfDelete:    &vv.mysqlOfDelete,
  Memory:           &vv.memory,
  ExternalDownload: &vv.externalDownload,
  BgwDownload:      &vv.bgwDownload,
  BgwUpload:        &vv.bgwUpload,
  InternalDownload: &vv.internalDownload,
}
data, err := proto.Marshal(info)
```

### unmarshal

```go
resource := &baidu_bos_seer.BucketResource{}
err := proto.Unmarshal(value, resource)
```

## time

### 时间运算

```go
now := time.Now() //获取当前时间
before := time.Now().Add(time.Duration(-100) * time.Second) // 前100秒
```

