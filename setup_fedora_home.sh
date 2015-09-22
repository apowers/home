#!/bin/bash
# Set Home dev environment in Fedora
source /etc/os-release

# packages
CORE_PKGS='gcc kernel-devel kernel-headers dkms make bzip2 perl ruby-devel python-devel'
PKGS='git gitflow mercurial wget nmap vim-enhanced tree tmux docker'

# Install dotfiles
for F in .bashrc .profile .inputrc .vimrc .dircolors .tmux.conf .gitconfig ; do
  wget --no-check-certificate https://raw.github.com/apowers/home/master/$F -O ~/$F
done

source ~/.bashrc

#wget --no-check-certificate https://raw.github.com/apowers/home/master/git-completion.bash -O ~/

# update and install packages
#sudo /bin/yum install -qy epel-release # Not necessary in Fedora
sudo /bin/dnf upgrade -y
sudo /bin/dnf install -y $CORE_PKGS
sudo /bin/dnf install -y $PKGS

# install sublime
wget https://gist.githubusercontent.com/henriquemoody/3288681/raw/dc9276c8caa1dfcbebb73af960738eff2ca0a4d7/sublime-text-2.sh -O ~/Downloads/sublime-text-2-install.sh
sh -c ~/Downloads/sublime-text-2-install.sh

# install configs for sublime

# configure console font

