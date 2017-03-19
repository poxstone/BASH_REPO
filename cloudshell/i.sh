#!/bin/bash 
function runn () { 
    userDir=$HOME;
    localDir="/usr/local";
    # define version node
if [ $1 ];then nodeV=$1; else nodeV="6"; fi;
    # load profile and eviroment vars profile for use in this bash
    . $localDir/nvm/nvm.sh; . $userDir/.profile;
    # Change node version
    nvm use $nodeV;
    node -v;
    # Install node
    if [[ $(node -v 2>&1) != *"v$nodeV"* ]];then 
        echo "----------install node $nodeV------------";
        sudo su <<EOF
        whoami
        . $localDir/nvm/nvm.sh; . $userDir/.profile;
        nvm install $nodeV;
        nvm use $nodeV;
        node -v;
EOF
    fi;
    # Install tools
    if [[ $(stylus --version 2>&1) == *"command not found"* ]];then
        echo "----------install node tools for $nodeV------------";
        sudo su <<EOF
            whoami;
            . $localDir/nvm/nvm.sh; . $userDir/.profile;
            nvm use $nodeV;
            node -v;
            npm install -g stylus nib bower;
EOF
    fi;
    # Install tools
    if [[ $(nmap -v) ]];then
        echo '';
    else
        echo "----------install nmap------------";
        sudo su <<EOF
            whoami;
            apt-get install nmap -y;
EOF
    fi;
    echo "tools installed";
};

runn & echo "running...";

