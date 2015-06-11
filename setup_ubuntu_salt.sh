#!/bin/bash

# packages
PKGS='git git-flow mercurial wget nmap vim vim-athena tree tmux ruby-dev python vagrant docker salt-minion salt-master'
XPKGS='synergy geany geany-plugins pidgin pidgin-sipe conky'

# Install dotfiles
for F in .bashrc .profile .inputrc .vimrc .dircolors .tmux.conf ; do
  wget --no-check-certificate https://raw.github.com/apowers/home/master/$F -O ~/$F
done

# install silently

# install silently
echo force-confold >> /etc/dpkg/dpkg.cfg.d/force_confold;
DEBIAN_FRONTEND=noninteractive;
RUNLEVEL=1

# update and install packages
/usr/bin/apt-get update;
/usr/bin/apt-get -qq -y install $PKGS
unset RUNLEVEL

# Install graphical apps if xorg is installed
if /usr/bin/dpkg -l xorg >/dev/null ; then
  /usr/bin/apt-get -qq -y install $XPKGS
fi

