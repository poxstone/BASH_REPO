#!/bin/bash
INIT_DIR=$(pwd);
cd cd ~/Downloads/;
#sudo dnf list;
sudo dnf check-update -y && sudo dnf upgrade -y; 
# Install tools
sudo dnf install vim vim-enhanced tmux htop lynx nmap -y; 
# Dev tools
sudo dnf install kernel-devel-$(uname -r) kernel-core-$(uname -r) -y; 
sudo dnf install https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm -y; 
# Dev tools
sudo dnf install redhat-rpm-config -y; 
sudo dnf install @development-tools -y; 
sudo dnf install -y dh-autoreconf curl-devel expat-devel gettext-devel openssl-devel apr-devel perl-devel zlib-devel libvirt;
sudo dnf install -y asciidoc xmlto docbook2X binutils fedora-packager chrpath autoconf automake;
sudo dnf install -y gcc gcc-c++ qt-devel libffi-devel dnf-plugins-core python python-devel nasm.x86_64 SDL* ant;
# epel-release getopt
sudo dnf install wget -y; 
sudo dnf install deluge -y; 
sudo dnf install rpm-build lsb -y; 
sudo dnf install zlib-devel sqlite-devel -y; # instlall for ruby;
sudo dnf install git-all kdiff3 -y; 
sudo dnf install openssh openssh-server -y; 
sudo systemctl enable sshd.service;
sudo systemctl start sshd.service;
# python
sudo pip install --upgrade pip;
sudo pip install jrnl[encrypted];
sudo pip install ansible;
sudo pip install cryptography;
sudo pip install virtualenv;
sudo pip install selenium;
#sudo dnf install python-pandas -y;
# browser drivers for sellenium
if ! geckodriver --version || ! chromedriver --version ;then
    echo "Pendiente instalar los drivers de lo navegadores";
fi;
# databases services
sudo dnf install postgresql-server postgresql-contrib postgresql-devel -y; 
sudo systemctl enable postgresql;
#init database with empty data required to initializaed
if sudo ls /var/lib/pgsql/data ;then
  sudo postgresql-setup --initdb --unit postgresql;
fi;
sudo systemctl start postgresql;
sudo dnf install pgadmin3 -y; 
# ruby
sudo dnf install -y ruby ruby-devel rubygem-thor rubygem-bundler;
sudo dnf install -y ruby-tcltk rubygem-rake rubygem-test-unit;
sudo gem install rails && sudo dnf install rubygem-rails;
sudo dnf group install 'Ruby on Rails' -y; 
# install dsn, media apps and tools
sudo dnf install gnome-color-manager -y; 
sudo dnf install gstreamer{1,}-{plugin-crystalhd,ffmpeg,plugins-{good,ugly,bad{,-free,-nonfree,-freeworld,-extras}{,-extras}}} libmpg123 lame-libs --setopt=strict=0 -y; 
sudo dnf install gimp inkscape krita blender fontforge ImageMagick ImageMagick-devel ImageMagick-perl optipng vlc python-vlc npapi-vlc -y; 
# install remte desktop windows
sudo dnf install remmina remmina-plugins-gnome remmina-plugins-rdp remmina-plugins-vnc --allowerasing -y; 
# remmina-plugins-common
# Apache php
sudo dnf install httpd -y; 
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
# DOCKER
sudo dnf remove docker docker-common docker-selinux docker-engine-selinux docker-engine -y;
sudo dnf -y install dnf-plugins-core;
sudo dnf config-manager --add-repo https://download.docker.com/linux/fedora/docker-ce.repo -y;
sudo dnf config-manager --set-enabled docker-ce-edge -y;
sudo dnf config-manager --set-enabled docker-ce-test -y;
sudo dnf config-manager --set-disabled docker-ce-edge -y;
sudo dnf check-update -y && sudo dnf update && sudo dnf upgrade -y;
sudo dnf install docker-ce -y;
sudo usermod -a -G docker $USER;
#user to docker group
sudo groupadd docker;
sudo gpasswd -a $USER docker;

# activate docker daemon
sudo systemctl start docker;
# docker compose
sudo pip install docker-compose;
# Android dev
# sudo fastboot oem get_unlock_data
sudo dnf install android-tools -y;
sudo dnf install zlib.i686 ncurses-libs.i686 bzip2-libs.i686 -y;
sudo dnf install fastboot -y;
sudo dnf install usbutils -y;
#java oracle
if ! java -version;then
    if [ -e ~/Downloads/programs/jdk-8u151-linux-x64.rpm ];then
        sudo rpm -ivh ~/Downloads/programs/jdk-8u151-linux-x64.rpm;
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
        # java version
        java -version;
    else
        echo "java rpm no est en la carpeta de descargas";
    fi;
fi;
# gradle java
if java -version && gradle -v;then
    echo "gradle and java alternatives alreadyionstalled";
    sudo dnf install gradle -y;
else
    echo '--- Pending install JAVA JDK---';
fi;

#vim
if ! file ~/.vim || ! file ~/.vim/bundle/;then
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

#tools iso to usb
sudo dnf -y install unetbootin;


#mysql https://www.if-not-true-then-false.com/2010/install-mysql-on-fedora-centos-red-hat-rhel/
if ! mysql -v;then
  sudo dnf -y install https://dev.mysql.com/get/mysql57-community-release-fc26-10.noarch.rpm;
  sudo dnf -y --enablerepo=mysql80-community install mysql-community-server;
  sudo systemctl start mysqld.service;
  sudo systemctl enable mysqld.service;
  #password
  sudo rep 'A temporary password is generated for root@localhost' /var/log/mysqld.log |tail -1;
  sudo ./usr/bin/mysql_secure_installation;
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
        - sudo dnf install mysql-community-server
        - sudo systemctl start mysqld.service
        - sudo systemctl enable mysqld.service
          # set password root
          vim /var/log/mysqld.log # and find password
        - sudo /usr/bin/mysql_secure_installation
          OR
          - SHOW VARIABLES LIKE 'validate_password%';
          - SET GLOBAL validate_password_policy=LOW;
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
        - dnf install libCg-3.1.0013-4.fc22.x86_64.rpm
        - dnf install lwks-14.0.0-amd64.rpm
    ";
#gestures
sudo dnf -y copr enable mhoeher/multitouch;
sudo dnf -y install libinput-gestures;
libinput-gestures-setup start; #normal user
#libinput-gestures-setup autostart #user
#spootify
sudo dnf -y config-manager --add-repo=http://negativo17.org/repos/fedora-spotify.repo;
sudo dnf -y install spotify;

cd ~;
cd $INIT_DIR;
#CLEAR packages
sudo dnf clean packages;
sudo dnf clean all;
# fix dependences
sudo dnf update --best --allowerasing;
sudo dnf remove --duplicates;

