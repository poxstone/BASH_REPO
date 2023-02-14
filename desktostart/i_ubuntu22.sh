#!/bin/bash
INIT_DIR=$(pwd);
#cd ~/Downloads/;

function initInfo {
  while [[ $DEV_USER == "" ]];do 
    echo "Please write the name for user:";
    read DEV_USER;
  done;

  while [[ $DEV_PASS == "" ]];do 
    echo "Please type the password for user:";
    read DEV_PASS;
  done;

  while [[ $DEV_PASS2 == "" ]];do
    echo "Please type the password for root mysql DB:";
    read DEV_PASS2;
  done;

  HOME_USER="/home/$DEV_USER/";
}

function updateSystem {
  sudo apt-get update -y;
  sudo apt-get upgrade -y;
  sudo apt-get clean all;
}

function cleanApt {
  sudo apt-get clean dbcache;
  sudo apt-get clean expire-cache;
  sudo apt-get clean metadata;
  sudo apt-get clean packages;
  sudo apt-get clean all;
  sudo apt -y autoremove;
  sudo apt --fix-broken -y install;
  sudo apt update -y && apt full-upgrade && apt install -f && dpkg --configure -a && apt-get -y autoremove && apt --fix-broken install;
  update-grub && update-grub2 && apt-get autoremove && apt -y autoremove && apt purge && apt remove && apt --fix-broken install;
}

# Install tools
function mainTools {
  sudo apt-get -y install vim tmux htop iotop lynx nmap tcpdump iotop  apt-transport-https ca-certificates curl gnupg-agent software-properties-common wireless-tools dnsutils;
  # snap
  sudo apt-get install snapd fuse libfuse2 -y;
}

# Dev tools
function devTools {
  # Dev tools
  sudo apt install -y wget gnupg software-properties-common;

  sudo apt list --upgradable;
  sudo apt -y update;

  # wifi intel
  #sudo apt-get install -y firmware-iwlwifi;

  # vulkan
  sudo apt install -y libvulkan1 mesa-vulkan-drivers;

  sudo apt-get install -y libappindicator3-1 xbase-clients libxxf86vm1;
  sudo apt install -y build-essential manpages-dev net-tools;
  #sudo apt-get install -y  libgtkglext1;
  sudo apt-get install -y dh-autoreconf;
  sudo apt-get install -y asciidoc xmlto binutils chrpath autoconf automake;
  sudo apt-get install -y gcc python-pip subversion;
  sudo apt install -y python3-evdev python3-pip;

  # mysql depends
  apt-get install -y default-mysql-client;

  # someones interface graphocal requires
  sudo pip install setuptools --upgrade;
  #sudo apt install -y glib-networking gsettings-desktop-schemas dconf-gsettings-backend libgtk-3-0 libgtk-3-common libgtk-3-bin; # gsettings-backend;
  sudo apt-get install -y wget deluge git openssh-server; # git-all not work in gcp until has graphic interface
  sudo apt install -y kdiff3;
  # SDL* ant dkms dkms device-mapper-persistent-data
  sudo apt-get install -y  p7zip; #unrar
  
  # ds4
  #sudo git clone https://github.com/chrippa/ds4drv.git /tmp/ds4drv;
  #cd /tmp/ds4drv;
  #sudo python setup.py install;

  # ssh
  sudo systemctl enable ssh;
  sudo systemctl start ssh;
}

# Python
function pipTools {
  sudo pip install --upgrade pip; # error on version 10.0.1
  #sudo pip install pip==9.0.3 # use this if abode fails

  #sudo pip uninstall jrnl;#jrnl[encrypted]
  #sudo pip uninstall awscli;
  #sudo pip uninstall graphlab-create;

  #sudo pip install jsonschema;
  sudo pip install flask;
  #sudo pip install pylint;
  sudo pip install requests;
  #sudo pip install ansible;
  sudo pip install cryptography;
  sudo pip install virtualenv;
  #sudo pip install selenium;
  #sudo pip install --upgrade requests-ftp;
  #sudo pip install --upgrade wrapt;
  sudo pip install --upgrade setuptools;
  #sudo pip install --upgrade ez_setup;
  #sudo pip install --upgrade pyOpenSSL;
  #sudo pip install --upgrade jinja2;
  sudo pip install --upgrade pyudev;
  #sudo pip install --upgrade dnspython;
  #sudo pip install --upgrade pyzmq;
  #sudo pip install --upgrade pygments;
  #sudo pip install --upgrade tornado;
  #sudo pip install --upgrade jsonschema;
  #sudo pip install --upgrade ipython; 
  #sudo pip install --upgrade "ipython[notebook]";
  #sudo pip install --upgrade requests;
  sudo pip install --upgrade cryptography;
  #sudo pip install --upgrade graphlab-create;
  #sudo pip install --upgrade seaborn;
  #sudo pip install --upgrade oauth2client;
  #sudo pip install --upgrade rsa;
  #sudo pip install --upgrade rpm-py-installer;
  #sudo pip install --upgrade koji;

  sudo apt-get install -y python-setuptools gcc;

  # browser drivers for sellenium
  if ! geckodriver --version || ! chromedriver --version ;then
      echo "Pendiente instalar los drivers de lo navegadores";
  fi;
  
  # python 3.7 and pip
  #sudo apt-get install python37 -y;
  #wget https://bootstrap.pypa.io/get-pip.py;
  #sudo python3.7 get-pip.py;
}

