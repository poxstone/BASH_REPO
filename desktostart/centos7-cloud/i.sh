#!/bin/bash
INIT_DIR=$(pwd);
HOME="$HOME";
PROJECT=`curl "http://metadata.google.internal/computeMetadata/v1/project/project-id" -H "Metadata-Flavor: Google"`;
BUCKET_GET="${PROJECT}.appspot.com";
JAVA_RPMS="jdk-8u171-linux-x64.rpm jdk-7u80-linux-x64.rpm";
JAVA_INSTALL="latest jdk1.7.0_80 jdk1.8.0_171-amd64";
GRAPH_INTERFACE=2;

function initInfo {
  while [[ $DEV_USER == "" ]];do 
    echo "Please write the name for user:";
    read DEV_USER;
  done;

  while [[ $DEV_PASS == "" ]];do 
    echo "Please type the password for user:";
    read DEV_PASS;
  done;

  echo "Interface to install:";
  echo "1 = KDE Plasma Workspaces";
  echo "2 = xfce";
  echo "3 = GNOME Desktop";
  read GRAPH_INTERFACE;

  HOME_USER="/home/$DEV_USER/";
}

function updateSystem {
  sudo yum update -y;
  sudo yum upgrade -y;
  sudo yum clean all;
  wget https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm;
  yum install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm;
  sudo yum install epel-release -y;
  # remove default sdk
  sudo yum remove -y google-cloud-sdk;
}

function cleanDnf {
  sudo yum clean all;
  sudo rpm --rebuilddb;
  sudo yum update -y;
}

function restoreHomePermissions {
  if [[ "$1" ]];then local DEV_USER="$1";else local DEV_USER="$DEV_USER";fi;
  local HOME_USER="/home/$DEV_USER/";
  sudo chown -R $DEV_USER:$DEV_USER $HOME_USER;
}

function setPython {
  local version = 2;
  if [[ $1 == "old" ]];then
    version=1;
  else
    version=2;
  fi;
  
  sudo alternatives --config python <<EOF
$version
EOF
}

