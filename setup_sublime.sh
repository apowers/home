#!/bin/bash
[[ -r /etc/os-release ]] && source /etc/os-release

case $ID in
  [Uu]buntu)
    add-apt-repository -y ppa:webupd8team/sublime-text-3
    apt-get install sublime-text

    # install configs for sublime
    cp sublime/* ~/.config/sublime-text-3/Packages/User/.
    ;;
  [Aa]rch)
#    echo Incomplete Setup on $ID for Sublime-text-2
#    wget -k https://aur.archlinux.org/cgit/aur.git/snapshot/sublime-text.tar.gz -O /tmp/sublime-text.tar.gz
    wget -k https://aur.archlinux.org/cgit/aur.git/snapshot/sublime-text-nightly.tar.gz -O /tmp/sublime-text-nightly.tar.gz
    tar -C /tmp -xf /tmp/sublime-text-nightly.tar.gz
    cd /tmp/sublime-text-nightly
    mkepkg -sri --noconfirm
    ;;
  *)
    echo Not Supported on $ID
    ;;
esac
