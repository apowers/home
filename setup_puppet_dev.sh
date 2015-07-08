#!/bin/bash
# Install tools needed for developing and testing puppet modules.

# apowers, 2014.09.02 - initial write
# apowers, 2015.06.22 - disable vagrant install (old version), install build-essentials required by some gems

PKGS='build-essential zlib1g-dev ldap-utils ruby-dev libxslt-dev libxml2-dev lxc-docker'
GEMS='bundler puppet_facts puppet-lint puppet-syntax rspec-puppet beaker beaker-rspec'

# Keyserver and repo for docker
apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys
echo deb https://get.docker.io/ubuntu docker main > /etc/apt/sources.list.d/docker.list

echo force-confold >> /etc/dpkg/dpkg.cfg.d/force_confold;
DEBIAN_FRONTEND=noninteractive;
RUNLEVEL=1

# update and install packages
/usr/bin/apt-get update;
/usr/bin/apt-get -qq -y install $PKGS
unset RUNLEVEL

/usr/bin/gem install $GEMS --no-rdoc --no-ri

# Download and install vagrant
#vagrant_pkg='vagrant_1.6.3_x86_64.deb'
#/usr/bin/wget -O /tmp/${vagrant_pkg} https://dl.bintray.com/mitchellh/vagrant/${vagrant_pkg}
#/usr/bin/dpkg -i /tmp/${vagrant_pkg}

