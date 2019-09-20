# C++
[TOC]
## 语法

### string

#### string 长度

```c++
string str = "my string";
cout << str.length() << endl;
cout << str.size() << endl;

```



## 类型转换

## pragma once
    与头文件卫士作用相同
## typedef用法
### 1. 四个用途
#### 用途一：
定义一种类型的别名，而不只是简单的宏替换。可以用作同时声明指针型的多个对象。比如：
```C++
char* pa, pb; // 这多数不符合我们的意图，它只声明了一个指向字符变量的指针， 和一个字符变量；
```
以下则可行：
```C++
typedef char* PCHAR; // 一般用大写
PCHAR pa, pb; // 可行，同时声明了两个指向字符变量的指针
```
虽然：
```C++
char *pa, *pb;
```
也可行，但相对来说没有用typedef的形式直观，尤其在需要大量指针的地方，typedef的方式更省事。

 

#### 用途二：
用在旧的C的代码中（具体多旧没有查），帮助struct。以前的代码中，声明struct新对象时，必须要带上struct，即形式为： struct 结构名 对象名，如：
```C++
struct tagPOINT1  
{  
    int x;  
    int y;  
};  
struct tagPOINT1 p1; 
```
而在C++中，则可以直接写：结构名 对象名，即：
```C++
tagPOINT1 p1;
```
估计某人觉得经常多写一个struct太麻烦了，于是就发明了： 
```C++
typedef struct tagPOINT  
{  
    int x;  
    int y;  
}POINT;  
POINT p1; // 这样就比原来的方式少写了一个struct，比较省事，尤其在大量使用的时候 
```
或许，在C++中，typedef的这种用途二不是很大，但是理解了它，对掌握以前的旧代码还是有帮助的，毕竟我们在项目中有可能会遇到较早些年代遗留下来的代码。

#### 用途三：
用typedef来定义与平台无关的类型。
比如定义一个叫 REAL 的浮点类型，在目标平台一上，让它表示最高精度的类型为：
```C++
typedef long double REAL;
```
在不支持 long double 的平台二上，改为：
```C++
typedef double REAL; 
```
在连 double 都不支持的平台三上，改为：
```C++
typedef float REAL;  
```

　　也就是说，当跨平台时，只要改下 typedef 本身就行，不用对其他源码做任何修改。标准库就广泛使用了这个技巧，比如size_t。另外，因为typedef是定义了一种类型的新别名，不是简单的字符串替换，所以它比宏来得稳健（虽然用宏有时也可以完成以上的用途）。

#### 用途四：
为复杂的声明定义一个新的简单的别名。方法是：在原来的声明里逐步用别名替换一部分复杂声明，如此循环，把带变量名的部分留到最后替换，得到的就是原声明的最简化版。举例：

1. 原声明：int *(*a[5])(int, char*);

变量名为a，直接用一个新别名pFun替换a就可以了：
```C++
typedef int *(*pFun)(int, char*);
```
原声明的最简化版：
```C++
pFun a[5];
```
2. 原声明：void (*b[10]) (void (*)());
变量名为b，先替换右边部分括号里的，pFunParam为别名一:

```C++
typedef void (*pFunParam)();
```
再替换左边的变量b，pFunx为别名二：
```C++
typedef void (*pFunx)(pFunParam);
```
原声明的最简化版：
```C++
pFunx b[10];
```
3. 原声明：doube(*)() (*e)[9]; 
变量名为e，先替换左边部分，pFuny为别名一:

```C++
typedef double(*pFuny)();
```
再替换右边的变量e，pFunParamy为别名二
```C++
typedef pFuny (*pFunParamy)[9];
```
原声明的最简化版：
```C++
pFunParamy e;
```
理解复杂声明可用的“右左法则”：

