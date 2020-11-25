#!/bin/bash
INIT_DIR=$(pwd);
#cd ~/Downloads/;



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
  sudo apt update -y && sudo apt full-upgrade && sudo apt install -f && sudo dpkg --configure -a && sudo apt-get -y autoremove && sudo apt -y --fix-broken install;
}

# Install tools
function mainTools {
  sudo apt-get -y install vim tmux htop iotop lynx nmap tcpdump iotop  apt-transport-https ca-certificates curl gnupg-agent software-properties-common wireless-tools dnsutils putty-tools tree;
  # snap
  sudo apt-get install snapd -y;
}

# Dev tools
function devTools {
  # Dev tools
  sudo apt install -y wget gnupg software-properties-common;

  sudo apt-get install -y libappindicator3-1 xbase-clients libxxf86vm1;
  sudo apt install -y build-essential manpages-dev net-tools;
  sudo apt-get install liberation-fonts -y;
  sudo apt-get install -y libpangox-1.0-0 libgtkglext1;
  sudo apt-get install -y dh-autoreconf;
  sudo apt-get install -y asciidoc xmlto binutils chrpath autoconf automake;
  sudo apt-get install -y gcc python python-dev python-pip python3-pip subversion;
  sudo apt install -y python3-evdev python-evdev python-pip python3-pip;
  sudo apt-get install -y python-nose python-setuptools gcc;
  sudo apt-get install -y python-paramiko;
  sudo apt-get install -y libmysqlclient-dev

  # mysql depends
  sudo apt install -y libctemplate3 libmysqlcppconn7v5 libpcrecpp0v5 libvsqlitepp3v5 python-pexpect python-pyodbc python-pysqlite2 libgdal20 libmariadb3;

  # someones interface graphocal requires
  sudo pip install setuptools --upgrade;
  sudo apt install -y glib-networking gsettings-desktop-schemas dconf-gsettings-backend libgtk-3-0 libgtk-3-common libgtk-3-bin; # gsettings-backend;
  sudo apt-get install -y wget git openssh-server; # git-all not work in gcp until has graphic interface
  sudo apt install -y kdiff3;
  # SDL* ant dkms dkms device-mapper-persistent-data
  sudo apt-get install -y  p7zip; #unrar
  
  # ssh
  sudo service ssh enable;
  sudo service ssh start;
}

# Python
function pipTools {
  local pip_v="pip${1}";
  sudo ${pip_v} install --upgrade pip; # error on version 10.0.1
  #sudo pip install pip==9.0.3 # use this if abode fails

  sudo ${pip_v} uninstall jrnl;#jrnl[encrypted]
  sudo ${pip_v} uninstall awscli;
  sudo ${pip_v} uninstall graphlab-create;

  sudo ${pip_v} install jsonschema;
  sudo ${pip_v} install flask;
  sudo ${pip_v} install pylint;
  sudo ${pip_v} install requests;
  sudo ${pip_v} install ansible;
  sudo ${pip_v} install cryptography;
  sudo ${pip_v} install virtualenv;
  sudo ${pip_v} install selenium;
  sudo ${pip_v} install --upgrade requests-ftp;
  sudo ${pip_v} install --upgrade wrapt;
  sudo ${pip_v} install --upgrade setuptools;
  sudo ${pip_v} install --upgrade ez_setup;
  sudo ${pip_v} install --upgrade pyOpenSSL;
  sudo ${pip_v} install --upgrade pyudev;
  sudo ${pip_v} install --upgrade dnspython;
  sudo ${pip_v} install --upgrade pyzmq;
  sudo ${pip_v} install --upgrade pygments;
  sudo ${pip_v} install --upgrade requests;
  sudo ${pip_v} install --upgrade oauth2client;
  sudo ${pip_v} install --upgrade rsa;
}

function graphicInterface {
  sudo apt install -y tasksel;
  sudo tasksel install xfce-desktop --new-install;
  apt install -y lightdm gtk3-engines-xfce xfce4-goodies xfce4-appmenu-plugin xfce4-eyes-plugin xfce4-indicator-plugin xfce4-mpc-plugin xfce4-sntray-plugin xfce4-statusnotifier-plugin;
  # vnc https://www.digitalocean.com/community/tutorials/how-to-install-and-configure-vnc-on-debian-10
  sudo apt install -y tightvncserver;# vnc4server

}

# Install dsn, media apps and tools
function mediaTool {
  sudo apt install -y libavcodec-extra libdvdread4 libdvdcss2; # problems gcp
  sudo dpkg-reconfigure libdvd-pkg; # problems gcp
  sudo apt install -y w64codecs;
  # npapi-vlc
  sudo apt-get install -y mencoder ffmpeg;
  # snap install inkscape;
}

function nvidiaCuda {
  # download and install https://www.nvidia.com/Download/driverResults.aspx/157462/es-ES "NVIDIA-Linux-x86_64-440.64.run"
  sudo apt install -y nvidia-driver;
  
  # nvidia
  distribution=$(. /etc/os-release;echo $ID$VERSION_ID);
  curl -s -L https://nvidia.github.io/nvidia-docker/gpgkey | sudo apt-key add -;
  curl -s -L https://nvidia.github.io/nvidia-docker/$distribution/nvidia-docker.list | sudo tee /etc/apt/sources.list.d/nvidia-docker.list;

  sudo apt-get update && sudo apt-get install -y nvidia-container-toolkit;
  sudo systemctl restart docker;
}

# Android dev
function javaDev {
  #java
  sudo apt-get install -y default-jdk;
  sudo apt-get install -y openjdk-8-jdk;
  echo "use java alternatives:";
  echo "update-java-alternatives --list;";
  echo "sudo update-java-alternatives --set /path/to/java/version;";
}

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

function dbTools {
  sudo apt install -y mysql-client;
  sudo apt install -y mysql-workbench;
} 

# nodejs
function nodeConfig {
  # nodejs
  if node -v;then
      if [[ $(node -v) != *"v12"* ]];then
        sudo apt-get remove nodejs -y;
        curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.36.0/install.sh | bash && \
        . ~/.nvm/nvm.sh && . ~/.bashrc; \
        nvm install 12 && nvm use 12 && nvm alias default $(nvm current) && \
        npm i -g stylus nib pug-cli less less-prefixer watch-less http-server bower;
      fi;
  else
      echo '--- Pending install NVM for nodejs---';
  fi;
}

#browsers
function browsers {
  sudo apt install -y firefox;
  # chrome
  sudo echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" | sudo tee /etc/apt/sources.list.d/google-chrome.list;
  wget https://dl.google.com/linux/linux_signing_key.pub;
  sudo apt-key add linux_signing_key.pub;
  rm -f linux_signing_key.pub;
  sudo apt update -y;
  sudo apt install -y google-chrome-stable;
}

function installAll {
  updateSystem;
  cleanApt;
  mainTools;
  devTools;
  pipTools 2;
  pipTools 3;
  dbTools;
  mediaTool;
  javaDev;
  vimConfig;
  nodeConfig;
  browsers;
  cleanApt;
}


