#!/bin/bash

if [[ $(id -u) != 0 ]]; then
    echo "Must be root to install packages"
    exit 2
fi

if [[ -f '/etc/os-release' ]]; then
    source /etc/os-release
else
    ID=$(cat /etc/issue | head -1 | cut -f1 -d " ")
fi

# https://www.sublimetext.com/docs/3/linux_repositories.html
case $ID in
  [Uu]buntu)
    wget -qO - https://download.sublimetext.com/sublimehq-pub.gpg | sudo apt-key add -
    sudo apt install apt-transport-https
    echo "deb https://download.sublimetext.com/ apt/stable/" >> /etc/apt/sources.list.d/sublime-text.list
    # add-apt-repository -y ppa:webupd8team/sublime-text-3
    apt update
    apt install sublime-text

    ;;
  [Aa]rch)
#    echo Incomplete Setup on $ID for Sublime-text-2
#    wget -k https://aur.archlinux.org/cgit/aur.git/snapshot/sublime-text.tar.gz -O /tmp/sublime-text.tar.gz
    apacman -S --noconfirm sublime-text-nightly
#    wget -k https://aur.archlinux.org/cgit/aur.git/snapshot/sublime-text-nightly.tar.gz -O /tmp/sublime-text-nightly.tar.gz
#    tar -C /tmp -xf /tmp/sublime-text-nightly.tar.gz
#    cd /tmp/sublime-text-nightly
#    makepkg -sri --noconfirm
    ;;
  *)
    echo "Sublime Setup Not Supported on $ID"
    ;;
esac

# install configs for sublime
#eval cp sublime/* ~${SUDO_USER}/.config/sublime-text-3/Packages/User/.
