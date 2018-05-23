#!/bin/bash

INIT_DIR=$(pwd);
HOME="$HOME";
cd ~/Downloads/;
DEV_USER="developer";
DEV_PASS="Evo76AUS";

function updateSystem {
  sudo yum update -y;
  sudo yum upgrade -y;
  sudo yum install epel-release -y;
  sudo yum clean all;
  wget https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm;
  yum install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm;

}

function createUser {
  sudo useradd $DEV_USER;
  sudo passwd $DEV_USER <<EOF
$DEV_PASS
$DEV_PASS
EOF
  sudo usermod -aG wheel $DEV_USER;
sudo su $DEV_USER <<EOF
  mkdir -p ~/Downloads/ ~/bin/;
  touch .bash_profile;
  # require password
  echo "Type password \"$DEV_PASS\"";
  sudo ls;
EOF
}


function mountDisk {
  sudo mount /dev/sdb /home/;
  local STRING_CONFIG="UUID=$(sudo blkid -s UUID -o value /dev/sdb)  /home/ ext4 discard,defaults,nofail 0 2";
  if [[ ! $(sudo cat /etc/fstab) == *"$STRING_CONFIG"* ]];then
      sudo echo "${STRING_CONFIG}" | sudo tee -a /etc/fstab;
      echo "INFO: automount fstab disk configured!";
    else
      echo "INFO: automount fstab is not required";
    fi;
}


# Install tools
function toolsOS {
  sudo yum install vim tmux htop lynx nmap -y; 
}

# Dev tools
function devTools {
  # Dev tools
  sudo yum install -y redhat-rpm-config;
  sudo yum groupinstall -y --disablerepo=\* --enablerepo=base,updates,cr "Development Tools";
  sudo yum install -y dh-autoreconf vim-enhanced curl-devel expat-devel gettext-devel openssl-devel apr-devel perl-devel zlib-devel libvirt;
  sudo yum install -y asciidoc xmlto docbook2X binutils fedora-packager chrpath autoconf automake;
  sudo yum install -y gcc gcc-c++ qt-devel libffi-devel dnf-plugins-core python python-devel nasm.x86_64 SDL* ant dkms kernel-devel dkms kernel-headers libstdc++.i686 subversion;
  sudo yum install -y wget deluge rpm-build lsb zlib-devel sqlite-devel git-all kdiff3 openssh openssh-server ncurses-devel bzip2-devel;
  sudo yum install -y yum-utils device-mapper-persistent-data lvm2;

  # python update (https://gist.github.com/guy4261/0e9f4081f1c6b078b436)
  # python update (https://tecadmin.net/install-python-2-7-on-centos-rhel/)
  cd /opt/;
  sudo wget --no-check-certificate https://www.python.org/ftp/python/2.7.15/Python-2.7.15.tar.xz;
  sudo tar xf Python-2.7.15.tar.xz;
  sudo chmod -R 755 Python*;
  cd Python-2.7.15;
  sudo ./configure --prefix=/usr/local --enable-shared --enable-unicode=ucs4;
  sudo ./configure --enable-optimizations;
  sudo make && sudo make altinstall;
  sudo make altinstall;
  local STRING_PYTHON_LIB="export LD_LIBRARY_PATH=/usr/local/lib:/usr/local/bin/python2.7:$LD_LIBRARY_PATH";
  local STRING_PY_ALIAS="alias python=/usr/local/bin/python2.7";
  sudo echo "$STRING_PYTHON_LIB" >> ~/.bash_profile;
  sudo echo "$STRING_PY_ALIAS" >> ~/.bash_profile;
  sudo su $DEV_USER <<EOF
  echo "$STRING_PYTHON_LIB" >> ~/.bash_profile;
  echo "$STRING_PY_ALIAS" >> ~/.bash_profile;
EOF
  bash ~/.bash_profile && sudo bash ~/.bash_profile;

  #sudo wget https://bitbucket.org/pypa/setuptools/raw/bootstrap/ez_setup.py;
  sudo wget https://bootstrap.pypa.io/ez_setup.py;
  sudo /usr/local/bin/python2.7 ez_setup.py;
  /usr/local/bin/easy_install-2.7 pip;

  sudo yum-config-manager --add-repo http://download.opensuse.org/repositories/home:/fengshuo:/zeromq/CentOS_CentOS-6/home:fengshuo:zeromq.repo;
  sudo yum install -y python-devel zeromq zeromq-devel;
  cd;

  sudo systemctl enable sshd.service;
  sudo systemctl start sshd.service;
}

