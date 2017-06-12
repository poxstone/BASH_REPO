#!/bin/bash
INIT_DIR=$(pwd);
cd ~/Downloads;

sudo dnf check-update -y && sudo dnf upgrade -y;
sudo dnf install kernel-devel-$(uname -r) kernel-core-$(uname -r) -y;
sudo dnf install https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm -y;

# Dev tools
sudo dnf install redhat-rpm-config -y;
sudo dnf install @development-tools -y;
sudo dnf install dh-autoreconf curl-devel expat-devel gettext-devel openssl-devel perl-devel zlib-devel \
                 asciidoc xmlto docbook2X getopt binutils fedora-packager chrpath autoconf automake \
                 gcc libffi-devel epel-release dnf-plugins-core python python-devel -y;
sudo dnf install wget -y;
sudo dnf install deluge -y;
sudo dnf install rpm-build lsb -y;
sudo dnf install zlib-devel sqlite-devel -y; # instlall for ruby;
sudo dnf install git-all -y;
sudo dnf install openssh openssh-server -y;
sudo systemctl enable sshd.service;
sudo systemctl start sshd.service;


# python
sudo pip install --upgrade pip;
sudo pip install jrnl[encrypted];
sudo pip install ansible;
sudo pip install cryptography;


# databases services
sudo dnf install postgresql-server postgresql-contrib postgresql-devel -y;
sudo systemctl enable postgresql;
#init database with empty data required to initializaed
sudo postgresql-setup --initdb --unit postgresql;
sudo systemctl start postgresql;
sudo dnf install pgadmin3 -y;

# ruby
sudo dnf install ruby ruby-devel rubygem-thor rubygem-bundler -y;
sudo dnf install ruby-tcltk rubygem-rake rubygem-test-unit -y;
sudo gem install rails && sudo dnf install rubygem-rails;
sudo dnf group install 'Ruby on Rails' -y;

# Install tools
sudo dnf install vim-enhanced tmux htop lynx nmap -y;

# install dsn, media apps and tools
sudo dnf install gstreamer{1,}-{plugin-crystalhd,ffmpeg,plugins-{good,ugly,bad{,-free,-nonfree,-freeworld,-extras}{,-extras}}} libmpg123 lame-libs --setopt=strict=0 -y;
sudo dnf install gimp inkscape blender ImageMagick ImageMagick-devel ImageMagick-perl optipng vlc python-vlc npapi-vlc -y;

# Apache php
sudo dnf install httpd -y;
sudo systemctl start httpd;
sudo dnf install php php-common php-pdo_mysql php-pdo php-gd php-mbstring -y;
sudo systemctl restart httpd;
sudo dnf install perl-Net-SSLeay perl-TO-Tty -y;
sudo systemctl stop httpd;

# DOCKER
sudo dnf install docker;
# activate docker daemon
sudo systemctl start docker;
# docker compose
sudo pip install docker-compose;

# java with alternatives
if java -version;then
    if gradle -v;then
        echo "gradle and java alternatives alreadyionstalled";
    else
        sudo dnf install gradle -y;
        sudo alternatives --install /usr/bin/java java /usr/java/latest/jre/bin/java 200000;
        sudo alternatives --install /usr/bin/javaws javaws /usr/java/latest/jre/bin/javaws 200000;
        sudo alternatives --install /usr/lib64/mozilla/plugins/libjavaplugin.so libjavaplugin.so.x86_64 /usr/java/latest/jre/lib/amd64/libnpjp2.so 200000;
        sudo alternatives --install /usr/bin/javac javac /usr/java/latest/bin/javac 200000;
        sudo alternatives --install /usr/bin/jar jar /usr/java/latest/bin/jar 200000;
    fi;
else
    echo '--- Pending install JAVA JDK---';
fi;

# nodejs
if node -v;then
    if stylus -V && bower -v && ng -v;then
        echo "npm and modules allready installed";
    else
        npm install -g stylus nib less jade svgexport http-server bower @angular/cli;
    fi;
else
    echo '--- Pending install NVM for nodejs---';
fi;

#manual
echo "
---## MANUAL INSTALATTIONS ###--
    - chrome install chrome (download)
    - virtualbox download), install, and install package extension
    - java download install and run  this (i.sh) again)
        - .bashrc > export JAVA_HOME='/usr/java/jdk1.8.0_131'
    - mysql (donwlad and install):
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
    - tomcat (donwload and run in folder)
    - nvm (download): https://github.com/creationix/nvm
        - curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.33.2/install.sh | bash
        export NVM_DIR='$HOME/.nvm'
        [ -s '$NVM_DIR/nvm.sh' ] && \. '$NVM_DIR/nvm.sh'  # This loads nvm
        [ -s '$NVM_DIR/bash_completion' ] && \. '$NVM_DIR/bash_completion'  # This loads nvm bash_completion
    - postgres (autoinstall and complete configuration):
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

    ";

cd ~;
cd $INIT_DIR;

