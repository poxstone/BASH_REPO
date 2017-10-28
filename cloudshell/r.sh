#!/bin/bash
userDir=$HOME;
localDir="/usr/local";
source $localDir/nvm/nvm.sh;source $userDir/.profile;
#variables
DIR_WORK_1=~/Projects/GAE-TEMPLATE;
# kill node procceses
find ~ -name "*.sw[pomn]" -type f -delete;
sudo pkill -9 node;
kill -9 $(ps ax | grep -i dev_appserver.py | awk '{print($1)}');
#open windows, este orden es para dividir las mismas ventanas
tmux new-window "cd $DIR_WORK_1;vim -S ~/vimsession.vim" &
dev_appserver.py $DIR_WORK_1 --host 0.0.0.0 &
tmux split-window -p 50 stylus -u nib -w $DIR_WORK_1/static/css/style.styl;
