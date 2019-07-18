在实际编译代码的过程中，我们经常会遇到"undefined reference to"的问题，简单的可以轻易地解决，但有些却隐藏得很深，需要花费大量的时间去排查。工作中遇到了各色各样类似的问题，按照以下几种可能出现的状况去排查，可有利于理清头绪，从而迅速解决问题。

链接时缺失了相关目标文件

首先编写如下的测试代码：

// test.h#ifndef __TEST_H__#define __TEST_H__voidtest();#endif// test.c#include#includevoidtest(){    printf("just test it\n");}// main.c#include"test.h"intmain(int argc, char **argv){    test();    return0;}

通过以下的命令，我们将会得到两个.o文件。

$ gcc -c test.c  $ gcc –c main.c

随后，我们将main.o这个文件，编译成可执行文件。

$ gcc -o main main.oUndefined symbols for architecture x86_64:"_test", referenced from:      _main in main.old: symbol(s) not found for architecture x86_64clang:error: linker command failed with exit code 1 (use -v to see invocation)

编译时报错了，这是最典型的undefined reference错误，因为在链接时发现找不到某个函数的实现文件。如果按下面这种方式链接就正确了。

$ gcc -o main main.o test.o 

当然，也可以按照如下的命令编译，这样就可以一步到位。

$ gcc -o main main.c test.c

链接时缺少相关的库文件

我们把第一个示例中的test.c编译成静态库。

$ gcc -c test.c  $ ar -rc test.a test.o 

接着编译可执行文件，使用如下命令：

$ gcc -o main main.c Undefined symbols for architecture x86_64:"_test", referenced from:      _main in main-6ac26d.old: symbol(s) not found for architecture x86_64clang:error: linker command failed with exit code 1 (use -v to see invocation)

其根本原因也是找不到test()函数的实现文件，由于test()函数的实现在test.a这个静态库中，故在链接的时候需要在其后加入test.a这个库，链接命令修改为如下形式即可。

$ gcc -o main main.c test.a

链接的库文件中又使用了另一个库文件

先更改一下第一个示例中使用到的代码，在test()中调用其它的函数，更改的代码如下所示。

// func.h#ifndef __FUNC_H__#define __FUNC_H__voidfunc();#endif// func.c#includevoidfunc(){    printf("call it\n");}// test.h#ifndef __TEST_H__#define __TEST_H__voidtest();#endif// test.c#include#include#include"func.h"voidtest(){    printf("just test it\n");    func();}// main.c#include"test.h"intmain(int argc, char **argv){    test();    return0;}

我们先对fun.c和test.c进行编译，生成.o文件。

$ gcc -c func.c  $ gcc -c test.c

然后，将test.c和func.c各自打包成为静态库文件。

$ ar –rc func.a func.o  $ ar –rc test.a test.o 

这时将main.c编译为可执行程序，由于main.c中包含了对test()的调用，因此，应该在链接时将test.a作为我们的库文件，链接命令如下。

$ gcc -o main main.c test.aUndefined symbols for architecture x86_64:"_func", referenced from:      _test in test.a(test.o)ld: symbol(s) not found for architecture x86_64clang:error: linker command failed with exit code 1 (use -v to see invocation)

就是说，链接的时候发现test.a调用了func()函数，找不到对应的实现，我们还需要将test.a所引用到的库文件也加进来才能成功链接，因此命令如下。

$ gcc -o main main.c test.a func.a

同样，如果我们的库或者程序中引用了第三方库（如pthread.a）则在链接的时候需要给出第三方库的路径和库文件，否则就会得到undefined reference的错误。

多个库文件链接顺序问题

这种问题非常隐蔽，不仔细研究，可能会感到非常地莫名其妙。以第三个示例为测试代码，把链接库的顺序换一下，如下所示：

$ gcc -o main main.cfunc.atest.atest.a(test.o): In function `test':  test.c:(.text+0x13): undefined reference to `func'  collect2: ldreturned 1 exitstatus

因此，在链接命令中给出所依赖的库时，需要注意库之间的依赖顺序，依赖其他库的库一定要放到被依赖库的前面，这样才能真正避免undefined reference的错误，完成编译链接。

备注：在MAC上可以正常编译通过。

定义与实现不一致

编写测试代码如下：

// test.h#ifndef __TEST_H__#define __TEST_H__voidtest(unsignedint c);#endif// test.c#include#includevoidtest(int c){    printf("just test it\n");}// main.c#include"test.h"intmain(int argc, char **argv){    test(5);    return0;}

先将test.c编译成库文件。

$ gcc -c test.c $ ar -rc test.a test.o

将main.c编译成可执行文件。

$ gcc -o main main.c test.ald:warning: ignoring file test.a, file was built for archive which is not the architecture being linked (x86_64): test.aUndefined symbols for architecture x86_64:"_test", referenced from:      _main in main-f27cf1.old: symbol(s) not found for architecture x86_64clang:error: linker command failed with exit code 1 (use -v to see invocation)

链接出错了，原因很简单，test()这个函数的声明和定义不一致导致，将两者更改成一样即可通过编译。

在c++代码中链接c语言的库

代码同示例一的代码一样，只是把main.c更改成了main.cpp。编译test.c，并打包为静态库。

$ gcc -c test.c  $ ar -rc test.a test.o

编译可执行文件，用如下命令：

$ g++ -o main main.cpp test.a Undefined symbols for architecture x86_64:"test()", referenced from:      _main in main-7d7fde.old: symbol(s) not found for architecture x86_64clang:error: linker command failed with exit code 1 (use -v to see invocation)

原因就是main.cpp为c++代码，调用了c语言库的函数，因此链接的时候找不到，解决方法是在相关文件添加一个extern "C"的声明即可，例如修改test.h文件。

// test.h#ifndef __TEST_H__#define __TEST_H__#ifdef __cplusplusextern"C" {#endifvoidtest();#ifdef __cplusplus}#endif#endif