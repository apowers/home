#!/bin/bash

# packages
PKGS='git git-flow wget nmap vim vim-athena vagrant tree tmux jq traceroute build-essential lxc-docker'
XPKGS='synergy geany geany-plugins pidgin pidgin-sipe conky'

# Install dotfiles
for F in .bashrc .profile .inputrc .vimrc .dircolors .tmux.conf ; do
  wget --no-check-certificate https://raw.github.com/apowers/home/master/$F -O ~/$F
done

# Setup puppet repo
PUPPET_URL="http://apt.puppetlabs.com/";
DISTRIB_CODENAME=`awk -F= '/^DISTRIB_CODENAME/ { print $2 }' /etc/lsb-release`;
PUPPET_REPO="puppetlabs-release-$DISTRIB_CODENAME.deb";
/usr/bin/wget -O /tmp/$PUPPET_REPO $PUPPET_URL/$PUPPET_REPO 2>&1 >/dev/null;
/usr/bin/dpkg -i /tmp/$PUPPET_REPO;

# install silently
echo force-confold >> /etc/dpkg/dpkg.cfg.d/force_confold;
DEBIAN_FRONTEND=noninteractive;
RUNLEVEL=1

# update and install packages
/usr/bin/apt-get update;
/usr/bin/apt-get -qq -y install $PKGS
unset RUNLEVEL

# Install Puppet
if [[ "$1" == "puppet" ]] ; then
  /usr/bin/apt-get -qq -y install puppet
  GEMS='rake hiera-eyaml puppet-lint puppetlabs_spec_helper'
  /usr/bin/gem install $GEMS --no-rdoc --no-ri
fi

# Install graphical apps if xorg is installed
if /usr/bin/dpkg -l xorg >/dev/null ; then
  /usr/bin/apt-get -qq -y install $XPKGS
fi

