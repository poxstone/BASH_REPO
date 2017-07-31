apt -y update
apt -y upgrade
apt -y install coreutils
apt -y install python2
alias python="python2"
alias pip="pip2"
apt -y install python2-dev
apt -y install libllvm
apt -y install clang
apt -y install fftw
apt -y install git
apt -y update && apt upgrade
apt -y install autoconf make gcc openssl-dev libffi-dev python2-dev
pip2 install ansible
apt -y install curl
apt -y install vim
apt -y install tree
apt -y install tmux
apt -y install nmap
apt -y install nodejs
termux-setup-storage
npm install -g typescript
npm install -g @angular/cli
#psql
apt -y install postgresql
#https://wiki.termux.com/wiki/Postgresql
#mkdir -p $PREFIX/var/lib/postgresql
#initdb $PREFIX/var/lib/postgresql
#Starting the database
#
#pg_ctl -D $PREFIX/var/lib/postgresql start
#Similarly stop the database using
#pg_ctl stop