# Install dsn, 
apps and tools
function mediaTool {
  sudo apt install -y libavcodec-extra libdvdcss2 libdvdcss-dev; # problems gcp
  sudo dpkg-reconfigure libdvd-pkg; # problems gcp
  # npapi-vlc
  sudo apt-get install -y inkscape krita blender fontforge imagemagick optipng vlc;
  sudo apt-get install -y mencoder ffmpeg;
}

# Install remte desktop windows
function remote {
  #remmina-plugins-gnome;
  sudo apt-get install -y remmina;
  sudo apt-get install -y vinagre;
  sudo apt-get install -y x2goclient;
  sudo apt-get install -y wireguard;
}

# DOCKER
function dockerTools {
  sudo apt-get -y remove docker docker.io containerd runc;
  sudo mkdir -p /etc/apt/keyrings;
  curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg;
  echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null;
  sudo apt-get -y update;
  sudo apt-get -y install docker-ce docker-ce-cli containerd.io docker-compose-plugin docker-compose;

  sudo usermod -a -G docker $USER;
  #user to docker group
  sudo groupadd docker;
  sudo gpasswd -a $USER docker;
  # activate docker daemon
  sudo systemctl start docker;
  # docker compose TODO: set version
  # Docker kompose
  #sudo apt-get -y install docker-compose;
  
  # enable docker
  sudo systemctl enable docker;
  sudo systemctl restart docker;
  
  echo "{\"graph\": \"/home/${USER}/bin/docker-images/\"}" > "/etc/docker/daemon.json";
}

# Android dev
#function javaAndroid {
#  #sudo fastboot oem get_unlock_data
#  sudo apt install -y android-tools-adb android-tools-fastboot;
#
#  #java
#  sudo apt-get install -y default-jdk;
#  cd /tmp/;
#  wget -qO - https://adoptopenjdk.jfrog.io/adoptopenjdk/api/gpg/key/public | sudo apt-key add -;
#  sudo add-apt-repository --yes https://adoptopenjdk.jfrog.io/adoptopenjdk/deb/;
#  apt update -y;
#  apt install adoptopenjdk-8-hotspot -y;
#}


# vim
function vimConfig {
  if ! [[ -d ~/.vim ]] || ! [[ -d ~/.vim/bundle/ ]];then
    mkdir -p ~/.vim/autoload;
    mkdir -p ~/.vim/bundle;
    curl -LSso ~/.vim/autoload/pathogen.vim https://tpo.pe/pathogen.vim; \
    cd ~/.vim/bundle/; \
    for i in https://github.com/mattn/emmet-vim \
      https://github.com/scrooloose/nerdtree.git \
      https://github.com/tomtom/tlib_vim \
      https://github.com/leafgarland/typescript-vim \
      https://github.com/MarcWeber/vim-addon-mw-utils \
      https://github.com/vim-scripts/vim-auto-save \
      https://github.com/digitaltoad/vim-pug \
      https://github.com/tpope/vim-sensible \
      https://github.com/wavded/vim-stylus.git; \
    do git clone $i;done; \
    cd ~; \
    if [ ! -e ~/.vimrc ];then \
      touch ~/.vimrc; \
      chmod 775 ~/.vimrc; \
    fi; \
    if ! grep ~/.vimrc -e "execute pathogen#infect()";then \
      printf "set enc=utf-8\nset fileencoding=utf-8set hls\nset number\nset relativenumber\nset tabstop=2\nset shiftwidth=2\nset expandtab\nset cindent\nset wrap! \n" >> ~/.vimrc; \
      printf "xnoremap p pgvy\nnnoremap <C-H> :Hexmode<CR>\ninoremap <C-H> <Esc>:Hexmode<CR>\nvnoremap <C-H> :<C-U>Hexmet rela  de<CR> \n" >> ~/.vimrc; \
      printf "let mapleader = \",\"\nnmap <leader>ne :NERDTreeToggle<cr> \n" >> ~/.vimrc; \
      printf "execute pathogen#infect() \ncall pathogen#helptags() \nsyntax on \nfiletype plugin indent on \n" >> ~/.vimrc; \
    fi;
  fi;
}

