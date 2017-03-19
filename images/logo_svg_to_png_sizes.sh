dir=$1
rm $dir/*.png;
rm $dir/*.bak;
rm $dir/*.log;
declare -a imgs=$(ls $dir);
declare -a sizes=(512 256 200 128 96 64 48 32 16);

function createImg () {
    for size in ${sizes[@]};do
        local name=${1/.svg/_$size.png};
        local command="svgexport $dir/$1 $dir/$name $size:";
        # echo $name;
        if [[ $name == *"isotipo"* ]] && [[ $name != *"baseColor"* ]] && [[ $size == "16" ]];then
            local name=${1/isotipo.svg/favicon.png};
            local command="svgexport $dir/$1 $dir/$name $size:";
            $($command);
        elif [[ $size == "512" ]];then
            $($command);
        elif [[ $name == *"square"* ]];then
            $($command);
        fi;
    done;
}

for img in ${imgs[@]};do
    createImg $img;
done;

echo ---------------- OPTIMIZE IMAGES --------------
cd $dir
for i in *.png; do optipng -v -o5 -quiet -clobber -preserve -log optipng.log "$i"; done;


