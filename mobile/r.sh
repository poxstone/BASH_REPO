#!/data/data/com.termux/files/usr/bin/bash
userDir=$HOME;
source $userDir/.bashrc;
#variables
DIR_WORK_1=$HOME/Projects/ANG2-TEMPLATE/;
# kill node procceses
find ~ -name "*.sw[pomn]" -type f -delete;
pkill -9 node;
kill -9 $(ps ax | grep -i dev_appserver.py | awk '{print($1)}');
tmux new-window -n cons "python2 $HOME/bin/google-cloud-sdk/bin/dev_appserver.py $DIR_WORK_1 --host 0.0.0.0";
tmux split-window -p 50 "stylus -u nib -w $DIR_WORK_1/front-app/src/assets/static/css/style.styl";
tmux new-window -n edit "vim -S $HOME/vimsession.vim";
tmux split-window -p 16 "cd $DIR_WORK_1/front-app && ng serve";
tmux selectp -t edit;
