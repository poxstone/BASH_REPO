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
  sudo dnf update -y;
  sudo dnf upgrade -y;
  sudo dnf clean all;
}

function cleanDnf {
  sudo dnf clean dbcache;
  sudo dnf clean expire-cache;
  sudo dnf clean metadata;
  sudo dnf clean packages;
  sudo dnf clean all;

  # fix dependences
  sudo dnf update --best --allowerasing;
  sudo dnf remove --duplicates;
}

# Install tools
function mainTools {
  sudo dnf check-update -y && sudo dnf upgrade -y; 
  sudo dnf install vim tmux htop iotop lynx nmap tcpdump iotop -y;
  # snap
  sudo dnf install snapd -y;
  sudo ln -s /var/lib/snapd/snap /snap;
}

function removePython {
    for package in $(sudo pip2 freeze); do sudo pip2 uninstall -y $package; done;
    sudo dnf reinstall python2 -y;
    sudo dnf install python python-devel -y;
}

# Dev tools
function devTools {
  sudo dnf install kernel-devel-$(uname -r) kernel-core-$(uname -r) -y; 
  sudo dnf install https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm -y; 
  # Dev tools
  sudo dnf install redhat-rpm-config -y; 
  sudo dnf install @development-tools -y; 
  sudo dnf install -y dh-autoreconf vim-enhanced curl-devel expat-devel gettext-devel openssl-devel apr-devel perl-devel zlib-devel libvirt;
  sudo dnf install -y asciidoc xmlto docbook2X binutils fedora-packager chrpath autoconf automake;
  sudo dnf install -y gcc gcc-c++ qt-devel libffi-devel dnf-plugins-core python python-devel nasm.x86_64 SDL* ant dkms kernel-devel dkms kernel-headers libstdc++.i686 subversion;
  sudo dnf install -y dh-autoreconf vim-enhanced curl-devel expat-devel gettext-devel openssl-devel apr-devel perl-devel zlib-devel libvirt gtkmm30 libgdkmm-3.0.so.1 proj proj;
  sudo dnf install -y wget deluge rpm-build lsb sqlite-devel git-all kdiff3 openssh openssh-server ncurses-devel bzip2-devel;
  sudo dnf install -y dnf-utils device-mapper-persistent-data lvm2 p7zip; #unrar
  sudo dnf install -y libX11-devel freetype-devel libxcb-devel libxslt-devel libgcrypt-devel libxml2-devel gnutls-devel libpng-devel libjpeg-turbo-devel libtiff-devel gstreamer-devel dbus-devel fontconfig-devel libappindicator;
  sudo dnf install samba-winbind-clients -y;
  sudo dnf install -y glibc-devel.{i686,x86_64} libgcc.{i686,x86_64} libX11-devel.{i686,x86_64} freetype-devel.{i686,x86_64} gnutls-devel.{i686,x86_64} libxml2-devel.{i686,x86_64} libjpeg-turbo-devel.{i686,x86_64} libpng-devel.{i686,x86_64} libXrender-devel.{i686,x86_64} alsa-lib-devel.{i686,x86_64};
  sudo dnf install -y libappindicator-gtk3;

  # ssh
  sudo dnf install openssh openssh-server -y; 
  sudo systemctl enable sshd.service;
  sudo systemctl start sshd.service;

  #booting iso
  sudo dnf -y install unetbootin;
}

# Python
function pipTools {
  sudo pip install --upgrade pip; # error on version 10.0.1
  #sudo pip install pip==9.0.3 # use this if abode fails

  sudo pip uninstall jrnl;#jrnl[encrypted]
  sudo pip uninstall awscli;
  sudo pip uninstall graphlab-create;

  sudo pip install jsonschema;
  sudo pip install flask;
  sudo pip install requests;
  sudo pip install ansible;
  sudo pip install cryptography;
  sudo pip install virtualenv;
  sudo pip install selenium;
  sudo dnf install python-pandas -y;
  sudo pip install --upgrade requests-ftp;
  sudo pip install --upgrade wrapt;
  sudo pip install --upgrade setuptools;
  sudo pip install --upgrade ez_setup;
  sudo pip install --upgrade pyOpenSSL;
  sudo pip install --upgrade jinja2;
  sudo pip install --upgrade pyudev;
  sudo pip install --upgrade dnspython;
  sudo pip install --upgrade pyzmq;
  sudo pip install --upgrade pygments;
  sudo pip install --upgrade tornado;
  sudo pip install --upgrade jsonschema;
  sudo pip install --upgrade ipython; 
  sudo pip install --upgrade "ipython[notebook]";
  sudo pip install --upgrade requests;
  sudo pip install --upgrade cryptography;
  sudo pip install --upgrade graphlab-create;
  sudo pip install --upgrade seaborn;
  sudo pip install --upgrade oauth2client;
  sudo pip install --upgrade rsa;
  sudo pip install --upgrade rpm-py-installer;
  sudo pip install --upgrade koji;

  sudo dnf install -y python-devel python-nose python-setuptools gcc gcc-gfortran gcc-c++ blas-devel lapack-devel atlas-devel;
  sudo dnf install -y python-paramiko;

  # browser drivers for sellenium
  if ! geckodriver --version || ! chromedriver --version ;then
      echo "Pendiente instalar los drivers de lo navegadores";
  fi;
  
  # python 3.7 and pip
  sudo dnf install python37 -y;
  wget https://bootstrap.pypa.io/get-pip.py;
  sudo python3.7 get-pip.py;
}

