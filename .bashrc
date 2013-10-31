# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# Source the standard profile for non-login shells
[[ -r /etc/profile ]] && source /etc/profile 2>/dev/null

# import keybindings for history search
[[ -r ~/.inputrc ]] && bind -f ~/.inputrc

# enviroment variables
PATH="/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:$PATH"
HISTCONTROL=ignoreboth:erasedups
HISTSIZE=10000
HISTFILESIZE=20000
EDITOR=vim
PAGER=less
LESS='-Misc'
EXINIT='set number'
OSREL=`uname -s`

# export the variables to the os
export PATH HISTCONTROL HISTSIZE HISTFILESIZE
export EDITOR PAGER LESS EXINIT
export FTP_PASSIVE_MODE=true
case $OSREL in
  FreeBSD)
    export LANG='en_US.UTF-8'
    EDITOR=vi
    export CLICOLOR=1
    export LSCOLORS=ExFxBxDxCxegedabagacad
    ;;
  Linux)
    export LANG='en_US.utf8'
    EDITOR=vim
    export LS_COLORS='rs=0:di=01;34:ln=01;36:mh=00:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=40;31;01:su=37;41:sg=30;43:ca=30;41:tw=30;42:ow=34;42:st=37;44:ex=01;32:*.tar=01;31:*.tgz=01;31:*.arj=01;31:*.taz=01;31:*.lzh=01;31:*.lzma=01;31:*.tlz=01;31:*.txz=01;31:*.zip=01;31:*.z=01;31:*.Z=01;31:*.dz=01;31:*.gz=01;31:*.lz=01;31:*.xz=01;31:*.bz2=01;31:*.bz=01;31:*.tbz=01;31:*.tbz2=01;31:*.tz=01;31:*.deb=01;31:*.rpm=01;31:*.jar=01;31:*.war=01;31:*.ear=01;31:*.sar=01;31:*.rar=01;31:*.ace=01;31:*.zoo=01;31:*.cpio=01;31:*.7z=01;31:*.rz=01;31:*.jpg=01;35:*.jpeg=01;35:*.gif=01;35:*.bmp=01;35:*.pbm=01;35:*.pgm=01;35:*.ppm=01;35:*.tga=01;35:*.xbm=01;35:*.xpm=01;35:*.tif=01;35:*.tiff=01;35:*.png=01;35:*.svg=01;35:*.svgz=01;35:*.mng=01;35:*.pcx=01;35:*.mov=01;35:*.mpg=01;35:*.mpeg=01;35:*.m2v=01;35:*.mkv=01;35:*.webm=01;35:*.ogm=01;35:*.mp4=01;35:*.m4v=01;35:*.mp4v=01;35:*.vob=01;35:*.qt=01;35:*.nuv=01;35:*.wmv=01;35:*.asf=01;35:*.rm=01;35:*.rmvb=01;35:*.flc=01;35:*.avi=01;35:*.fli=01;35:*.flv=01;35:*.gl=01;35:*.dl=01;35:*.xcf=01;35:*.xwd=01;35:*.yuv=01;35:*.cgm=01;35:*.emf=01;35:*.axv=01;35:*.anx=01;35:*.ogv=01;35:*.ogx=01;35:*.aac=00;36:*.au=00;36:*.flac=00;36:*.mid=00;36:*.midi=00;36:*.mka=00;36:*.mp3=00;36:*.mpc=00;36:*.ogg=00;36:*.ra=00;36:*.wav=00;36:*.axa=00;36:*.oga=00;36:*.spx=00;36:*.xspf=00;36:'
    ;;
  *);;
esac

# file creation mask is 664
umask 002

# turn on interactive line editing
set -o emacs

# don't exit shell with ^D
set -o ignoreeof

# append to the history file, don't overwrite it
shopt -s histappend 2>/dev/null

# check the window size after each command
shopt -s checkwinsize 2>/dev/null

#check for background jobs before exiting a shell
shopt -s checkjobs 2>/dev/null

# make less more friendly for non-text input files, see lesspipe(1)
[[ -x /usr/bin/lesspipe ]] && eval "$(SHELL=/bin/sh lesspipe)"

function git_branch {
  [[ `git status 2>/dev/null` ]] && echo -n {`git status|head -n1|awk '{print $4}'`}

}

# Set the terminal title with `termname some title`
function tname { echo -en "\033]2;$*\007"; }

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
  eval $(/usr/bin/dircolors -b)
elif [ -r ~/.dircolors ]; then
  source ~/.dircolors
fi

# save and load the history on every prompt
# show last exit code, time, user, hostname, directory, git branch, prompt
# color prompt for xterm
case $TERM in
xterm*)
  PS1="$(history -a)$(history -n)[\[\033[0;33m\]\$?\[\033[m\]](\t)\[\033[01;34m\]\u@\h\[\033[m\]:\[\033[0;32m\]\w/\[\033[m\]\[\033[0;36m\]\$(git_branch)\[\033[m\]\\$>"
  tname $(hostname)
  ;;
*)
  PS1="$(history -a)$(history -n)[\$?](\t)\u@\h:\w\\$>"
  ;;
esac

#Color grep output
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

alias less='less -NMisc'
alias sudo='sudo '

# OS dependent aliases
case $OSREL in
  FreeBSD)
    alias ls='ls -aCFG'
    alias ll='ls -alhFG -D"%F %T"'
    alias pp='ps axo user,pid,pcpu,pmem,stat,ni,time,command'
    alias netstat='netstat -anf inet'
  ;;
  Linux)
    alias ls='ls -aCF --color=auto'
    alias ll='ls -alhF --color=auto --time-style=long-iso'
    alias pp='ps axo user,pid,pcpu,pmem,stat,ni,bsdtime,command'
    alias netstat='netstat -ant'
  ;;
  *)
    alias ls='ls -aCF'
    alias ll='ls -alhF'
    alias pp='ps aux'
    alias netstat='netstat -an'
  ;;
esac

# Alias definitions.
[[ -f ~/.bash_aliases ]] && . ~/.bash_aliases

# enable programmable completion features
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi
