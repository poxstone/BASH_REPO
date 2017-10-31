#!/data/data/com.termux/files/usr/bin/bash
userDir=$HOME;
source $userDir/.bashrc;
#variables
DIR_WORK_1=$HOME/Projects/ANG2-TEMPLATE/;
# kill node procceses
find ~ -name "*.sw[pomn]" -type f -delete;
pkill -9 node;
kill -9 $(ps ax | grep -i dev_appserver.py | awk '{print($1)}');
#open windows, este orden es para dividir las mismas ventanas

python2 $HOME/bin/google-cloud-sdk/bin/dev_appserver.py $DIR_WORK_1 --host 0.0.0.0 & sleep 3 &&
tmux split-window -p 66 "stylus -u nib -w $DIR_WORK_1/front-app/src/assets/static/css/style.styl";
tmux split-window -p 50 "cd $DIR_WORK_1/front-app && ng serve" &
tmux new-window "cd $DIR_WORK_1;vim -S $HOME/vimsession.vim";
