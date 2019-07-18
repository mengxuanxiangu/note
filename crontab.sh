#!/bin/zsh
WORK_PATH="$(cd $(dirname "$0"); pwd)"
cd $WORK_PATH
function commit() {
    git pull
    cm=`date +%Y%m%d`
    git commit -m "$cm"
    git push -u origin master
}
change=0
change=`git status -s|wc -l|sed 's/ //g'`
if [ $change -gt 0 ]; then
    git add ./
    commit
fi
