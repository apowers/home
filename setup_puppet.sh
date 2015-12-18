#!/bin/bash
# Set Home dev environment in Fedora
# For generic, non Xorg.

if [[ $(id -u) != 0 ]]; then
    echo "Must be root to install packages"
    exit 2
fi

if [[ -f '/etc/os-release' ]]; then
    source /etc/os-release
else
    ID=$(cat /etc/issue | head -1 | cut -f1 -d " ")
fi

GEMS=(
    beaker
    beaker-rspec
    bundler
    puppet-lint
    puppet-syntax
    puppet_facts
    rspec-puppet
    puppetlabs_spec_helper
)

function main {
    case $ID in
      [uU]buntu|[dD]ebian)
        /usr/bin/apt-get -qq -y install wget;
        PUPPET_URL="http://apt.puppetlabs.com";
        PUPPET_REPO="puppetlabs-release-$(lsb_release -c -s).deb";

      ;;
      [cC]ent[oO][sS]|[rR]ed[hH]at)
        yum install -y -q wget
        [[ -z "$VERSION_ID" ]] && VERSION_ID=6
        PUPPET_URL="http://yum.puppetlabs.com";
        PUPPET_REPO="puppetlabs-release-el-${VERSION_ID}.noarch.rpm";
        rhel_packages
      ;;
      [fF]edora)
        yum install -y -q wget

        PUPPET_URL="http://yum.puppetlabs.com";
        PUPPET_REPO="puppetlabs-release-fedora-${VERSION_ID}.noarch.rpm";
        fedora_packages

        # subpixel rendinging from freetype-freeworld, may not be necessary
        #echo "Xft.lcdfilter: lcddefault" > ~/.Xresources
      ;;
      *)
        echo "Unsupported Operating System $ID"
        exit 3
    esac

    # Puppet development tools
    /usr/bin/gem install ${GEMS[@]} --no-rdoc --no-ri

}

function debian_packages {
    DEBIAN_FRONTEND=noninteractive;
    RUNLEVEL=1
    APT_OPTS='-qq -y'
    echo force-confold >> /etc/dpkg/dpkg.cfg.d/force_confold;
    echo 'Dpkg::Options{"--force-confdef";"--force-confold";}' >> /etc/apt/apt.conf.d/local

    /usr/bin/wget -O /tmp/$PUPPET_REPO $PUPPET_URL/$PUPPET_REPO 2>&1 >/dev/null;
    /usr/bin/dpkg -i /tmp/$PUPPET_REPO  2>&1 >/dev/null;

    /usr/bin/apt-get ${APT_OPTS} install puppet 2>&1 >/dev/null;

    unset RUNLEVEL
}

function rhel_packages {
    /usr/bin/wget -O /tmp/$PUPPET_REPO $PUPPET_URL/$PUPPET_REPO 2>&1 >/dev/null;
    rpm -i /tmp/$PUPPET_REPO  2>&1 >/dev/null;

    yum install -q -y puppet  2>&1 >/dev/null;

}

function fedora_packages {
    /usr/bin/wget -O /tmp/$PUPPET_REPO $PUPPET_URL/$PUPPET_REPO 2>&1 >/dev/null;
    rpm -i /tmp/$PUPPET_REPO

    dnf install -q -y puppet  2>&1 >/dev/null;

}

main