# Databases services
function databases {
  sudo dnf install -y postgresql-server postgresql-contrib postgresql-devel;
  sudo systemctl enable postgresql;
  #init database with empty data required to initializaed
  if sudo ls /var/lib/pgsql/data ;then
    sudo postgresql-setup initdb postgresql;
  fi;
  sudo systemctl start postgresql;
  sudo passwd postgres <<EOF
$DEV_PASS2
$DEV_PASS2
EOF
  # config
  sudo sed -i -e "s/\(\( peer\)\|\( ident\)\)/ md5/g" /var/lib/pgsql/data/pg_hba.conf;
  sudo sed -i -e "s/^#listen_addresses/listen_addresses/g" /var/lib/pgsql/data/postgresql.conf;
  sudo sed -i -e "s/^#port/port/g" /var/lib/pgsql/data/postgresql.conf;
  sudo systemctl restart postgresql.service

  sudo dnf install -y pgadmin3;
}

# Ruby
function rubyTools {
  sudo dnf install -y ruby ruby-devel rubygem-thor rubygem-bundler;
  sudo dnf install -y rubygem-rake rubygem-test-unit;
  sudo gem install rails;
  sudo dnf install rubygem-rails <<EOF
y
EOF
  sudo dnf group install 'Ruby on Rails' -y; 
}

# Install dsn, media apps and tools
function mediaTool {
  sudo rpm --import http://li.nux.ro/download/nux/RPM-GPG-KEY-nux.ro;
  sudo dnf install -y gnome-color-manager;
  sudo dnf install -y gstreamer{1,}-{plugin-crystalhd,ffmpeg,plugins-{good,ugly,bad{,-free,-nonfree,-freeworld,-extras}{,-extras}}} libmpg123 lame-libs --setopt=strict=0; 
  # npapi-vlc
  sudo dnf install -y gimp inkscape krita blender fontforge ImageMagick ImageMagick-devel ImageMagick-perl optipng vlc python-vlc;
  sudo dnf install -y mencoder ffmpeg ffmpeg-devel;
  # snap install inkscape;
}

# Install remte desktop windows
function remote {
  #remmina-plugins-gnome;
  sudo dnf install -y remmina  remmina-plugins-rdp remmina-plugins-vnc --allowerasing;
  sudo dnf install -y vinagre;
  sudo dnf install -y x2goclient;
}

# Remmina-plugins-common
# Apache php
function apachePHP {
  sudo dnf install -y httpd;
  sudo systemctl start httpd;
  sudo dnf install php php-common php-pdo_mysql php-pdo php-gd php-mbstring -y; 
  sudo systemctl restart httpd;
  sudo dnf install perl-Net-SSLeay -y; 
  # problems on installation dependences
  #php libraries (moodle)
  # sudo rpm -Uvh https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm;
  # sudo rpm -Uvh https://mirror.webtatic.com/yum/el7/webtatic-release.rpm;
  # sudo dnf install mod_php71w php71w-common php71w-mbstring php71w-xmlrpc php71w-soap php71w-gd php71w-xml php71w-intl php71w-mysqlnd php71w-cli php71w-mcrypt php71w-ldap -y;
  # sudo dnf install mod_php71w php71w-opcache -y;
  # php 7.1
  # sudo dnf install php71w-fpm php71w-opcache -y;
  #perl-TO-Tty
  sudo systemctl stop httpd;
}


# DOCKER
function dockerTools {
  sudo dnf remove docker docker-common docker-selinux docker-engine-selinux docker-engine -y;
  sudo dnf -y install dnf-plugins-core;
  sudo dnf config-manager --add-repo https://download.docker.com/linux/fedora/docker-ce.repo -y;
  sudo dnf config-manager --set-enabled docker-ce-edge -y;
  sudo dnf config-manager --set-enabled docker-ce-test -y;
  sudo dnf config-manager --set-disabled docker-ce-edge -y;
  sudo dnf check-update -y && sudo dnf update && sudo dnf upgrade -y;
  sudo dnf install docker-ce -y;
  sudo usermod -a -G docker $USER;
  # Docker kompose
  sudo dnf -y install kompose;
  #user to docker group
  sudo groupadd docker;
  sudo gpasswd -a $USER docker;
  # activate docker daemon
  sudo systemctl start docker;
  # docker compose
  sudo pip install docker-compose;
  echo 'modify: /etc/docker/daemon.json with {"graph: "/home/user/bin/docker-images/"}';
}

