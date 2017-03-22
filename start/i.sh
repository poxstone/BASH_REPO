#!/bin/bash
dones=();
not_dones=();

# functiondone
function doneNoDone () {
    local cmd=$@
    printf '\n\n<<<<<<<<<<<<<<<<<<<<<<<< INSTALLING >>>>>>>>>>>>>>>>>>>>>>>>';
    echo -e "\n  $cmd";
    echo '######################## INSTALLING ########################';

    if eval $cmd;then
        dones+=("$cmd");
    else
        not_dones+=("$cmd");
    fi;
};

to_install=(
    # update all
    # 'sudo apt-get clean -y' # fixer
    # 'sudo apt-get autoremove -y' # fixer
    # 'sudo apt-get install -f -y' # fixer
    # 'sudo dpkg --purge --force-all *' # fixer
    # 'sudo apt-get dist-upgrade -y' # fixer
    # 'sudo apt-get purge virtualbox* -y' # fixer
    'sudo apt-get update'
    # 'sudo dpkg --configure -a'
    'sudo apt-get upgrade -y'
    # Libraries
    'sudo apt-get install git gitk -y'
    'sudo apt-get install curl build-essential autoconf libtool pkg-config python-opengl python-imaging python-pyrex python-pyside.qtopengl idle-python2.7 qt4-dev-tools qt4-designer libqtgui4 libqtcore4 libqt4-xml libqt4-test libqt4-script libqt4-network libqt4-dbus python-qt4 python-qt4-gl libgle3 python-dev python-setuptools python-virtualenv libpcap0.8-dev libnetfilter-queue-dev libssl-dev libjpeg-dev libxml2-dev libxslt1-dev libcapstone3 libcapstone-dev libffi-dev file checkinstall python-pip build-essential libssl-dev -y'
    'apt-get install autoconf g++ python2.7-dev -y'
    'sudo easy_install greenlet'
    'sudo easy_install gevent'
    # Editors and basic nedded
    'sudo apt-get install vim -y'
    'sudo apt-get install tmux -y'
    # 'sudo apt-get install chromium-browser -y'
    # node js
    # 'if nvm --version;then echo "nvm installed";else curl https://raw.githubusercontent.com/creationix/nvm/v0.32.2/install.sh | bash && source ~/.profile;sudo chmod -R 777 ~/.nvm;source .bashrc;fi;'
    # 'npm i -g stylus nib http-server bower jade svgexport less less-prefixer watch-less'
    # Python libs
    # 'pip install virtualenvwrapper pyopenssl'
    'pip install pycrypto'
    # mysql
    'sudo apt-get install libmysqlclient-dev mysql-server mysql-client -y'
    # Dev tools
    'sudo apt-get install htop lynx whois nmap -y'
    'sudo apt-get install tree whois -y'
    # Google Drive
    # 'sudo add-apt-repository ppa:nilarimogard/webupd8 -y && sudo apt-get update && sudo apt-get install grive -y'
    # Design tools
    'sudo apt-get install inkscape gimp -y'
    'sudo apt-get install imagemagick -y'
    # Java and gradle
    'sudo add-apt-repository ppa:webupd8team/java -y'
    'sudo add-apt-repository ppa:cwchien/gradle -y'
    'sudo apt-get update'
    'if java -version ;then echo done;else apt-get install oracle-java7-installer -y;fi;'
    'sudo apt-get install gradle -y' 
    'sudo update-rc.d tomcat7 disable' # disable gradle service
    # Other dev tools
    # Virtualbox
    # 'if [[ $(dpkg -s virtualbox 2>&1) == *"Status: install ok installed"* ]];then echo "virtualbox installed";else sudo apt-get install virtualbox virtualbox-ext-pack -y;fi;'
);

countApp=0;
while [ $countApp -lt ${#to_install[@]} ];do
    # echo ${to_install[$countApp]};
    doneNoDone ${to_install[$countApp]};
    let countApp=countApp+1;
done;

echo -e "\n########## DONES (${#dones[@]}) ##########";
countDones=0;
while [ $countDones -lt ${#dones[@]} ];do
    echo ${dones[$countDones]};
    let countDones=countDones+1;
done;

echo -e "\n########## NOT DONES (${#not_dones[@]}) ##########";
countNotDones=0;
while [ $countNotDones -lt ${#not_dones[@]} ];do
    echo ${not_dones[$countNotDones]};
    let countNotDones=countNotDones+1;
done;

