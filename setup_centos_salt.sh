#!/bin/bash
# Set OS variable in CentOS, others?
source /etc/os-release

# packages
PKGS='git gitflow mercurial wget nmap vim-enhanced tree tmux docker salt-minion salt-master'
XPKGS='geany geany-themes'

# Install dotfiles
for F in .bashrc .profile .inputrc .vimrc .dircolors .tmux.conf ; do
  wget --no-check-certificate https://raw.github.com/apowers/home/master/$F -O ~/$F
done

# install silently

# update and install packages
sudo /bin/yum install -y epel-release
sudo /bin/yum update  -y
sudo /bin/yum install -y install $PKGS

# Install graphical apps if xorg is installed
if /bin/yum list installed xorg-x11-server* ; then
  sudo /bin/yum install -y $XPKGS
fi

