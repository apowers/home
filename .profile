# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

OSREL=`uname -s`

#save and load the history on every prompt
# show last exit code, time, user, hostname, directory, prompt
# color prompt for xterm
if [[ "$TERM" == 'xterm' ]] ; then 
PS1="$(history -a)$(history -n)[\[\033[0;33m\]$?\[\033[m\]](\t)\[\033[0;36m\]\u@\h\[\033[m\]:\[\033[0;32m\]\w/\[\033[m\]\$>"
else 
PS1="$(history -a)$(history -n)[$?](\t)\u@\h:\w\$>"
fi

# don't put duplicate lines or lines starting with space in the history.
export HISTCONTROL=ignoreboth:erasedups

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
export HISTSIZE=10000
export HISTFILESIZE=20000

# append to the history file, don't overwrite it
shopt -s histappend 2>/dev/null

# check the window size after each command 
shopt -s checkwinsize 2>/dev/null

#check for background jobs before exiting a shell
shopt -s checkjobs 2>/dev/null

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"


# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    alias dir='dir --color=auto'
    alias vdir='vdir --color=auto'
    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# some ls aliases
if [[ "$OSREL" == "FreeBSD" ]]; then
  alias ls='ls -aCF -D"%F %T"'
else
  alias ls='ls -aCF --time-style=long-iso'
fi
alias ll='ls -alhF'

# ps aliases
alias ps='ps aux'

# Alias definitions.
if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi
 
# import keybindings for history search
if [[ -r ~/.inputrc ]] ; then bind -f ~/.inputrc ; fi

