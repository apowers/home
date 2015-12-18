#!/bin/bash

add-apt-repository -y ppa:webupd8team/sublime-text-3
apt-get install sublime-text

# install configs for sublime
cp sublime/* ~/.config/sublime-text-2/Packages/User/.
