#!/bin/bash

GROUPS=(
    docker
    sudo
    wheel
    root
)

# Install dotfiles
for F in .bashrc .profile .inputrc .vimrc .dircolors .tmux.conf .gitconfig .rubocop.yml ; do
  eval wget --no-check-certificate https://raw.github.com/apowers/home/master/$F -O ~${HOME}/$F
done

eval chown -R ${SUDO_USER} ~${SUDO_USER}

for group in ${GROUPS} ; do
    usermod -aG ${group} ${SUDO_USER}
done

echo "On ArchLinux, setup xinitrc"
echo "wget --no-check-certificate https://raw.github.com/apowers/home/master/.xinitrc -O ~${HOME}/.xinitrc"

source ~/.bashrc
