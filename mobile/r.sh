#!/data/data/com.termux/files/usr/bin/bash
userDir=$HOME;
source $userDir/.bashrc;
#variables
DIR_WORK_1=~/Projects/ANG2-TEMPLATE/;
# kill node procceses
find ~ -name "*.sw[pomn]" -type f -delete;
sudo pkill -9 node;
kill -9 $(ps ax | grep -i dev_appserver.py | awk '{print($1)}');
#open windows, este orden es para dividir las mismas ventanas
dev_appserver.py $DIR_WORK_1 --host 0.0.0.0 &
tmux split-window -p 20 "stylus -u nib -w $DIR_WORK_1/front-app/src/assets/static/css/style.styl";
tmux split-window -p 20 "cd $DIR_WORK_1/front-app && ng serve" &
tmux new-window "cd $DIR_WORK_1;vim -S $HOME/vimsession.vim";
