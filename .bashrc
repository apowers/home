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
[[ -r /etc/os-release ]] && source /etc/os-release
# Home local bin comes before system default; and ensure we include standard bin directories
PATH="$HOME/bin:$HOME/.local/bin:$PATH:/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin"
PATH="${PATH}:/opt/chef-workstation/bin:/opt/chef-workstation/embedded/bin"
HISTCONTROL=ignoreboth:erasedups
HISTSIZE=10000
HISTFILESIZE=20000
EDITOR=vim
PAGER=less
LESS='-McRis'
EXINIT='set number'
OSREL=`uname -s`

# export the variables to the os
export PATH HISTCONTROL HISTSIZE HISTFILESIZE
export EDITOR PAGER LESS EXINIT
export FTP_PASSIVE_MODE=true
export TZ='America/Los_Angeles'

export DOCKER_HOST='localhost:2375'

case $OSREL in
  FreeBSD)
    export LANG='en_US.UTF-8'
    export EDITOR=vi
    export CLICOLOR=1
    export LSCOLORS=ExFxBxDxCxegedabagacad
    ;;
  Linux)
    if [ "$ID" == "arch" ];then
      export LANG='en_US.UTF-8'
    else
      export LANG='en_US.utf8'
    fi
    [[ -x /usr/bin/dircolors ]] && /usr/bin/dircolors >/dev/null
    [[ -x ~/.dircolors ]] && ~/.dircolors >/dev/null
    [[ -d /usr/src/kernels/$(uname -r) ]] && export KERN_DIR=/usr/src/kernels/$(uname -r)
    ;;
  *);;
esac

# file creation mask is 664
umask 002

# Disable terminal flow control, may cause tumx to "freeze" with CTRL-s
stty -ixon

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

function branch {
  [[ `git status 2>/dev/null` ]] && echo -n "{$(git rev-parse --abbrev-ref HEAD)}"
  [[ `hg branch 2>/dev/null` ]] && echo -n "{$(hg branch)}"
}

# Set the terminal title with `title name`
function title { printf "\033k$1\033\\"; }
title $(hostname -s)

function user_prompt {
# root username is red
  if [[ $(id -u) == 0 ]] ; then
    echo -n "\[\033[0;31m\]\u\[\033[m\]@\[\033[0;32m\]\h\[\033[m\]"
  else
    echo -n "\[\033[1;34m\]\u\[\033[m\]@\[\033[0;32m\]\h\[\033[m\]"
   fi
}
# show last exit code, time, user, hostname, directory, git branch, prompt
# color prompt for xterm (or check `tput colors`)
# Note: in some terminals if the '@' symbol is in a light color it looks like the copywright symbol.
case $TERM in
xterm*|screen*)
# save the history on every prompt
  export PROMPT_COMMAND="history -a;history -w;history -n"
  export PS1="\[\033[0;33m\][\$?]\[\033[m\](\t)$(user_prompt):\w/\[\033[0;90m\]\$(branch)\[\033[m\]\\n\$>$"
  ;;
*)
  PS1="[\$?](\t)\u@\h:\w\\n\$>"
  ;;
esac
export PS2=">> "

# Simple backup command
function bk () {
  cp $1 $1.$(id -nu)_$(date +%F)
}

#Color grep output
alias grep='grep --color=auto'
alias less='less -NMiscR'
alias sudo='sudo '
# Terraform
alias tf='terraform'
# AWS CLI
alias asm='aws ssm start-session --target '

# OS dependent aliases
case $OSREL in
  FreeBSD)
    alias ls='ls -ACFG'
    alias ll='ls -AlhFG -D"%F %T"'
    alias pp='ps axo user,pid,pcpu,pmem,stat,ni,time,command'
    alias netstat='netstat -anf inet'
  ;;
  Linux)
    alias ls='ls -ACF --color=auto'
    alias ll='ls -AlhF --color=auto --time-style=long-iso'
    alias pp='ps axo user,pid,pcpu,pmem,stat,ni,bsdtime,command'
    alias netstat='netstat -ant'
  ;;
  *)
    alias ls='ls -ACF'
    alias ll='ls -AlhF'
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

# #Load SSH Agent - use `ssh-add` to install keys.
# if [ ! $SSH_AGENT_PID ] ; then
#   if which ssh-agent ; then
#     ssh-agent
#     ssh-add ~/.ssh/*.key
#     ssh-add ~/.ssh/*.pem
#   fi
# fi

# Load additional user bash configurations
if test -d ~/.profile.d/; then
  for profile in ~/.profile.d/*; do
    test -x $profile && . $profile
  done
  unset profile
fi

# WSL sometimes drops me into the wrong directory
cd ~
