#!/bin/bash
userDir=$HOME;
localDir="/usr/local";
source $localDir/nvm/nvm.sh;source $userDir/.profile;
#variables
DIR_WORK_1=$HOME/Projects/ANG2-TEMPLATE/front-app;
# kill node procceses
find ~ -name "*.sw[pomn]" -type f -delete;
sudo pkill -9 node;
kill -9 $(ps ax | grep -i dev_appserver.py | awk '{print($1)}');
#open windows, este orden es para dividir las mismas ventanas
tmux new-window -n edit "vim -S $HOME/vimsession.vim";
tmux split-window -p 16 "cd $DIR_WORK_1 && ng serve --port 8081";
tmux new-window -n cons "dev_appserver.py $DIR_WORK_1/../ --host 0.0.0.0";
tmux split-window -p 50 "stylus -u nib -w $DIR_WORK_1/src/assets/static/css/style.styl";
tmux selectp -t edit;