从变量名看起，先往右，再往左，碰到一个圆括号就调转阅读的方向；括号内分析完就跳出括号，还是按先右后左的顺序，如此循环，直到整个声明分析完。举例：
```C++
int (*func)(int *p);
```
首先找到变量名func，外面有一对圆括号，而且左边是一个*号，这说明func是一个指针；然后跳出这个圆括号，先看右边，又遇到圆括号，这说明 (*func)是一个函数，所以func是一个指向这类函数的指针，即函数指针，这类函数具有int*类型的形参，返回值类型是int。
```C++
int (*func[5])(int *);
```
func 右边是一个[]运算符，说明func是具有5个元素的数组；func的左边有一个*，说明func的元素是指针（注意这里的*不是修饰func，而是修饰 func[5]的，原因是[]运算符优先级比*高，func先跟[]结合）。跳出这个括号，看右边，又遇到圆括号，说明func数组的元素是函数类型的指 针，它指向的函数具有int*类型的形参，返回值类型为int。

也可以记住2个模式：
　　type (*)(....)函数指针 
　　type (*)[]数组指针

### 2.两大陷阱
#### 陷阱一：
记住，typedef是定义了一种类型的新别名，不同于宏，它不是简单的字符串替换。比如：
先定义：
```C++
typedef char* PSTR;
```
然后：
```C++
int mystrcmp(const PSTR, const PSTR);
```
const PSTR实际上相当于const char*吗？不是的，它实际上相当于char* const。原因在于const给予了整个指针本身以常量性，也就是形成了常量指针char* const。

简单来说，记住当const和typedef一起出现时，typedef不会是简单的字符串替换就行。

#### 陷阱二：
typedef在语法上是一个存储类的关键字（如auto、extern、mutable、static、register等一样），虽然它并不真正影响对象的存储特性，如：
```C++
typedef static int INT2;
//不可行
```
编译将失败，会提示“指定了一个以上的存储类”。


### 3.typedef 与 #define的区别
（1）#define是预处理指令，在编译预处理时进行简单的替换，不作正确性检查，不关含义是否正确照样带入，只有在编译已被展开的源程序时才会发现可能的错误并报错。
例如：
```C++
#define PI 3.1415926 
```
程序中的：area=PI*r*r 会替换为3.1415926*r*r 
如果你把#define语句中的数字9 写成字母g 预处理也照样带入。 

而typedef是在编译时处理的。它在自己的作用域内给一个已经存在的类型一个别名，

案例一：
通常讲，typedef要比#define要好，特别是在有指针的场合。请看例子：
```C++
typedef char *pStr1;  
#define pStr2 char *;  
pStr1 s1, s2;  
pStr2 s3, s4;
```
在上述的变量定义中，s1、s2、s3都被定义为char *，而s4则定义成了char，不是我们所预期的指针变量，根本原因就在于#define只是简单的字符串替换而typedef则是为一个类型起新名字。

案例二：
下面的代码中编译器会报一个错误，你知道是哪个语句错了吗？

```C++
typedef char * pStr;  
char string[4] = "abc";  
const char *p1 = string;  
const pStr p2 = string;  
p1++;  
p2++;  
```


是p2++出错了。这个问题再一次提醒我们：typedef和#define不同，它不是简单的文本替换。上述代码中const pStr p2并不等于const char * p2。const pStr p2和const long x本质上没有区别，都是对变量进行只读限制，只不过此处变量p2的数据类型是我们自己定义的而不是系统固有类型而已。因此，const pStr p2的含义是：限定数据类型为char *的变量p2为只读，因此p2++错误。

## 4.使用 typedef 抑制劣质代码
typedef 声明，简称 typedef，为现有类型创建一个新的名字。比如人们常常使用 typedef 来编写更美观和可读的代码。所谓美观，意指 typedef 能隐藏笨拙的语法构造以及平台相关的数据类型，从而增强可移植性和以及未来的可维护性。本文下面将竭尽全力来揭示 typedef 强大功能以及如何避免一些常见的陷阱。

定义易于记忆的类型名 A： 使用 typedefs 为现有类型创建同义字。
Q：如何创建平台无关的数据类型，隐藏笨拙且难以理解的语法?