# Python
function pipTools {
  # ojo determinar cualde los siguientes generan error
  sudo yum install -y python-pip;
  sudo pip install --upgrade pip;
  sudo pip install --upgrade koji;
  sudo pip install --upgrade pyzmq;
  sudo pip install --upgrade jinja2;
  sudo pip install --upgrade pygments;
  sudo pip install --upgrade tornado;
  sudo pip install --upgrade jsonschema;
  sudo pip install --upgrade ipython;
  sudo pip install --upgrade "ipython[notebook]";
  sudo pip install --upgrade requests;
  sudo pip install --upgrade jrnl[encrypted];
  sudo pip install --upgrade jrnl; ## pendiente
  sudo pip install --upgrade ansible;
  sudo pip install --upgrade cryptography;
  sudo pip install --upgrade virtualenv;
  sudo pip install --upgrade selenium;
  sudo yum install python-pandas -y;

  sudo yum install -y libpng-devel freetype freetype-devel;
  sudo pip install --upgrade matplotlib;
  sudo pip install --upgrade graphlab-create;

  sudo yum -y install python-devel python-nose python-setuptools gcc gcc-gfortran gcc-c++ blas-devel lapack-devel atlas-devel;
  sudo pip install --upgrade seaborn;
  # browser drivers for sellenium
  if ! geckodriver --version || ! chromedriver --version ;then
      echo "Pendiente instalar los drivers de lo navegadores";
  fi;
}

# Databases services
function databases {
  sudo yum install postgresql-server postgresql-contrib postgresql-devel -y; 
  sudo systemctl enable postgresql;
  #init database with empty data required to initializaed
  if sudo ls /var/lib/pgsql/data ;then
    sudo postgresql-setup initdb postgresql;
  fi;
  sudo systemctl start postgresql;
  sudo yum install pgadmin3 -y; 
}

# Ruby
function rubyTools {
  sudo yum install -y ruby ruby-devel rubygem-thor rubygem-bundler;
  sudo yum install -y rubygem-rake rubygem-test-unit;
  sudo gem install rails;
}

# Install dsn, media apps and tools
function mediaTool {
  sudo rpm --import http://li.nux.ro/download/nux/RPM-GPG-KEY-nux.ro;
  sudo rpm -Uvh http://li.nux.ro/download/nux/dextop/el7/x86_64/nux-dextop-release-0-5.el7.nux.noarch.rpm;

  sudo yum install gnome-color-manager -y; 
  # To fix
  sudo yum install gstreamer{1,}-{plugin-crystalhd,ffmpeg,plugins-{good,ugly,bad{,-free,-nonfree,-freeworld,-extras}{,-extras}}} libmpg123 lame-libs --setopt=strict=0 -y; 
  # npapi-vlc
  sudo yum install gimp inkscape blender fontforge ImageMagick ImageMagick-devel ImageMagick-perl optipng -y; 
  sudo yum install ffmpeg ffmpeg-devel -y;
  # snap install inkscape;
}

# Install remte desktop windows
function remote {
  #remmina-plugins-gnome;
  sudo yum install remmina  remmina-plugins-rdp remmina-plugins-vnc -y; 
}

# Remmina-plugins-common
# Apache php
function apachePHP {
  sudo yum install httpd -y; 
  sudo systemctl start httpd;
  sudo yum install php php-common php-pdo_mysql php-pdo php-gd php-mbstring -y; 
  sudo systemctl restart httpd;
  sudo yum install perl-Net-SSLeay -y; 
  # problems on installation dependences
  # sudo yum install php71w-fpm php71w-opcache -y;
  #perl-TO-Tty
  sudo systemctl stop httpd;
}


