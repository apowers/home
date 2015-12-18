#!/bin/bash

echo WARN: This does not work yet.
exit 2


# This is a note, not currently used to install packages
# https://packagecontrol.io/installation#st2
Sublime_Packages=(
    SublimeYammy
    Rspec
)

# Install sublime
wget https://gist.githubusercontent.com/henriquemoody/3288681/raw/dc9276c8caa1dfcbebb73af960738eff2ca0a4d7/sublime-text-2.sh -O ~/Downloads/sublime-text-2-install.sh
chmod +x ~/Downloads/sublime-text-2-install.sh
~/Downloads/sublime-text-2-install.sh

# install configs for sublime
cp sublime/* ~/.config/sublime-text-2/Packages/User/.
