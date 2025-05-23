#/data/data/com.termux/files/usr/etc/apt/sources.list.d
pkg update -y && pkg upgrade -y;
termux-setup-storage;
pkg install -y root-repo;
pkg install -y util-linux;
pkg install -y coreutils;
pkg install -y git;
pkg install -y python;
pkg install -y libllvm;
pkg install -y clang;
pkg install -y fftw;
pkg install -y openssh;
pkg install -y git;
pkg install -y autoconf make;
pkg install -y curl;
pkg install -y vim;
pkg install -y wget;
pkg install -y tree;
pkg install -y tmux;
pkg install -y nmap;
pkg install -y nodejs;
pkg install -y dnsutils;
pkg install -y whois;
pkg install -y tsu; # tsu -A su #wrapper for Termux
pkg install -y tracepath;
pkg install -y kubectl;

pip install ansible;
npm install -g typescript;
pkg install -y nodejs-lts;
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
wget https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-sdk-295.0.0-linux-x86_64.tar.gz;
tar -xvzf google-cloud-sdk-295.0.0-linux-x86_64.tar.gz;
#gcloud replace
gcloud=~/bin/google-cloud-sdk;
ls $gcloud/bin | awk '{system("termux-fix-shebang '$gcloud'/bin/"$0)'};
find $gcloud -name "*.sh" -type f | awk '{system("termux-fix-shebang "$0)'};
find $gcloud -nameo "*.py" -type f | awk '{system("termux-fix-shebang "$0)'};
termux-fix-shebang ~/bin/google-cloud-sdk/platform/google_appengine/dev_appserver.py;

#git-config
git config --global user.name droid;
git config --global user.email droid@email.com;

mkdir bin;
mv google-cloud-sdk bin;
./bin/google-cloud-sdk/install.sh;

#psql
#pkg install -y postgresql
#https://wiki.termux.com/wiki/Postgresql
#mkdir -p $PREFIX/var/lib/postgresql
#initdb $PREFIX/var/lib/postgresql
#Starting the database
#pg_ctl -D $PREFIX/var/lib/postgresql start
#Similarly stop the database using
#pg_ctl stop
#!/data/data/com.termux/files/usr/bin/bash