# DOCKER
function dockerTools {
  sudo yum remove docker docker-client docker-client-latest docker-common docker-latest docker-latest-logrotate docker-logrotate docker-selinux docker-engine-selinux docker-engine;
  sudo yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo;
  sudo yum-config-manager --enable docker-ce-edge;
  sudo yum-config-manager --enable docker-ce-test;
  sudo yum-config-manager --disable docker-ce-edge;
  sudo yum install -y docker-ce;
  sudo systemctl start docker;
  sudo systemctl enable docker

  sudo usermod -a -G docker $USER;
  sudo usermod -a -G docker $DEV_USER;

  # Docker kompose
  sudo yum -y install kompose;
  #user to docker group
  sudo gpasswd -a $USER docker;
  sudo gpasswd -a $DEV_USER docker;
  # activate docker daemon
  sudo systemctl start docker;
  # docker compose
  sudo pip install docker-compose;
}

# Android dev
function javaAndroid {
  #sudo fastboot oem get_unlock_data
  sudo yum install android-tools -y;
  sudo yum install zlib.i686 ncurses-libs.i686 bzip2-libs.i686 -y;
  sudo yum install fastboot -y;
  sudo yum install usbutils -y;
  #java oracle
  if ! java -version;then
      if [ -e ~/Downloads/programs/jdk-8u171-linux-x64.rpm ];then
          sudo rpm -ivh ~/Downloads/programs/jdk-8u171-linux-x64.rpm;
          sudo rpm -ivh ~/Downloads/programs/jdk-7u80-linux-x64.rpm;
          # java with alternatives
          sudo alternatives --install /usr/bin/java java /usr/java/latest/jre/bin/java 200000;
          sudo alternatives --install /usr/bin/javaws javaws /usr/java/latest/jre/bin/javaws 200000;
          sudo alternatives --install /usr/lib64/mozilla/plugins/libjavaplugin.so libjavaplugin.so.x86_64 /usr/java/latest/jre/lib/amd64/libnpjp2.so 200000;
          sudo alternatives --install /usr/bin/javac javac /usr/java/latest/bin/javac 200000;
          sudo alternatives --install /usr/bin/jar jar /usr/java/latest/bin/jar 200000;
          # config alternatives
          sudo alternatives --config java;
          sudo alternatives --config javac;
          sudo alternatives --config javaws;
          # alternatives
          sudo alternatives --install /usr/bin/java java /usr/java/jdk1.7.0_80/jre/bin/java 200000;
          sudo alternatives --install /usr/bin/javac javac /usr/java/jdk1.7.0_80/bin/javac 200000;
          sudo alternatives --install /usr/bin/jar jar /usr/java/jdk1.7.0_80/bin/jar 200000;
          sudo alternatives --install /usr/bin/javaws javaws /usr/java/jdk1.7.0_80/jre/bin/javaws 200000;
          # java version
          java -version;
      else
          echo "java rpm no est en la carpeta de descargas";
      fi;
  fi;
  # gradle java
  if java -version && gradle -v;then
      echo "gradle and java alternatives alreadyionstalled";
      sudo yum install gradle -y;
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
        sudo yum remove nodejs -y;
        curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.33.5/install.sh | bash && \
        . ~/.nvm/nvm.sh && . ~/.bashrc; \
        nvm install 8 && nvm use 8 && nvm alias default $(nvm current) && \
        npm i -g stylus nib pug-cli less less-prefixer watch-less http-server bower;
      fi;
  else
      echo '--- Pending install NVM for nodejs---';
  fi;
}


