#!/bin/bash

# Install dotfiles
for F in .bashrc .profile .inputrc .vimrc .dircolors .tmux.conf .gitconfig .rubocop.yml ; do
  eval wget --no-check-certificate https://raw.github.com/apowers/home/master/$F -O ~${SUDO_USER}/$F
done

source ~/.bashrc