typedef 使用最多的地方是创建易于记忆的类型名，用它来归档程序员的意图。类型出现在所声明的变量名字中，位于 ''typedef'' 关键字右边。例如：
```C++
typedef int size;
```
此声明定义了一个 int 的同义字，名字为 size。注意 typedef 并不创建新的类型。它仅仅为现有类型添加一个同义字。你可以在任何需要 int 的上下文中使用 size：
```C++
void measure(size * psz); size array[4];size len = file.getlength();std::vector <size> vs; 
```
typedef 还可以掩饰符合类型，如指针和数组。例如，你不用象下面这样重复定义有 81 个字符元素的数组：
char line[81];char text[81];
定义一个 typedef，每当要用到相同类型和大小的数组时，可以这样：
```C++
typedef char Line[81]; Line text, secondline;getline(text);
```
同样，可以象下面这样隐藏指针语法：
```C++
typedef char * pstr;int mystrcmp(pstr, pstr);
```
这里将带我们到达第一个 typedef 陷阱。标准函数 strcmp()有两个‘const char *’类型的参数。因此，它可能会误导人们象下面这样声明 mystrcmp()：
```C++
int mystrcmp(const pstr, const pstr); 
```
这是错误的，按照顺序，‘const pstr’被解释为‘char * const’（一个指向 char 的常量指针），而不是‘const char *’（指向常量 char 的指针）。这个问题很容易解决：
```C++
typedef char * pstr;int mystrcmp(pstr, pstr);
```
记住： 不管什么时候，只要为指针声明 typedef，那么都要在最终的 typedef 名称中加一个 const，以使得该指针本身是常量，而不是对象。
代码简化 　　
上面讨论的 typedef 行为有点像 #define 宏，用其实际类型替代同义字。不同点是 typedef 在编译时被解释，因此让编译器来应付超越预处理器能力的文本替换。例如：
```C++
typedef int (*PF) (const char *, const char *);
```
这个声明引入了 PF 类型作为函数指针的同义字，该函数有两个 const char * 类型的参数以及一个 int 类型的返回值。如果要使用下列形式的函数声明，那么上述这个 typedef 是不可或缺的：
PF Register(PF pf);
Register() 的参数是一个 PF 类型的回调函数，返回某个函数的地址，其署名与先前注册的名字相同。做一次深呼吸。下面我展示一下如果不用 typedef，我们是如何实现这个声明的：
```C++
int (*Register (int (*pf)(const char *, const char *))) (const char *, const char *); 
```

很少有程序员理解它是什么意思，更不用说这种费解的代码所带来的出错风险了。显然，这里使用 typedef 不是一种特权，而是一种必需。持怀疑态度的人可能会问：“OK，有人还会写这样的代码吗？”，快速浏览一下揭示 signal()函数的头文件 <csinal>，一个有同样接口的函数。
typedef 和存储类关键字（storage class specifier） 　
　这种说法是不 是有点令人惊讶，typedef 就像 auto，extern，mutable，static，和 register 一样，是一个存储类关键字。这并是说 typedef 会真正影响对象的存储特性；它只是说在语句构成上，typedef 声明看起来象 static，extern 等类型的变量声明。下面将带到第二个陷阱：

typedef register int FAST_COUNTER; // 错误
编译通不过。问题出在你不能在声明中有多个存储类关键字。因为符号 typedef 已经占据了存储类关键字的位置，在 typedef 声明中不能用 register（或任何其它存储类关键字）

## rand

### srand()为非线程安全函数
```c++
#include <iostream>
int main(int argc, char* argv){
    std::cout << "hello world" << std::endl;
}
```

## 计算md5

```c++
#include <openssl/md5.h>

void cal_md5(char* query) {
    const int MD5_LEN = 16;
    const int BUF_LEN = 1024;
    unsigned char md[MD5_LEN] = {'\0'};
    char md5_buffer[BUF_LEN] = {'\0'};
    MD5_CTX ctx;
    MD5_Init(&ctx);
    MD5_Update(&ctx, query, strlen(query));
    MD5_Final(md, &ctx);
}
```

