# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac
#fix error on locale languaje vars
## US English ##
export LANG=en_US.UTF-8
export LANGUAGE=en_US.UTF-8
export LC_COLLATE=C
export LC_CTYPE=en_US.UTF-8

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto';
    #alias dir='dir --color=auto';
    #alias vdir='vdir --color=auto';

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# colored GCC warnings and errors
#export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
#alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

#node
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

#pycharm
#export NVM_DIR="$HOME/bin/pycharm-community/bin/";

#android
export PATH=$PATH:'~/bin/android-studio/bin';
export ANDROID_HOME='~/Android/Sdk/';
export PATH=${PATH}:$ANDROID_HOME/tools:$ANDROID_HOME/platform-tools:$ANDROID_HOME/tools/bin;

#java
export JAVA_HOME='/usr/java/latest';
export JDK_HOME="${JAVA_HOME}";

#maven
export PATH=$PATH:'~/bin/apache-maven-3.5.2/bin/';
export MAVEN_HOME='~/bin/apache-maven-3.5.2';

#gradle
export PATH=$PATH:'~/bin/gradle/gradle-4.4.1/bin';
export GRADLE_HOME='~/bin/gradle/gradle-4.4.1/';

# geeko and chrome drivers
export PATH=$PATH:'~/bin/browser_drivers/';
export PATH=$PATH:'~/bin/minikube/';
export PATH=$PATH:'~/bin/helm/';
export PATH=$PATH:'~/.nvm/versions/node/v8.9.4/bin/node';
#export PATH=$PATH:'~/bin/chrome-linux/';

# Fluter
export PATH=$PATH:'~/bin/flutter/bin/';

# SNAP
export PATH=$PATH:'/snap/bin/';

#docker
function cloud-dev {
  name=$(if [ $1 ];then echo $1;else echo "cloud-dev-a";fi;);
  port=$(if [ $2 ];then echo $2;else echo 8;fi;);
  tag=$(if  [ $3 ];then echo $3;else echo latest;fi;);
  #docker rm ${name} 1&2> /dev/null;
  docker run -it --rm \
    --name ${name} \
    -v $HOME/Projects:/home/developer/Projects \
    -v $HOME/run:/home/developer/run \
    -v $HOME/Documents:/home/developer/Documents/\
    -v $HOME/bin:/home/developer/bin \
    -v $HOME/.gitconfig:/home/developer/.gitconfig \
    -v $HOME/.ssh:/home/developer/.ssh \
    -v $HOME/.boto:/home/developer/.boto \
    -v $HOME/.config/gcloud:/home/developer/.config/gcloud \
    -v /tmp/.X11-unix:/tmp/.X11-unix \
    -p ${port}080:8080 \
    -p ${port}081:8081 \
    -p ${port}000:8000 \
    -p ${port}500:5000 \
    -p ${port}122:22 \
    -p ${port}180:80 \
    -p ${port}443:443 \
    -e DISPLAY=$DISPLAY \
    poxstone/cloud-dev:${tag} bash;
}

function mysqlStart {
  docker run --rm --name mysql -p 3306:3306 -v $HOME/Documents/mysqldb/:/var/lib/mysql -e MYSQL_DATABASE=cloudkey -e MYSQL_ROOT_PASSWORD=Ove52SWE -e MYSQL_USER=admin -e MYSQL_PASSWORD=Ove52SWE -d mysql:5.7;
}

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/home/poxstone/bin/google-cloud-sdk/path.bash.inc' ]; then source '/home/poxstone/bin/google-cloud-sdk/path.bash.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/home/poxstone/bin/google-cloud-sdk/completion.bash.inc' ]; then source '/home/poxstone/bin/google-cloud-sdk/completion.bash.inc'; fi
export PATH=$PATH:'~/bin/google-cloud-sdk/platform/google_appengine';


function jenkins-run {
  java -jar ~/bin/jenkins/jenkins.war --httpPort=9090;
  #docker run -u root --rm -d -p 8080:8080 -p 50000:50000 \
  #  -v $HOME/bin/jenkins-data:/var/jenkins_home \
  #  -v /var/run/docker.sock:/var/run/docker.sock \
  #  jenkinsci/blueocean    
}

#SAP
#export LD_LIBRARY_PATH="/home/poxstone/Projects/GCP-SCRIPTS/GRUPO-A-SAP/libs";
#export DYLD_LIBRARY_PATH="/home/poxstone/Projects/GCP-SCRIPTS/GRUPO-A-SAP/libs";
#export CLASSPATH="/home/poxstone/Projects/GCP-SCRIPTS/GRUPO-A-SAP/libs/sapjco3.jar";

# cerbot

alias cerbot="docker run --rm -it -p 443:443 -v $HOME/cerbot:/etc/letsencrypt -v $HOME/cerbot/log:/var/log/letsencrypt quay.io/letsencrypt/letsencrypt:latest";
#cerbot certonly --standalone -d example.com