# createUser user pass
function createUser {
  if [[ "$1" ]];then local NEW_USER="$1";else local NEW_USER="$DEV_USER";fi;
  if [[ "$2" ]];then local NEW_PASS="$2";else local NEW_PASS="$DEV_PASS";fi;
  
  local HOME_USER="/home/$NEW_USER/";
  
  sudo useradd $NEW_USER;
  sudo usermod -aG wheel $NEW_USER;
  sudo mkdir -p $HOME_USER/Downloads/ $HOME_USER/Documents/ $HOME_USER/bin/ $HOME_USER/Projects/ $HOME_USER/.ssh;
  sudo touch $HOME_USER/.bashrc $HOME_USER/.bash_profile;
  # Add color to user prompt
  echo "PS1='\[\033[01;35m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\${PWD##*/}\[\033[00m\]\\$ ';" >> $HOME_USER/.bashrc;
  restoreHomePermissions $NEW_USER;
  
  sudo passwd "$NEW_USER" <<EOF
$NEW_PASS
$NEW_PASS
EOF
  
  echo "Please press enter fo continue...";
  # create ssh leave white spaces for enter
  sudo -i -u $NEW_USER ssh-keygen -f $HOME_USER/.ssh/id_rsa -t rsa -N "$NEW_PASS";

  # enable ssh
  sudo sed -i -e "s/PasswordAuthentication no/PasswordAuthentication yes/g"  /etc/ssh/sshd_config;
  sudo systemctl enable sshd.service;
  sudo systemctl start sshd.service;
  sudo systemctl restart sshd;
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
function mainTools {
  updateSystem;
  sudo yum install vim nano tmux htop iotop lynx nmap whois tcpdump iotop bind-utils wget -y;
}

# Dev tools
function devTools {
  # Dev tools
  sudo yum install -y redhat-rpm-config;
  sudo yum install -y centos-release-scl;
  sudo yum groupinstall -y --disablerepo=\* --enablerepo=base,updates,cr "Development Tools";
  sudo yum install -y dh-autoreconf vim-enhanced curl-devel expat-devel gettext-devel openssl-devel apr-devel perl-devel zlib-devel libvirt gtkmm30 libgdkmm-3.0.so.1 proj proj;
  sudo yum install -y asciidoc xmlto docbook2X binutils fedora-packager chrpath autoconf automake;
  sudo yum install -y gcc gcc-c++ qt-devel libffi-devel python python-devel nasm.x86_64 ant dkms kernel-devel dkms kernel-headers libstdc++.i686 subversion;
  #NOTE: PERVIOUS install all SDL* but cause conflig with "SDL2_gfx-docs"
  sudo yum install -y SDL-* SDL_* SDL2-* SDL2_ttf* SDL2_net* SDL2_mixer* SDL2_image* SDL2_gfx SDL2_gfx-devel;
  sudo yum install -y wget deluge rpm-build lsb sqlite-devel git-all kdiff3 openssh openssh-server ncurses-devel bzip2-devel;
  sudo yum install -y yum-utils device-mapper-persistent-data lvm2 p7zip unrar;
  sudo yum install -y libX11-devel freetype-devel libxcb-devel libxslt-devel libgcrypt-devel libxml2-devel gnutls-devel libpng-devel libjpeg-turbo-devel libtiff-devel gstreamer-devel dbus-devel fontconfig-devel libappindicator;
  # anydesk and teamviewer
  sudo yum install -y gtkglext-libs gtkglext-devel qt5-qtbase-gui qt5-qtbase-devel qt5-qtbase-common qt5-qtwebkit qt5-qtquickcontrols qt5-qtx11extras;
  sudo yum install -y samba-winbind-clients;
  sudo yum install -y glibc-devel.{i686,x86_64} libgcc.{i686,x86_64} libX11-devel.{i686,x86_64} freetype-devel.{i686,x86_64} gnutls-devel.{i686,x86_64} libxml2-devel.{i686,x86_64} libjpeg-turbo-devel.{i686,x86_64} libpng-devel.{i686,x86_64} libXrender-devel.{i686,x86_64} alsa-lib-devel.{i686,x86_64};
  sudo yum install -y libappindicator-gtk3;
}

# Python
function pipLibs {
  local PYTHON_EXEC="${1}";

  #remove for errors
  sudo ${PYTHON_EXEC} -m pip uninstall -y rpkg;

  sudo ${PYTHON_EXEC} -m pip install --upgrade pip;
  sudo ${PYTHON_EXEC} -m pip install --upgrade setuptools; # py27 error
  sudo ${PYTHON_EXEC} -m pip install --upgrade ez_setup;
  sudo ${PYTHON_EXEC} -m easy_install -U setuptools;
  sudo ${PYTHON_EXEC} -m pip install --upgrade pyOpenSSL; # py2 error 'pyOpenSSL'. It is a distutils installed
  sudo ${PYTHON_EXEC} -m pip install --upgrade jinja2;
  sudo ${PYTHON_EXEC} -m pip install --upgrade pyudev;
  sudo ${PYTHON_EXEC} -m pip install --upgrade dnspython;
  sudo ${PYTHON_EXEC} -m pip install --upgrade pyzmq;
  sudo ${PYTHON_EXEC} -m pip install --upgrade pygments;
  sudo ${PYTHON_EXEC} -m pip install --upgrade tornado;
  sudo ${PYTHON_EXEC} -m pip install --upgrade jsonschema; # py2 require rpkg
  sudo ${PYTHON_EXEC} -m pip install --upgrade ipython;
  sudo ${PYTHON_EXEC} -m pip install --upgrade python-dateutil;
  sudo ${PYTHON_EXEC} -m pip install --upgrade "ipython[notebook]"; ## obs4rve
  sudo ${PYTHON_EXEC} -m pip install --upgrade requests; # py2 require rpkg
  sudo ${PYTHON_EXEC} -m pip install --upgrade ansible;
  sudo ${PYTHON_EXEC} -m pip install --upgrade cryptography;
  sudo ${PYTHON_EXEC} -m pip install --upgrade virtualenv;
  sudo ${PYTHON_EXEC} -m pip install --upgrade selenium; # observe
  sudo ${PYTHON_EXEC} -m pip install --upgrade graphlab-create; # py2 require rpkg; py3 not found
  sudo ${PYTHON_EXEC} -m pip install --upgrade seaborn; # py2 Cannot uninstall 'pyparsing'
  sudo ${PYTHON_EXEC} -m pip install --upgrade oauth2client; # py2 pyasn1<0.5.0; py27 rsa==3.1.2,
  sudo ${PYTHON_EXEC} -m pip install --upgrade "pylint<2.0.0";
  
  sudo ${PYTHON_EXEC} -m pip install --upgrade rpm-py-installer; # py2 fail rpm-py-installer;
  sudo ${PYTHON_EXEC} -m pip install --upgrade koji;

  # no installed please
  #sudo pip install --upgrade jrnl; # error python-dateutil
  #sudo pip install --upgrade jrnl[encrypted]; # error  jupiter
}

function installPythonManual {
  cd /opt/;
  local PYTHON_VERSION="${1}";
  local PYTHON_DIR="${2}";
  sudo wget --no-check-certificate https://www.python.org/ftp/python/${PYTHON_VERSION}/Python-${PYTHON_VERSION}.tar.xz;
  sudo tar xf Python-${PYTHON_VERSION}.tar.xz;
  sudo chmod -R 755 Python*;
  cd Python-${PYTHON_VERSION};
  sudo ./configure --prefix=/usr/local --enable-shared --enable-unicode=ucs4;
  sudo ./configure --enable-optimizations;
  sudo make altinstall;
  local STRING_PYTHON_LIB="export LD_LIBRARY_PATH=/usr/local/lib:${PYTHON_DIR}:$LD_LIBRARY_PATH";
  local STRING_PY_ALIAS="alias python=${PYTHON_DIR}";
  sudo echo "$STRING_PYTHON_LIB" >> ${HOME_USER}/.bashrc;
  sudo echo "$STRING_PY_ALIAS" >> ${HOME_USER}/.bashrc;
  sudo su $DEV_USER <<EOF
  #echo "$STRING_PYTHON_LIB" >> ${HOME_USER}/.bashrc;
  #echo "$STRING_PY_ALIAS" >> ${HOME_USER}/.bashrc;
EOF
  bash ${HOME_USER}/.bashrc && sudo bash ${HOME_USER}/.bashrc;

  #sudo wget https://bitbucket.org/pypa/setuptools/raw/bootstrap/ez_setup.py;
  sudo wget https://bootstrap.pypa.io/ez_setup.py;
  sudo ${PYTHON_DIR} ez_setup.py;

  sudo ln -s ${PYTHON_DIR} /bin/python${PYTHON_VERSION};

  wget https://bootstrap.pypa.io/get-pip.py;
  sudo ${PYTHON_DIR} get-pip.py;

  pipLibs ${PYTHON_DIR};

  cd;
}

function pythonUpdate {
  # TODO: update version
  local PYTHON_VERSION271="2.7.16";
  local PYTHON_VERSION372="3.7.2";
  
  # Original dir bin
  local PYTHON2_DIR='/bin/python2.7'; # RH7 original python2
  local PYTHON36_DIR='/bin/python3.6';
  local PYTHON271_DIR='/usr/local/bin/python2.7'; # new updated version
  local PYTHON372_DIR='/usr/local/bin/python3.7'; # new updated version
  
  # download secure pip install pip
  wget https://bootstrap.pypa.io/get-pip.py;
  
  # install and update python local
  sudo yum install -y python-pip;
  /usr/local/bin/easy_install-2.7 pip;
  sudo yum install -y python-devel zeromq zeromq-devel;
  sudo ${PYTHON2_DIR} get-pip.py;
  pipLibs ${PYTHON2_DIR};
  
  # alternative python os libraries
  sudo yum install -y libpng-devel freetype freetype-devel;
  sudo yum install -y python-pandas;
  sudo yum install -y python-devel python-nose python-setuptools gcc gcc-gfortran gcc-c++ blas-devel lapack-devel atlas-devel;
  sudo yum install -y python2-crypto python-paramiko;

  # install again in old version
  pip install --upgrade jupyter-client;
  pip install --upgrade rpkg;
  
  # Install python 3.6
  sudo yum install -y rh-python36*;
  sudo ln -s /opt/rh/rh-python36/root/usr/bin/python3.6 ${PYTHON36_DIR};
  sudo rm -rf /usr/bin/python3;
  sudo ln -s ${PYTHON36_DIR} /bin/python3;
  sudo ${PYTHON36_DIR} get-pip.py;
  pipLibs ${PYTHON36_DIR};

  # install python new versions
  installPythonManual "${PYTHON_VERSION271}" "${PYTHON271_DIR}";
  installPythonManual "${PYTHON_VERSION372}" "${PYTHON372_DIR}";

  # browser drivers for sellenium
  if ! geckodriver --version || ! chromedriver --version ;then
      echo "Pendiente instalar los drivers de lo navegadores";
  fi;
}

function installGraphicVnc {
  #sudo yum groupinstall -y "Server with GUI" -y;

  local XINIT_STRIG="";

  if [[ $GRAPH_INTERFACE == 1 ]];then
    sudo yum groupinstall -y "KDE Plasma Workspaces";
    XINIT_STRIG="startkde &";
  elif [[ $GRAPH_INTERFACE == 2 ]];then
    sudo yum groupinstall -y "Xfce";
    XINIT_STRIG="xfce4-session & start xfce4 & xfce4-panel &";
  elif [[ $GRAPH_INTERFACE == 3 ]];then
    sudo yum groupinstall -y "GNOME Desktop";
    XINIT_STRIG="gnome-session &";
  fi;

  # optimized 
  sudo yum install -y x2goserver x2goserver-xsession;
  # enable ssh
  sudo sed -i -e "s/PasswordAuthentication no/PasswordAuthentication yes/g"  /etc/ssh/sshd_config;
  sudo systemctl restart sshd;
  
  # standar
  #sudo yum install tightvncserver -y; # not avalible
  sudo yum install -y xrdp tigervnc-server;

  sudo cp /lib/systemd/system/vncserver@.service /etc/systemd/system/vncserver@:1.service;
  # replace user in service file
  sudo sed -i -e "s/<USER>/$DEV_USER/g" /etc/systemd/system/vncserver@:1.service;
  #sudo vim /etc/systemd/system/vncserver@:1.service;
  sudo firewall-cmd --permanent --zone=public --add-service vnc-server;
  sudo firewall-cmd --permanent --add-port=3389/tcp;
  sudo firewall-cmd --reload;
  
  # login as user and pass command
  sudo -u $DEV_USER vncserver <<EOF
$DEV_PASS
$DEV_PASS
EOF

  sudo systemctl daemon-reload;
  sudo systemctl enable vncserver@:1.service;
  sudo systemctl start vncserver@:1.service;

  #xedp
  #config VNC
  sudo sed -i -e "s/autorun=.*/autorun=$DEV_USER/g" /etc/xrdp/xrdp.ini;
  sudo sed -i -e "s/crypt_level=.*/crypt_level=low/g" /etc/xrdp/xrdp.ini;
  if [[ ! $(grep -ne "channel_code=" /etc/xrdp/xrdp.ini) ]];then
    grep -m1 -nE "crypt_level" /etc/xrdp/xrdp.ini | awk -F ":" '{system("sed -i -e \""$1"s/"$2"/"$2"\\nchannel_code=1/\" /etc/xrdp/xrdp.ini")}';
  fi;


  if [[ ! $(grep -ne "\[vnc1\]" /etc/xrdp/xrdp.ini) ]];then
  local session_line="$(grep -m1 -ne "; Session types" /etc/xrdp/xrdp.ini | awk -F ':' '{print($1)}')";
  session_line=$((session_line+2));
  local config_session="[vnc1]\\\n\
name=vncserver\\\n\
lib=libvnc.so\\\n\
ip=localhost\\\n\
port=5901\\\n\
username=$DEV_USER\\\n\
password=$DEV_PASS\\\n\
xserverbpp=24\\\n\
delay_ms=250\\\n\
max_bpp=128\\\n\
use_compression=yes\\\n\
";
  sudo echo "" | sudo awk -v _session_line="${session_line}" -v _config_session="${config_session}" '{system("sed -i -e \""_session_line"s/.*/"_config_session"/\" /etc/xrdp/xrdp.ini")}';

  fi;
  
  # set resolution
  if [[ ! "$( grep -nE "^geometry" ${HOME_USER}/.vnc/config)" ]];then
    echo "geometry=1366x920,720x1280,640x480,800x600,1024x768,1280x800,1280x960,1280x1024,1360x768,1400x1050,1600x1200,1680x1050,1920x1200,1920x1080" >> ${HOME_USER}/.vnc/config;
  fi;

  # Disable kde and enable gnome
  if [[ ! "$(grep -nE \"^gnome-session\" ${HOME_USER}/.vnc/xstartup)" ]];then
    sudo sed -i -e "s#exec /etc/X11/xinit/xinitrc#\#exec /etc/X11/xinit/xinitrc#g" ${HOME_USER}/.vnc/xstartup;

    echo "
[ -x /etc/vnc/xstartup ] && exec /etc/vnc/xstartup
[ -r \$HOME/.Xresources ] && xrdb \$HOME/.Xresources
xsetroot -solid grey
vncconfig -iconic &
${XINIT_STRIG}" >> ${HOME_USER}/.vnc/xstartup;

  fi;

  sudo systemctl restart vncserver@:1.service;

  # Enable vnc
  sudo systemctl start xrdp;
  sudo systemctl enable xrdp;

  sudo chcon --type=bin_t /usr/sbin/xrdp;
  sudo chcon --type=bin_t /usr/sbin/xrdp-sesman;
  # sudo vim -o .vncrc .vnc/xstartup /etc/systemd/system/vncserver@:1.service /etc/xrdp/xrdp.ini .vnc/config

  # menu editable gnome
  sudo yum install -y alacarte;

}

# Databases services
function databases {
  sudo yum install -y postgresql-server postgresql-contrib postgresql-devel;
  sudo systemctl enable postgresql;
  #init database with empty data required to initializaed
  if sudo ls /var/lib/pgsql/data ;then
    sudo postgresql-setup initdb postgresql;
  fi;
  sudo systemctl start postgresql;
  sudo passwd postgres <<EOF
$DEV_PASS
$DEV_PASS
EOF
  # config
  sudo sed -i -e "s/\(\( peer\)\|\( ident\)\)/ md5/g" /var/lib/pgsql/data/pg_hba.conf;
  sudo sed -i -e "s/^#listen_addresses/listen_addresses/g" /var/lib/pgsql/data/postgresql.conf;
  sudo sed -i -e "s/^#port/port/g" /var/lib/pgsql/data/postgresql.conf;
  sudo systemctl restart postgresql.service

  sudo yum install -y pgadmin3;
}

# Ruby
function rubyTools {
  sudo yum install -y ruby ruby-devel rubygem-thor rubygem-bundler;
  sudo yum install -y rubygem-rake rubygem-test-unit;
  #sudo gem install rails; # error
}

# Install dsn, media apps and tools
function mediaTool {
  sudo rpm --import http://li.nux.ro/download/nux/RPM-GPG-KEY-nux.ro;
  sudo rpm -Uvh http://li.nux.ro/download/nux/dextop/el7/x86_64/nux-dextop-release-0-5.el7.nux.noarch.rpm;

  sudo yum install -y gnome-color-manager;
  # To fix
  sudo yum install -y gstreamer{1,}-{plugin-crystalhd,ffmpeg,plugins-{good,ugly,bad{,-free,-nonfree,-freeworld,-extras}{,-extras}}} libmpg123 lame-libs --setopt=strict=0;
  # npapi-vlc
  sudo yum install -y gimp inkscape blender fontforge ImageMagick ImageMagick-devel ImageMagick-perl optipng;
  sudo yum install -y ffmpeg ffmpeg-devel;
  # snap install inkscape;
}

# Install remte desktop windows
function remote {
  #remmina-plugins-gnome;
  sudo yum install -y remmina remmina-plugins-rdp remmina-plugins-vnc;
}

# Remmina-plugins-common
# Apache php
function apachePHP {
  sudo yum install -y httpd;
  sudo systemctl start httpd;
  sudo yum install -y php php-common php-pdo_mysql php-pdo php-gd php-mbstring;
  sudo systemctl restart httpd;
  sudo yum install -y perl-Net-SSLeay;
  # problems on installation dependences
  # sudo yum install php71w-fpm php71w-opcache -y;
  #perl-TO-Tty
  sudo systemctl stop httpd;
}

# DOCKER
function dockerTools {
  # enable fordware for build images
  echo "net.ipv4.ip_forward=1" >> /etc/sysctl.conf;
  sudo systemctl restart network;

  sudo yum remove -y docker docker-client docker-client-latest docker-common docker-latest docker-latest-logrotate docker-logrotate docker-selinux docker-engine-selinux docker-engine;
  sudo yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo;
  sudo yum-config-manager --enable docker-ce-edge;
  sudo yum-config-manager --enable docker-ce-test;
  sudo yum-config-manager --disable docker-ce-edge;
  sudo yum install -y docker-ce;
  sudo systemctl start docker;
  sudo systemctl enable docker;

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
  #sudo pip install docker-compose;
  sudo curl -L "https://github.com/docker/compose/releases/download/1.23.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose;
  sudo chmod +x /usr/local/bin/docker-compose;
  sudo ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose;
}

# Android dev
function javaAndroid {
  #sudo fastboot oem get_unlock_data
  sudo yum install -y android-tools;
  sudo yum install -y zlib.i686 ncurses-libs.i686 bzip2-libs.i686;
  sudo yum install -y fastboot;
  sudo yum install -y usbutils;

  #java
  sudo yum install -y java-1.7.0-openjdk-devel;
  sudo yum install -y java-1.8.0-openjdk-devel;

  #java oracle 8
  function addJavaOracle {
    local java_rpm="${1}";
    wget "https://storage.googleapis.com/${BUCKET_GET}/${java_rpm}";
    sudo rpm -ivh ${java_rpm};
  }

  for java_to_install in ${JAVA_RPMS};do
    addJavaOracle "${java_to_install}";
  done;

  # alternatives links following
  # /usr/bin/java    -> /etc/alternatives/java    -> /usr/java/jdk1.8.0_171-amd64/jre/bin/java
  # /usr/bin/javac   -> /etc/alternatives/javac   -> /usr/java/jdk1.8.0_171-amd64/bin/javac
  # /usr/bin/jar     -> /etc/alternatives/jar     -> /usr/java/jdk1.8.0_171-amd64/bin/jar
  # /usr/bin/javaws  -> /etc/alternatives/javaws  -> /usr/java/jdk1.8.0_171-amd64/jre/bin/javaws

  # TIP: for fix REMOVE all alternatives with "remove_alternatives_java" and reinstall with "install_alternatives_java";

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
    sudo alternatives --config java <<EOF
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

  for java_to_install in ${JAVA_INSTALL};do
    install_alternatives_java "${java_to_install}";
  done;

  select_alternative_java 1;

  # java version
  java -version;
}

# vim
function vimConfig {
  sudo mkdir -p ${HOME_USER}/.vim/autoload;
  sudo mkdir -p ${HOME_USER}/.vim/bundle;
  sudo curl -LSso ${HOME_USER}/.vim/autoload/pathogen.vim https://tpo.pe/pathogen.vim;
  cd $HOME_USER.vim/bundle/;

  for i in https://github.com/mattn/emmet-vim \
    https://github.com/scrooloose/nerdtree.git \
    https://github.com/tomtom/tlib_vim \
    https://github.com/leafgarland/typescript-vim \
    https://github.com/MarcWeber/vim-addon-mw-utils \
    https://github.com/vim-scripts/vim-auto-save \
    https://github.com/digitaltoad/vim-pug \
    https://github.com/tpope/vim-sensible \
    https://github.com/wavded/vim-stylus.git; \
  do
    sudo git clone $i;
  done;

  cd ${HOME_USER};

  if [ ! -e ${HOME_USER}/.vimrc ];then \
    sudo touch ${HOME_USER}/.vimrc; \
    sudo chmod 775 ${HOME_USER}/.vimrc; \
  fi;

  if ! sudo grep ${HOME_USER}/.vimrc -e "execute pathogen#infect()";then \
    sudo printf "set enc=utf-8\nset fileencoding=utf-8set hls\nset number\nset relativenumber\nset tabstop=2\nset shiftwidth=2\nset expandtab\nset cindent\nset wrap! \n" >> ${HOME_USER}/.vimrc; \
    sudo printf "xnoremap p pgvy\nnnoremap <C-H> :Hexmode<CR>\ninoremap <C-H> <Esc>:Hexmode<CR>\nvnoremap <C-H> :<C-U>Hexmet rela  de<CR> \n" >> ${HOME_USER}/.vimrc; \
    sudo printf "let mapleader = \",\"\nnmap <leader>ne :NERDTreeToggle<cr> \n" >> ${HOME_USER}/.vimrc; \
    sudo printf "execute pathogen#infect() \ncall pathogen#helptags() \nsyntax on \nfiletype plugin indent on \n" >> ${HOME_USER}/.vimrc; \
  fi;

  cd $HOME_USER;
  restoreHomePermissions $NEW_USER;
}

# nodejs
function nodeConfig {
  # nodejs
  sudo yum remove nodejs -y;
  if [ ! -e ${HOME_USER}/.nvm ];then
    sudo su $DEV_USER <<EOF
    echo ${HOME_USER};
    #TODO: update nvm version
    curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.34.0/install.sh | bash;
    source ${HOME_USER}/.nvm/nvm.sh;
    source ${HOME_USER}/.bashrc;
    nvm install 8;
    nvm use 8;
    nvm alias default $(nvm current);
    npm i -g stylus nib pug-cli less less-prefixer watch-less http-server bower;
EOF
  fi;
}

function installMariaDB {

  sudo yum install -y mariadb-server;
  sudo systemctl start mariadb;
  sudo systemctl enable mariadb;
  sudo mysql_secure_installation <<EOF

$DEV_PASS
y
$DEV_PASS
$DEV_PASS
y
n
n
y
EOF

  sudo systemctl start mariadb.service;
  sudo systemctl enable mariadb.service;
}

function installKvm {
  # https://www.cyberciti.biz/faq/how-to-install-kvm-on-centos-7-rhel-7-headless-server/
  sudo yum install -y qemu-kvm libvirt libvirt-python libguestfs-tools virt-install;
  sudo systemctl enable libvirtd;
  sudo systemctl start libvirtd;
  sudo lsmod | grep -i kvm;
  sudo brctl show;
  sudo virsh net-list;
  sudo virsh net-dumpxml default;
  sudo su <<EOF
echo "BRIDGE=br0" > /etc/sysconfig/network-scripts/enp3s0;
echo 'DEVICE="br0"
# I am getting ip from DHCP server #
BOOTPROTO="dhcp"
IPV6INIT="yes"
IPV6_AUTOCONF="yes"
ONBOOT="yes"
TYPE="Bridge"
DELAY="0"
' > /etc/sysconfig/network-scripts/ifcfg-br0;
EOF

sudo systemctl restart NetworkManager;
sudo brctl show;

# permissions
#sudo chown ${DEV_USER} /dev/kvm;
sudo chmod o+x /dev/kvm;

#  irtual box https://libre-software.net/install-virtualbox-on-centos-scientific-linux-rhel/
sudo yum install dkms;
sudo wget -P /etc/yum.repos.d http://download.virtualbox.org/virtualbox/rpm/rhel/virtualbox.repo;
sudo yum install -y VirtualBox-6.0;
sudo usermod -a -G vboxusers ${DEV_USER};
}

function devPrograms {
  #fish shell
  cd /etc/yum.repos.d/;
  sudo wget https://download.opensuse.org/repositories/shells:fish:release:2/CentOS_7/shells:fish:release:2.repo;
  sudo yum install -y fish;

  cd;

  # client java
  wget https://dbeaver.io/files/dbeaver-ce-latest-stable.x86_64.rpm;
  sudo rpm -ivh dbeaver-ce-latest-stable.x86_64.rpm;

  # https://code.visualstudio.com/docs/setup/linux
  sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc;
  sudo sh -c 'echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/yum.repos.d/vscode.repo';
  sudo yum check-update -y;
  sudo yum install -y code;

  #chrome
  cat << EOF > /etc/yum.repos.d/google-chrome.repo
[google-chrome]
name=google-chrome
baseurl=http://dl.google.com/linux/chrome/rpm/stable/x86_64
enabled=1
gpgcheck=1
gpgkey=https://dl.google.com/linux/linux_signing_key.pub
EOF
  sudo yum install -y google-chrome-stable;

  # firefox
  sudo yum install -y firefox;
  
  # sublime
  sudo rpm -v --import https://download.sublimetext.com/sublimehq-rpm-pub.gpg;
  sudo yum-config-manager --add-repo https://download.sublimetext.com/rpm/stable/x86_64/sublime-text.repo;
  sudo yum install -y sublime-text;

  # TODO: update version pycharm
  local pycharm_version="pycharm-community-2019.1.1";
  wget "https://download.jetbrains.com/python/${pycharm_version}.tar.gz";
  tar -xvzf ${pycharm_version}.tar.gz;
  mv -f ${pycharm_version} ${HOME_USER}/bin/pycharm-community;
  restoreHomePermissions;

  #eclipse 
  local eclipse_version="eclipse-jee-photon-R-linux-gtk-x86_64";
  wget "http://download.obeo.fr/photon/${eclipse_version}.tar.gz";
  tar -xvzf ${eclipse_version}.tar.gz;
  mv -f eclipse ${HOME_USER}/bin/eclipse;
  restoreHomePermissions;

  #sts TODO: update spring
  wget 'https://download.springsource.com/release/STS4/4.2.0.RELEASE/dist/e4.11/spring-tool-suite-4-4.2.0.RELEASE-e4.11.0-linux.gtk.x86_64.tar.gz';
  tar -xvzf spring-tool-suite-4-4.2.0.RELEASE-e4.11.0-linux.gtk.x86_64.tar.gz;
  mv -f sts-4.2.0.RELEASE ${HOME_USER}/bin/spring-tool-suite;
  restoreHomePermissions;

  #apache dorectory studio
  wget "https://www-us.apache.org/dist/directory/studio/2.0.0.v20180908-M14/ApacheDirectoryStudio-2.0.0.v20180908-M14-linux.gtk.x86_64.tar.gz";
  tar -xvzf ApacheDirectoryStudio-2.0.0.v20180908-M14-linux.gtk.x86_64.tar.gz;
  mv -f ApacheDirectoryStudio ${HOME_USER}/bin/;
  restoreHomePermissions;

  #gradle java
  function addGradle {
    local gradle_version="$1";
    sudo mkdir -p $HOME_USER/bin/gradle/;
    wget "https://services.gradle.org/distributions/${gradle_version}-bin.zip";
    unzip ${gradle_version}-bin.zip;
    mv -f ${gradle_version} $HOME_USER/bin/gradle/;
    restoreHomePermissions;
  }

  addGradle "gradle-3.5.1";
  addGradle "gradle-5.3.1";

  local STRING_GRADLE_LIB="export PATH=\$PATH:~/bin/gradle/gradle-5.3.1/bin;";
  sudo echo "$STRING_GRADLE_LIB" >> ${HOME_USER}/.bashrc;
  
  # maven
  local maven_version='3.6.1';
  sudo mkdir -p $HOME_USER/bin/maven/;
  wget http://apache.cs.utah.edu/maven/maven-3/${maven_version}/binaries/apache-maven-${maven_version}-bin.tar.gz;
  tar -xzf apache-maven-${maven_version}-bin.tar.gz;
  mv -f ./apache-maven-${maven_version}/ $HOME_USER/bin/maven/;
  restoreHomePermissions;
  sudo echo "export PATH=\$PATH:~/bin/maven/apache-maven-${maven_version}/bin" >> ${HOME_USER}/.bashrc;
  
  # tomcat
  function addTomcat {
    local tomcat_version="$1";
    local tomcat_subversion="$2";
    sudo mkdir -p $HOME_USER/bin/tomcat/;
    wget "https://www-us.apache.org/dist/tomcat/tomcat-${tomcat_version}/v${tomcat_subversion}/bin/apache-tomcat-${tomcat_subversion}.tar.gz";
    tar -xvzf "apache-tomcat-${tomcat_subversion}.tar.gz";
    mv -f "apache-tomcat-${tomcat_subversion}" ${HOME_USER}/bin/tomcat/;
    restoreHomePermissions;
  }

  addTomcat "8" "8.5.40";

  # git
  sudo -i -u ${DEV_USER} git config --global user.name "${DEV_USER}";
  sudo -i -u ${DEV_USER} git config --global user.email "${DEV_USER}@instance.vnc";

  # docker cerbot
  local STRING_CERBOT="alias cerbot=\"docker run --rm -it -p 443:443 -v \$HOME/cerbot:/etc/letsencrypt -v \$HOME/cerbot/log:/var/log/letsencrypt quay.io/letsencrypt/letsencrypt:latest\";";
  sudo echo "${STRING_CERBOT}" >> ${HOME_USER}/.bashrc;

  # TODO: update cloud sdk
  
  local gcloud_version="google-cloud-sdk-240.0.0-linux-x86_64";
  wget "https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/${gcloud_version}.tar.gz";
  tar -xvzf ${gcloud_version}.tar.gz;
  mv -f google-cloud-sdk ${HOME_USER}/bin/;
  restoreHomePermissions;
  
  sudo yum install -y kubectl google-cloud-sdk*;

  # validate python2.7.16
  echo "PLEASE: press Y and enter to continue...";
  sudo -i -u $DEV_USER ${HOME_USER}/bin/google-cloud-sdk/install.sh -q;
  if [[ ! "$(cat $HOME_USER/.bashrc)" == *"google-cloud-sdk"* ]];then
    sudo -i -u $DEV_USER echo "if [ -f '~/bin/google-cloud-sdk/completion.bash.inc' ]; then source '~/bin/google-cloud-sdk/completion.bash.inc'; fi;" >> ${HOME_USER}/.bashrc;
    sudo -i -u $DEV_USER echo "export PATH=PATH:'~/bin/google-cloud-sdk/platform/google_appengine';" >> ${HOME_USER}/.bashrc;
    sudo -i -u $DEV_USER echo "export PATH=PATH:'~/bin/google-cloud-sdk/bin';" >> ${HOME_USER}/.bashrc;
    sudo sed -i -e "s/PATH=PATH/PATH=\$PATH/g"  ${HOME_USER}/.bashrc;
    
    sudo -i -u $DEV_USER echo "alias gcloud='~/bin/google-cloud-sdk/bin/gcloud';" >> ${HOME_USER}/.bashrc;
    
    sudo -i -u $DEV_USER ${HOME_USER}/bin/google-cloud-sdk/install.sh -q;
  fi;
  restoreHomePermissions;
  
  sudo -i -u $DEV_USER ${HOME_USER}/bin/google-cloud-sdk/bin/gcloud components update -q;
  sudo -i -u $DEV_USER ${HOME_USER}/bin/google-cloud-sdk/bin/gcloud components install beta alpha \
  app-engine-python app-engine-python-extras kubectl bq \
  app-engine-java app-engine-php app-engine-go pubsub-emulator \
  cloud-datastore-emulator gcd-emulator docker-credential-gcr -q;

  # add to path
  local STRING_APPENGINE_OVERWRITE="sed -i '1s/.*/#\!\/usr\/bin\/env python2.7/' \"\$HOME/bin/google-cloud-sdk/bin/dev_appserver.py\";";
  sudo echo "${STRING_APPENGINE_OVERWRITE}" >> ${HOME_USER}/.bashrc;
  restoreHomePermissions;

  # add download appengine app
  sudo echo "alias appcfg.py=\"python \$HOME/bin/google-cloud-sdk/platform/google_appengine/appcfg.py\";" >> ${HOME_USER}/.bashrc;
  
  # add vscode/code-server
  # TODO:update version
  cd ${HOME_USER}/bin/;
  local VSCODE_VERSION="1.696-vsc1.33.0";
  wget https://github.com/codercom/code-server/releases/download/${VSCODE_VERSION}/code-server${VSCODE_VERSION}-linux-x64.tar.gz;
  tar -xzvf code-server${VSCODE_VERSION}-linux-x64.tar.gz;
  rm -rf code-server${VSCODE_VERSION}-linux-x64.tar.gz;
  mv code-server${VSCODE_VERSION}-linux-x64 code-server;
  sudo echo "alias code-server=\"\$HOME/bin/code-server/code-server --allow-http -e ~/.vscode/extensions -d ~/.config/Code\";" >> ${HOME_USER}/.bashrc;
  
  sudo echo "alias vscode-server='docker run -it --rm --net host --name code-server -p 8443:8443 -v \$HOME/.config/Code:/home/coder/.config/Code -v \$HOME/.vscode/extensions:/home/coder/.vscode/extensions codercom/code-server:latest --allow-http -P $DEV_PASS -e /home/coder/.vscode/extensions -d /home/coder/.config/Code';" >> ${HOME_USER}/.bashrc;
  
  # clean
  cd;
  rm -rf *.zip *.tar *.tar.gz *.tgz *.rpm;
}

function installWine {
  cleanDnf;
  cd /usr/src;
  sudo wget http://dl.winehq.org/wine/source/3.0/wine-3.0.tar.xz;
  sudo tar -Jxvf wine-3.0.tar.xz;
  mv -f wine-3.0 wine64;
  sudo chmod -R 755 wine64;
  cp -rfa wine64 wine32;
  #64
  cd wine64;
  sudo ./configure  --enable-win64;
  sudo make;
  sudo make install;
  #32
  cd ../wine32;
  sudo ./configure;
  sudo make;
  sudo make install;

  #wine64 --version;
  #wine --version;
  # wine putty.exe;

}

function manualSteps {
  #manual
  echo "
  ---## MANUAL INSTALATTIONS ###--
    - change language in "sudo vim /etc/locale.conf"
      LANG="en_US.UTF-8"
      LC_CTYPE="en_US.UTF-8"
    - tomcat: (donwload and run in folder)
    - postgres: (autoinstall and complete configuration):
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
        dir_apps=${HOME_USER}Downloads/programs/;for app in $(find $dir_apps -name "*.rpm");do sudo yum install -y ${dir_app}${app};done;
    - install chrome:
        - sudo yum install -y google-chrome-stable_current_x86_64.rpm
  ";
  cd;
}

function cleanInstallFiles {
  cd;
  sudo rm -rf *;
}

# duplicateUser user_to_copy new_user pass_new_user
function duplicateUser {
  local user_to_copy="$1";
  local new_user="$2";
  local pass_new_user="$3";
  cd;
  createUser "$new_user" "$pass_new_user";
  #copy folder path
  sudo rm -rf "/home/$new_user/";
  sudo cp -rfv "/home/$user_to_copy/" "/home/$new_user/";
  # note: copy folder with *
  local FILES=".bashrc .bash_profile .config/ bin/ .local/ .npm/ .nvm/ .ssh/ .vim/ .vimrc .vnc .vncrc";
  
  for file in $FILES;do
    
    grep --include "*.rc" --include ".*" \
         --include "*.desktop" --include "*.sh" --include "*.ini" \
         -m1 -rnHE "${user_to_copy}" "/home/${new_user}/${file}" | awk -F ":" -v _from_user="${user_to_copy}" -v _to_user="${new_user}" '{system("sed -i -e \"s/\\/"_from_user"/\\/"_to_user"/g\" "$1)}';
  done;
  #add to docker group
  sudo gpasswd -a $new_user docker;
  restoreHomePermissions "${new_user}";
}

function installAll {
  
  if [[ ! "$(which tmux)" ]];then
    updateSystem;
    mainTools;
    echo "Please type \"tmux\" and execute: \"source ./i.sh\"";
  else
    initInfo;
    createUser;
    cleanDnf;
    #mountDisk;
    pythonUpdate;
    databases;
    rubyTools;
    mediaTool;
    remote; ## error
    apachePHP;
    dockerTools; #docker compose pip
    javaAndroid; # error by java
    vimConfig;
    nodeConfig;
    installMariaDB;
    devPrograms;
    installGraphicVnc;
    devTools; # pass for second time needed
    installKvm;
    cleanDnf;
    installWine;
    cleanDnf;
    manualSteps;
    cleanInstallFiles;
    #duplicateUser from_user to_new_user new_pass;
  fi;
}

echo "Do you want install (y):";
read isInstall;
if [[ $isInstall == "y" || $isInstall == "Y"  ]];then
  installAll;
fi;
