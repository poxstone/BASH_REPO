sudo su#!/bin/bash 
userDir=$HOME;
localDir="/usr/local/nvm";
#localDir="$HOME/.nvm";
# define version node
if [ $1 ];then nodeV=$1; else nodeV="8"; fi;
# load profile and eviroment vars profile for use in this bash
. $localDir/nvm.sh; . $userDir/.profile;
# Change node version
nvm use $nodeV >> /dev/null; #does not print in screen

# Install node
if [[ $(node -v 2>&1) != *"v$nodeV"* ]];then 
    echo "----------install node $nodeV------------";
    sudo su <<EOF
        whoami
        . $localDir/nvm.sh; . $userDir/.profile;
        nvm install $nodeV;
        nvm use $nodeV >> /dev/null;
EOF
fi;

# Install tools
if [[ $(stylus --version 2>&1) == *"command not found"* ]];then
    echo "----------install node tools for $nodeV------------";
    sudo su <<EOF
        whoami;
        . $localDir/nvm.sh; . $userDir/.profile;
        # use v node as normal user cation
        nvm use $nodeV >> /dev/null;
        npm install -g stylus nib bower;
EOF
fi;

# Install tools
if [[ ! $(whereis nmap) ]];then
    echo "----------install nmap------------";
    sudo su <<EOF
        whoami;
        apt-get install nmap -y;
        echo "tools installed";
EOF
fi;

