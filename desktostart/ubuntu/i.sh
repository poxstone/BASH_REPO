#!/bin/bash

# update all
sudo apt-get clean -y; # fixer
sudo apt-get autoremove -y; # fixer
sudo apt-get install -f -y; # fixer
sudo dpkg --purge --force-all *; # fixer
sudo apt-get dist-upgrade -y; # fixer

# sudo apt-get purge virtualbox* -y; # fixer
sudo apt-get update;
sudo dpkg --configure -a;
sudo apt-get upgrade -y;

# Libraries
sudo apt-get install build-essential autoconf libtool pkg-config python-opengl python-imaging python-pyrex python-pyside.qtopengl idle-python2.7 qt4-dev-tools qt4-designer libqtgui4 libqtcore4 libqt4-xml libqt4-test libqt4-script libqt4-network libqt4-dbus python-qt4 python-qt4-gl libgle3 python-dev python-setuptools libpcap0.8-dev libnetfilter-queue-dev libssl-dev libjpeg-dev libxml2-dev libxslt1-dev libcapstone3 libcapstone-dev libffi-dev file checkinstall python-pip build-essential libssl-dev -y;

# Editors and basic nedded
sudo apt-get install vim tmux tree whois -y;
# Virtualbox
sudo apt-get install chromium-browser -y;

# node js
if nvm --version;then
  echo "nvm installed";
else
  curl https://raw.githubusercontent.com/creationix/nvm/v0.33.2/install.sh | bash &&
  source ~/.profile;sudo chmod -R 777 ~/.nvm;
  source .bashrc;
fi;

npm i -g stylus nib http-server bower jade svgexport less less-prefixer watch-less;

# Python libs
sudo pip install virtualenvwrapper pyopenssl;
sudo easy_install greenlet;
sudo easy_install gevent;

# mysql
sudo apt-get install libmysqlclient-dev mysql-server mysql-client -y;
# Dev tools
sudo apt-get install htop lynx whois -y;
sudo apt-get install git gitk -y;
apt-get install autoconf g++ python2.7-dev -y;
pip install pycrypto -y;
# Google Drive
sudo add-apt-repository ppa:nilarimogard/webupd8 -y && sudo apt-get update && sudo apt-get install grive -y;
# Design tools
sudo apt-get install inkscape gimp -y;
sudo apt-get install imagemagick libpng12-dev libjpeg62-dev libtiff4-dev tesseract\* -y;
# Java and gradle

if java -version ;then
  echo "java done";
else
  sudo add-apt-repository ppa:webupd8team/java -y;
  sudo add-apt-repository ppa:cwchien/gradle -y;
  sudo apt-get update;
  apt-get install oracle-java8-installer -y;
  sudo apt-get install gradle -y; 
  # disable gradle service
  sudo update-rc.d tomcat8 disable;
fi;

if [[ $(dpkg -s virtualbox 2>&1) == *"Status: install ok installed"* ]];then
  echo "virtualbox installed";
else
  sudo apt-get install virtualbox virtualbox-ext-pack -y;
fi;'

