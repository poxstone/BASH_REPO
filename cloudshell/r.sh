#!/bin/bash
userDir=$HOME;
localDir="/usr/local";
. $localDir/nvm/nvm.sh; . $userDir/.profile;

# switch node version
if [ $1 ];then nvm use $1; fi;
node -v;

# kill node procceses
pkill -9 node;

cd ~/Projects/ANG2-TEMPLATE/front;
stylus -u nib -w static/css/style.styl &
npm start & # tmux split-window -c "$HOME/Projects/ANG2-TEMPLATE/front/" -t 0 'htop'
find . -name "*.sw[po]" -type f -delete &&
    tmux new-window -c "$HOME/Projects/ANG2-TEMPLATE" -n edit 'vim -S .session.vim';
# open reference
# find ~/Projects/PRB-NG2/app_pz -name "*.sw[po]" -type f -delete &&
    # tmux new-window -c "$HOME/Projects/PRB-NG2/app_pz" -n edit 'vim -S .session.vim';
find ~/Projects/efor-components -name "*.sw[po]" -type f -delete &&
    tmux new-window -c "$HOME/Projects/efor-components" -n edit 'vim -S .session.vim';

