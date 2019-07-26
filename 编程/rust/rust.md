# rust

[TOC]

## hello world

### 创建项目

``` bash
cargo new hello_world #创建项目
cargo build #编译
cargo build --release #生成发布版本
```

## 语法

``` rust
use std::io; //引用标准库

fn main() {
    println!("Guess the number!"); //打印

    println!("Please input your guess.");

    let mut guess = String::new();// new 是类 String 的静态函数

    io::stdin().read_line(&mut guess) // &即引用 带 mut 表示可修改，不带 mut 即不可修改
        .expect("Failed to read line"); //异常处理

    println!("You guessed: {}", guess);
}
```

### 创建变量

``` rust
let foo = 5; //常量
let mut bar = 5; //变量
```

