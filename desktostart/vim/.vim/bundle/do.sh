#!/bin/bash
#install:
#    ./do.sh install
#delete repos:
#    ./do.sh clear
#obtain git urls:
#    ./do.sh .

ACTION=$1;
SH_FILE=$0;
declare -a repos=('https://github.com/mattn/emmet-vim'\
    'https://github.com/scrooloose/nerdtree.git'\
    'https://github.com/tomtom/tlib_vim'\
    'https://github.com/leafgarland/typescript-vim'\
    'https://github.com/MarcWeber/vim-addon-mw-utils'\
    'https://github.com/vim-scripts/vim-auto-save'\
    'https://github.com/digitaltoad/vim-pug'\
    'https://github.com/tpope/vim-sensible'\
    'https://github.com/wavded/vim-stylus.git');

function getUrlDir() {
    local dir=$@;
    cd $dir;
    local git_url=`git config --get remote.origin.url`;
    cd ..;
    echo $git_url;
    echo "# $git_url" >> $SH_FILE;
};

function install_git() {
    local repo=$@;
    git clone $repo && echo "$repo --> installed";
};

function clear_repos() {
    for i in `ls`;do test -d $i && rm -rf $i;done;
    echo "folders deleted";
};

if [[ $ACTION == "install" ]];then
    echo "install repos";

    for i in ${repos[@]};do
        install_git $i;
    done;

elif [ ! $ACTION == " " ] && [ -d $ACTION ];then
    echo "extract url $ACTION;"

    for i in `ls`;do
        if [ -d $i ];then
            getUrlDir $i;
        fi;
    done;

elif [[ $ACTION == "clear" ]];then
    clear_repos;
else
    echo "nothing action";
fi;

# To install urls

