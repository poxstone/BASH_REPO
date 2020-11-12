#!/bin/bash

# Declare variables
declare format="png";

if [ $2 ];then
    declare -a sizes=($2);
else
    declare -a sizes=(1024 512 256 200 192 180 152 144 128 120 114 100 96 80 76 72 64 60 58 57 52 50 48 40 36 32 29 24 16);
fi;

# if is file
if [ -f $1 ];then
    dir=".";
    declare -a imgs=$1;
else
    dir=$1;
    # rm $dir/*.$format;
    declare -a imgs=$(ls $dir);
fi;


rm $dir/*.bak;
rm $dir/*.log;

function createImg () {
    for size in ${sizes[@]};do
        local name=${1/.svg/_$size.$format};
        
        test -f $dir/$name && rm $dir/$name;

        echo $name;
        # whith npm: file export is very height
        # local command="svgexport $dir/$1 $dir/$name $size:";

        # wiht imageMagick: problem transparent
        # local command="convert $dir/$1 -resize $size $dir/$name";

        # with inkscape best
        inkscape -f $dir/$1 -w $size -e $dir/$name &&
        # optipng -v -o5 -quiet -preserve "$dir/$name" &&
        optipng -v -o2 -quiet -strip all $dir/$name &&
        echo ">>>>>>>>>>  DONE: $dir/$name  <<<<<<<<<<";
    done;
}


for img in ${imgs[@]};do
    echo $img;
    createImg $img;
done;

#move to folder
prev_dir = $(pwd);
cd $dir;
find . -type f -name "*.png" | awk -F '_' '{dir="if [ ! -e "$1" ];then mkdir "$1";fi;mv "$0" "$1;print dir;system(dir)};';
cd $prev_dir;