# nodejs
function nodeConfig {
  # nodejs
  if node -v;then
      if [[ $(node -v) != *"v16"* ]];then
        sudo apt-get remove nodejs -y;
        curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.39.2/install.sh | bash && \
        . ~/.nvm/nvm.sh && . ~/.bashrc; \
        nvm install 16 && nvm use 16 && nvm alias default $(nvm current) && \
        npm i -g stylus nib pug-cli less less-prefixer watch-less http-server bower;
      fi;
  else
      echo '--- Pending install NVM for nodejs---';
  fi;
}


#install programs dir
#function installTouch {
#  dir_apps=~/Downloads/programs/;
#  [ -e $dir_apps ] &&
  #for app in $(find $dir_apps -name "*.rpm" -maxdepth 1);do sudo apt-get install -y ${dir_app}${app};done;
  #gestures
#  sudo apt-get -y copr enable mhoeher/multitouch;
#  sudo apt-get -y install libinput-gestures;
#  libinput-gestures-setup start; #normal user
#  libinput-gestures-setup autostart; #user
#}

#function installSpotify {
  #spootify
#  sudo snap install spotify
#}

function devPrograms {
  # https://code.visualstudio.com/docs/setup/linux
   
  wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg;
  sudo install -D -o root -g root -m 644 packages.microsoft.gpg /etc/apt/keyrings/packages.microsoft.gpg;
  sudo sh -c 'echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" > /etc/apt/sources.list.d/vscode.list';
  rm -f packages.microsoft.gpg;

  sudo apt-get -y update;
  sudo apt-get install code -y;

  #database
  #sudo snap install dbeaver-ce;

}

function netTools {
  sudo apt install -y wireshark;
  sudo usermod -aG wireshark $(whoami);
  sudo apt-get install -y aircrack-ng;
  sudo apt-get install -y netdiscover;
  sudo apt-get install -y sslscan ssldump sslsplitx sslh;
  sudo pip install --upgrade sslyze;
  # spyderfoot
  wget https://raw.githubusercontent.com/smicallef/spiderfoot/master/requirements.txt; sudo pip install -r requirements.txt;
}

function kali {
  sudo apt-get update -y && sudo apt-get full-upgrade -y && sudo apt-get dist-upgrade -y && sudo apt autoremove -y && sudo apt autoclean;
  sudo apt-get install -y wget gnupg dirmngr;
  wget -q -O - https://archive.kali.org/archive-key.asc | sudo gpg --import;
  sudo echo "deb http://http.kali.org/kali kali-rolling main non-free contrib" >> /etc/apt/sources.list;
  sudo gpg -a --export ED444FF07D8D0BF6 | sudo apt-key add -;
  sudo apt-get update -y && sudo apt-get full-upgrade -y && sudo apt-get dist-upgrade -y && sudo apt autoremove -y && sudo apt autoclean;
  sudo apt --fix-broken install;
  # solve someones problems
  sudo apt-get install -y kali-linux-default;
  touch kali_update.sh;
  echo "apt-get update -y && apt-get full-upgrade -y && apt-get dist-upgrade -y && apt autoremove -y && apt autoclean" > kali_update.sh;
  chmod +x kali_update.sh;
  
}

function installAll {
  updateSystem;
  updateSystem;
  cleanApt;
  mainTools;
  #removePython;#noknow
  devTools;
  pipTools; # errors
  #databases;
  #rubyTools;
  mediaTool;
  remote; ## error
  #apachePHP;
  dockerTools; #docker compose pip
  #javaAndroid; # error by java
  vimConfig;
  nodeConfig;
  #installMariaDB; #errors
  #installTouch;
  #installSpotify;
  devPrograms;
  cleanApt;
}
