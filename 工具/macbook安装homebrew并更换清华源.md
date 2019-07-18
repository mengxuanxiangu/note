macbook安装homebrew并更换清华源
1、官网brew.sh复制安装脚本。
2、自动安装完成后，更换为清华源来加快速度。网址为：https://mirrors.tuna.tsinghua.edu.cn/help/homebrew
3、更换homebrew
```
cd "$(brew --repo)"
git remote set-url origin https://mirrors.tuna.tsinghua.edu.cn/git/homebrew/brew.git

cd "$(brew --repo)/Library/Taps/homebrew/homebrew-core"
git remote set-url origin https://mirrors.tuna.tsinghua.edu.cn/git/homebrew/homebrew-core.git
brew update
```

更换homebrew-bottles
长期更换
```
echo 'export HOMEBREW_BOTTLE_DOMAIN=https://mirrors.tuna.tsinghua.edu.cn/homebrew-bottles' &gt;&gt; ~/.bash_profile
source ~/.bash_profile
```
临时更换
```
export HOMEBREW_BOTTLE_DOMAIN=https://mirrors.tuna.tsinghua.edu.cn/homebrew-bottles
```