# Android dev
function javaAndroid {
  #sudo fastboot oem get_unlock_data
  sudo dnf install android-tools -y;
  sudo dnf install zlib.i686 ncurses-libs.i686 bzip2-libs.i686 -y;
  sudo dnf install fastboot -y;
  sudo dnf install usbutils -y;

  #java
  local JAVA_RPMS="jdk-7u80-linux-x64.rpm jdk-8u191-linux-x64.rpm";
  local JAVA_ALTERNATIVES="jdk1.7.0_80 jdk1.8.0_91-amd64";
  sudo dnf install -y java-1.8.0-openjdk;

  #java oracle 8
  function addJavaOracle {
    local java_rpm="${1}";
    sudo rpm -ivh ${HOME_USER}/Downloads/programs/${java_rpm};
  }

  function restore_alternatives_java {
    # Alternatives
    sudo rm -rf /usr/bin/java;
    sudo rm -rf /usr/bin/javaws;
    sudo rm -rf /usr/bin/javac;
    sudo rm -rf /usr/bin/jar;
  }

  function install_alternatives_java {
    local java_version="$1";

    sudo alternatives --install /usr/bin/java   java   /usr/java/${java_version}/jre/bin/java   2000;
    sudo alternatives --install /usr/bin/javaws javaws /usr/java/${java_version}/jre/bin/javaws 2000;
    sudo alternatives --install /usr/bin/javac  javac  /usr/java/${java_version}/bin/javac      2000;
    sudo alternatives --install /usr/bin/jar    jar    /usr/java/${java_version}/bin/jar        2000;
  }

  function select_alternative_java {
    local num="$1";
    sudo alternatives --config <<EOF
$num
EOF
  }

  function remove_alternatives_java {
    local java_version="$1";

    sudo alternatives --remove java   /usr/java/${java_version}/jre/bin/java;
    sudo alternatives --remove javaws /usr/java/${java_version}/jre/bin/javaws;
    sudo alternatives --remove javac  /usr/java/${java_version}/bin/javac;
    sudo alternatives --remove jar    /usr/java/${java_version}/bin/jar;
  }

  # install oracle java
  for java_to_install in ${JAVA_RPMS};do
    addJavaOracle "${java_to_install}";
  done;

  # add alternatives
  for java_to_add in ${JAVA_ALTERNATIVES};do
    #install_alternatives_java "${java_to_add}";
    echo "To java add; $java_to_add";
  done;

  # select alternatives
  #select_alternative_java 3;

  # gradle java
  if java -version && gradle -v;then
      echo "gradle and java alternatives alreadyionstalled";
      sudo dnf install gradle -y;
  else
      echo '--- Pending install JAVA JDK---';
  fi;
}


# vim
function vimConfig {
  if ! file ~/.vim || ! file ~/.vim/bundle/;then
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
      if [[ $(node -v) != *"v8"* ]];then
        sudo dnf remove nodejs -y;
        curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.33.5/install.sh | bash && \
        . ~/.nvm/nvm.sh && . ~/.bashrc; \
        nvm install 8 && nvm use 8 && nvm alias default $(nvm current) && \
        npm i -g stylus nib pug-cli less less-prefixer watch-less http-server bower;
      fi;
  else
      echo '--- Pending install NVM for nodejs---';
  fi;
}


function installMariaDB {

  sudo yum install -y mariadb;
  sudo mysql_secure_installation;
  sudo systemctl start mysql;
  sudo systemctl enable mariadb.service;

}

#install programs dir
function installTouch {
  dir_apps=~/Downloads/programs/;
  [ -e $dir_apps ] &&
  #for app in $(find $dir_apps -name "*.rpm" -maxdepth 1);do sudo dnf install -y ${dir_app}${app};done;
  #gestures
  sudo dnf -y copr enable mhoeher/multitouch;
  sudo dnf -y install libinput-gestures;
  libinput-gestures-setup start; #normal user
  libinput-gestures-setup autostart; #user
};

function installSpotify {
  #spootify
  sudo dnf -y config-manager --add-repo=http://negativo17.org/repos/fedora-spotify.repo;
  sudo dnf -y install spotify;

  cd ~;
  cd $INIT_DIR;
}

function devPrograms {
  # https://code.visualstudio.com/docs/setup/linux
  sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
  sudo sh -c 'echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/yum.repos.d/vscode.repo'
  sudo dnf check-update -y;
  sudo dnf install code -y;
}

function installAll {
  updateSystem;
  updateSystem;
  cleanDnf;
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
  javaAndroid; # error by java
  vimConfig;
  nodeConfig;
  #installMariaDB; #errors
  installTouch;
  installSpotify;
  devPrograms;
  cleanDnf;
}


