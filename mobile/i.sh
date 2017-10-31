apt -y update && apt upgrade;
termux-setup-storage;
pkg install util-linux;
apt -y install coreutils;
apt -y install python2;
alias python="python2";
alias pip="pip2";
apt -y install python2-dev;
apt -y install libllvm;
apt -y install clang;
apt -y install fftw;
apt -y install git;
apt -y install autoconf make gcc openssl-dev libffi-dev python2-dev;
pip2 install ansible;
apt -y install curl;
apt -y install vim;
apt -y install tree;
apt -y install tmux;
apt -y install nmap;
apt -y install nodejs;
npm install -g typescript;
npm install -g @angular/cli stylus nib http-server;
# vim
mkdir -p ~/.vim/bundle/;
mkdir -p ~/.vim/autoload/;
curl -LSso ~/.vim/autoload/pathogen.vim https://tpo.pe/pathogen.vim;
cd ~/.vim/bundle/;
for i in https://github.com/mattn/emmet-vim \
  https://github.com/scrooloose/nerdtree.git \
  https://github.com/tomtom/tlib_vim \
  https://github.com/leafgarland/typescript-vim \
  https://github.com/MarcWeber/vim-addon-mw-utils \
  https://github.com/vim-scripts/vim-auto-save \
  https://github.com/digitaltoad/vim-pug \
  https://github.com/tpope/vim-sensible \
  https://github.com/wavded/vim-stylus.git;
do git clone $i;done;
cd ~;
  if [ ! -e ~/.vimrc ];then
    touch ~/.vimrc;
    chmod 775 ~/.vimrc;
  fi;
  if ! grep ~/.vimrc -e "execute pathogen#infect()";then \
    printf "set enc=utf-8\nset fileencoding=utf-8set hls\nset number\nset relativenumber\nset tabstop=2\nset shiftwidth=2\nset expandtab\nset cindent\nset wrap! \n" >> ~/.vimrc;
    printf "xnoremap p pgvy\nnnoremap <C-H> :Hexmode<CR>\ninoremap <C-H> <Esc>:Hexmode<CR>\nvnoremap <C-H> :<C-U>Hexmet rela  de<CR> \n" >> ~/.vimrc;
    printf "let mapleader = \",\"\nnmap <leader>ne :NERDTreeToggle<cr> \n" >> ~/.vimrc;
    printf "execute pathogen#infect() \ncall pathogen#helptags() \nsyntax on \nfiletype plugin indent on \n" >> ~/.vimrc;
  fi;
#gcloud replace
gcloud=~/bin/google-cloud-sdk;
ls $gcloud/bin | awk '{system("termux-fix-shebang '$gcloud'/bin/"$0)'};
find $gcloud -name "*.sh" -type f | awk '{system("termux-fix-shebang "$0)'};
find $gcloud -nameo "*.py" -type f | awk '{system("termux-fix-shebang "$0)'};
termux-fix-shebang ~/bin/google-cloud-sdk/platform/google_appengine/dev_appserver.py;

#git-config
git config --global user.name poxstone;
git config --global user.email poxstone@gmail.com;

#psql
#apt -y install postgresql
#https://wiki.termux.com/wiki/Postgresql
#mkdir -p $PREFIX/var/lib/postgresql
#initdb $PREFIX/var/lib/postgresql
#Starting the database
#pg_ctl -D $PREFIX/var/lib/postgresql start
#Similarly stop the database using
#pg_ctl stop
#!/data/data/com.termux/files/usr/bin/bash
