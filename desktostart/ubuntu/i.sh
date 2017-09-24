#! /bin/bash
# initial installation
apt-get update -y && apt-get upgrade -y && apt autoremove -y; \
# for ligth dockerfile 
apt-get update -y && apt-get install -y grep sed git vim tmux curl wget net-tools tree whois && \
    mkdir -p ~/.vim/autoload ~/.vim/bundle && \
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
    cd /; \
    if [ ! -e ~/.vimrc ];then \
      touch ~/.vimrc; \
      chmod 775 ~/.vimrc; \
    fi; \
    if ! grep ~/.vimrc -e "execute pathogen#infect()";then \
      printf "set enc=utf-8\nset fileencoding=utf-8set hls\nset number\nset relativenumber\nset tabstop=2\nset shiftwidth=2\nset expandtab\nset cindent\nset wrap! \n" >> ~/.vimrc; \
      printf "xnoremap p pgvy\nnnoremap <C-H> :Hexmode<CR>\ninoremap <C-H> <Esc>:Hexmode<CR>\nvnoremap <C-H> :<C-U>Hexmet rela  de<CR> \n" >> ~/.vimrc; \
      printf "let mapleader = \",\"\nnmap <leader>ne :NERDTreeToggle<cr> \n" >> ~/.vimrc; \
      printf "execute pathogen#infect() \ncall pathogen#helptags() \nsyntax on \nfiletype plugin indent on \n" >> ~/.vimrc; \
    fi; \
# install node
apt-get install -y build-essential libssl-dev && \
    . ~/.nvm/nvm.sh && . ~/.bashrc; \
    if nvm --version && stylus --version && pug --version;then \
        echo "node not need instalation"; \
    else \
        curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.33.2/install.sh | bash && \
        . ~/.nvm/nvm.sh && . ~/.bashrc; \
        nvm install 8 && nvm use 8 && nvm alias default $(nvm current) && \
        npm i -g stylus nib pug-cli svgexport less less-prefixer watch-less http-server bower; \

    fi; \
# install builds
apt-get install -y build-essential autoconf libtool pkg-config python-opengl python-imaging python-pyrex python-pyside.qtopengl idle-python2.7 qt4-dev-tools qt4-designer libqtgui4 \
    libqtcore4 libqt4-xml libqt4-test libqt4-script libqt4-network libqt4-dbus python-qt4 python-qt4-gl libgle3 python-dev python-setuptools libpcap0.8-dev libnetfilter-queue-dev \
    libssl-dev libjpeg-dev libxml2-dev libxslt1-dev libcapstone-dev libffi-dev file checkinstall python-pip libssl-dev unrar; \
# Python libs
pip install --upgrade pip && \
pip install virtualenvwrapper pyopenssl easy_install greenlet jrnl[encrypted] ansible cryptography virtualenv selenium gevent pycrypto; \
#sudo dnf install python-pandas -y;
# Dev tools
apt-get install -y htop lynx gitk git-all kdiff3 autoconf g++ python2.7-dev nmap; \
# Design tools removed(libpng12-dev libtiff4-dev)
apt-get install -y inkscape gimp imagemagick libjpeg62-dev tesseract\* krita blender optipng vlc; \
# install remte desktop windows
apt-get install -y remmina; \
#pache
apt-get install -y apache2; \
# sublime
wget -qO - https://download.sublimetext.com/sublimehq-pub.gpg | sudo apt-key add -; \
echo "deb https://download.sublimetext.com/ apt/stable/" | tee /etc/apt/sources.list.d/sublime-text.list; \
apt-get update && apt-get install -y sublime-text; \
#hyper terminal
apt-get install -y gdebi; \ 
wget https://hyper-updates.now.sh/download/linux_deb; \ 
gdebi linux_deb; \ 
# docker
apt-get install -y apt-transport-https ca-certificates software-properties-common; \ 
if ! docker -v;then \
    apt-get remove -y docker docker-engine docker.io; \
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add - && \
    apt-key fingerprint 0EBFCD88 && \
    add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu  $(lsb_release -cs) stable" && \
    apt-get install -y docker-ce; \
    groupadd docker; \
    gpasswd -a $USER docker; \
    apt-get install -y docker-compose; \
fi; \
# ssh-server #https://help.ubuntu.com/lts/serverguide/openssh-server.html
apt-get install -y openssh-client openssh-server; \
if [ -e /etc/ssh/sshd_config.original ]; then \
  cp /etc/ssh/sshd_config /etc/ssh/sshd_config.original; \
  chmod a-w /etc/ssh/sshd_config.original; \
  systemctl restart sshd.service
fi; \
#android studio
apt-get install -y lib32z1 lib32ncurses5 lib32stdc++6; \
#android smartphones
apt-get install -y android-tools-adb android-tools-fastboot; \
# mysql
apt-get install -y libmysqlclient-dev mysql-server mysql-client; \
apt-get install -y mysql-workbench; \
#java oracle
if [[ $JAVA_HOME == "" ]];then \
  sudo add-apt-repository ppa:webupd8team/java -y; \
  sudo apt-get update; \
  sudo echo debconf shared/accepted-oracle-license-v1-1 select true | debconf-set-selections; \
  sudo echo debconf shared/accepted-oracle-license-v1-1 seen true | debconf-set-selections; \
  sudo echo "JAVA 8 ORACLE REQUIERE INSTALARSE MANUALMENTE COPIANDO Y PEGANDO ESTOS COMANDOS ----*/*/*/*//// NOTA"; \
  sudo apt install -y oracle-java8-set-default; \
  sudo apt-get install -y oracle-java8-installer; \
  sudo update-alternatives --config java; \
  sudo update-alternatives --config javac; \
  if ! grep /etc/environment -e "JAVA_HOME";then \
      echo 'JAVA_HOME="/usr/lib/jvm/java-8-oracle"' >> /etc/environment; \
      source /etc/environment; \
  fi; \
fi;
# gcloud
if gcloud -v;then \
  curl https://sdk.cloud.google.com | bash && \
  exec -l $SHELL; \
  gcloud init; \
fi; \
# clean
chown -R $USER:$(id -gn $USER) ~/.nvm; \
chown -R $USER:$(id -gn $USER) ~/.config; \
chown -R $USER:$(id -gn $USER) ~/.; \
apt autoremove -y; \
