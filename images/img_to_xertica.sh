#!/bin/bash
START=$(date +%s);
SUFIX_EXTENSION=" (xertica).jpg";

function do_photo() {
    local phot=$@;
    # local pic="$phot xertica.jpg";
    local pic=`echo $phot | awk -v EXTENSION="$SUFIX_EXTENSION" '{IGNORECASE = 1;sub(/\.jpe?g$/,EXTENSION,$0); print}'`;
    
    convert "$phot" -colorspace Gray "$pic";
    convert "$pic" -resize 350x350 "$pic";
    convert "$pic" -crop 246x350+0+0 "$pic";
    convert -brightness-contrast 5x0 "$pic" "$pic";
    convert "$pic" -fill "#009bde95" -draw "rectangle 0,0 55,303" "$pic";
    echo "$pic --> done";
}

if [ -f "$1" ];then
    do_photo $1;
elif [ -d "$1" ];then

# CHANGE splice characters
SAVEIFS=$IFS;
photos=`find $1 -iname "*.jpg"`;
IFS=$(echo -en "\n\b");
    for photo in $photos;do
        if [[ ! $photos == *"$SUFIX_EXTENSION"* ]];then
            do_photo "$photo";

        fi;
    done;
# RESTORE splice characters
IFS=$SAVEIFS;

else
    echo "no photos";
fi;

END=$(date +%s);
DIFF=$(( $END - $START ));
echo "It took $DIFF seconds";