function mysqlServ {
  #mysql https://www.if-not-true-then-false.com/2010/install-mysql-on-fedora-centos-red-hat-rhel/
  if ! mysql -v;then
    sudo yum -y install https://dev.mysql.com/get/mysql57-community-release-fc26-10.noarch.rpm;
    sudo yum -y --enablerepo=mysql80-community install mysql-community-server;
    sudo systemctl start mysqld.service;
    sudo systemctl enable mysqld.service;
    #password
    sudo rep 'A temporary password is generated for root@localhost' /var/log/mysqld.log |tail -1;
    sudo /usr/bin/mysql_secure_installation;
  fi;

  #manual
  echo "
  ---## MANUAL INSTALATTIONS ###--
    - change language in "sudo vim /etc/locale.conf"
      LANG="en_US.UTF-8"
      LC_CTYPE="en_US.UTF-8"
    - chrome: install chrome (download)
    - virtualbox: download), install, and install package extension
    - java: download install and run  this (i.sh) again)
        - .bashrc > export JAVA_HOME='/usr/java/jdk1.8.0_131'
    - mysql: (donwlad and install):
        - sudo yum install mysql-community-server
        - sudo systemctl start mysqld.service
        - sudo systemctl enable mysqld.service
          # set password root
          vim /var/log/mysqld.log # and find password
        - sudo /usr/bin/mysql_secure_installation
          AND
          - SHOW VARIABLES LIKE 'validate_password%';
          - SET GLOBAL validate_password_policy=LOW;
          - SET GLOBAL validate_password.policy=LOW;
          - ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password AS '123456';
    - workbench: download and install rpm mysql-workbench-community-6.3.9-1.fc26.x86_64.rpm
    - tomcat: (donwload and run in folder)
    - nvm: (download): https://github.com/creationix/nvm
        - curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.33.2/install.sh | bash
        export NVM_DIR='$HOME/.nvm'
        [ -s '$NVM_DIR/nvm.sh' ] && \. '$NVM_DIR/nvm.sh'  # This loads nvm
        [ -s '$NVM_DIR/bash_completion' ] && \. '$NVM_DIR/bash_completion'  # This loads nvm bash_completion
    - etcher: from zio for install usb live
    - postgres: (autoinstall and complete configuration):
        - sudo su - postgres
        - \password postgres
            admin
        - config files to md5:
            - sudo vim /var/lib/pgsql/data/pg_hba.conf # change all to md5
                local   all             all                                     md5
                host    all             all             127.0.0.1/32            md5
                host    all             all             ::1/128                 md5
            - sudo vim /var/lib/pgsql/data/postgresql.conf # uncomment
                listen_addresses = '*'
                port = 5432 
            - sudo systemctl restart postgresql.service
    - Lightworks video editor download ftp://195.220.108.108/linux/rpmfusion/nonfree/fedora/releases/23/Everything/x86_64/os/Packages/l/libCg-3.1.0013-4.fc22.x86_64.rpm
      later download https://www.lwks.com/videotutorials
        - yum install libCg-3.1.0013-4.fc22.x86_64.rpm
        - yum install lwks-14.0.0-amd64.rpm
    - install apps progrms folder
        dir_apps=~/Downloads/programs/;for app in $(find $dir_apps -name "*.rpm");do sudo yum install -y ${dir_app}${app};done;
  ";
}

#install programs dir
function installTouch {
  dir_apps=~/Downloads/programs/;
  [ -e $dir_apps ] &&
  #for app in $(find $dir_apps -name "*.rpm" -maxdepth 1);do sudo yum install -y ${dir_app}${app};done;
  #gestures
  sudo yum -y copr enable mhoeher/multitouch;
  sudo yum -y install libinput-gestures;
  libinput-gestures-setup start; #normal user
  libinput-gestures-setup autostart; #user
};

function installSpotify{
  #spootify
  sudo yum -y config-manager --add-repo=http://negativo17.org/repos/fedora-spotify.repo;
  sudo yum -y install spotify;

  cd ~;
  cd $INIT_DIR;
}

function devPrograms {
  # https://code.visualstudio.com/docs/setup/linux
  sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
  sudo sh -c 'echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/yum.repos.d/vscode.repo'
  sudo yum check-update -y;
  sudo yum install code -y;
}

function cleanDnf {
  sudo yum clean dbcache;
  sudo yum clean expire-cache;
  sudo yum clean metadata;
  sudo yum clean packages;
  #sudo yum clean plugins;
  sudo yum clean all;

  # fix dependences
  sudo yum update --best --allowerasing;
  sudo yum remove --duplicates;
}

function installAll {
  updateSystem;
  cleanDnf;
  tools;
  removePython;
  devTools;
  osTools;
  pipTools; # error
  databases;
  rubyTools;
  mediaTool;
  remote; ## error
  apachePHP;
  dockerTools; #docker compose pip
  javaAndroid; # error by java
  vimConfig;
  nodeConfig;
  mysqlServ;
  installTouch;
  installSpotify;
  devPrograms;
  #cleanDnf;
}


