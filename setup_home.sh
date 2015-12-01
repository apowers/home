#!/bin/bash
# Set Home dev environment in Fedora
# For generic, non Xorg.

if [[ "$1" == "xorg" ]] ; then
    echo "Installing Xorg environment."
    XORG='True'
else
    echo "Installing shell environment. For X11 use: $0 xorg"
    XORG=''
fi

if [[ $(id -u) != 0 ]]; then
    echo "Must be root to install packages"
    exit 2
fi

if [[ -f '/etc/os-release' ]]; then
    source /etc/os-release
else
    ID=$(cat /etc/issue | head -1 | cut -f1 -d " ")
fi

PKGS=(
    bzip2
    dkms
    gcc
    git
    jq
    make
    mercurial
    nmap
    perl
    puppet
    python-devel
    rsync
    ruby-devel
    tmux
    traceroute
    tree
    vagrant
    wget
)

DEB_PKGS=(
    build-essential
    git-flow
    libxml2-dev
    libxslt-dev
    lxc-docker
    nc
    ruby-dev
    vim-athena
)

RHEL_PKGS=(
    docker
    gitflow
    kernel-devel
    kernel-headers
    nmap-ncat
    vim-enhanced
)

FEDORA_PKGS=(
    docker
    gitflow
    kernel-devel
    kernel-headers
    nmap-ncat
    vim-enhanced
    gcc-c++
)
# remmina
# remmina-plugins-rdp

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

# This is a note, not currently used to install packages
# https://packagecontrol.io/installation#st2
Sublime_Packages=(
    SublimeYammy
    Rspec
)

function main {
    case $ID in
      [uU]buntu|[dD]ebian)
        /usr/bin/apt-get -qq -y install wget;
        PUPPET_URL="http://apt.puppetlabs.com";
        PUPPET_REPO="puppetlabs-release-$(lsb_release -c -s).deb";
        debian_packages
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

    # Install dotfiles
    for F in .bashrc .profile .inputrc .vimrc .dircolors .tmux.conf .gitconfig ; do
      wget --no-check-certificate https://raw.github.com/apowers/home/master/$F -O ~/$F
    done

    source ~/.bashrc

    # Puppet development tools
    /usr/bin/gem install ${GEMS[@]} --no-rdoc --no-ri

    if [[ ! -z $XORG ]] ; then
        # Install sublime
        wget https://gist.githubusercontent.com/henriquemoody/3288681/raw/dc9276c8caa1dfcbebb73af960738eff2ca0a4d7/sublime-text-2.sh -O ~/Downloads/sublime-text-2-install.sh
        chmod +x ~/Downloads/sublime-text-2-install.sh
        ~/Downloads/sublime-text-2-install.sh

        # install configs for sublime
        cp sublime/* ~/.config/sublime-text-2/Packages/User/.
    fi

    docker_config

}

function debian_packages {
    DEBIAN_FRONTEND=noninteractive;
    RUNLEVEL=1
    APT_OPTS='-qq -y'
    echo force-confold >> /etc/dpkg/dpkg.cfg.d/force_confold;
    echo 'Dpkg::Options{"--force-confdef";"--force-confold";}' >> /etc/apt/apt.conf.d/local

    /usr/bin/wget -O /tmp/$PUPPET_REPO $PUPPET_URL/$PUPPET_REPO 2>&1 >/dev/null;
    /usr/bin/dpkg -i /tmp/$PUPPET_REPO  2>&1 >/dev/null;

    # Docker repository
    apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys
    echo deb https://get.docker.io/ubuntu docker main > /etc/apt/sources.list.d/docker.list

    /usr/bin/apt-get ${APT_OPTS} upgrade 2>&1 >/dev/null;
    /usr/bin/apt-get ${APT_OPTS} install ${PKGS[@]} 2>&1 >/dev/null;
    /usr/bin/apt-get ${APT_OPTS} install ${DEB_PKGS[@]} 2>&1 >/dev/null;

    unset RUNLEVEL
}

function rhel_packages {
    /usr/bin/wget -O /tmp/$PUPPET_REPO $PUPPET_URL/$PUPPET_REPO 2>&1 >/dev/null;
    rpm -i /tmp/$PUPPET_REPO  2>&1 >/dev/null;

    rhel_docker_repo

    yum upgrade -q -y 2>&1 >/dev/null;
    yum install -q -y ${PKGS[@]}  2>&1 >/dev/null;
    yum install -q -y ${RHEL_PKGS[@]}  2>&1 >/dev/null;

}

function fedora_packages {
    /usr/bin/wget -O /tmp/$PUPPET_REPO $PUPPET_URL/$PUPPET_REPO 2>&1 >/dev/null;
    rpm -i /tmp/$PUPPET_REPO

    if [[ ! -z $XORG ]] ; then
        # RPM Fusion for freetype
        RPMFUSION_URL='http://download1.rpmfusion.org/free/fedora'
        RPMFUSION_REPO'rpmfusion-free-release-22.noarch.rpm'
        /usr/bin/wget -O /tmp/$RPMFUSION_REPO $RPMFUSION_URL/$RPMFUSION_REPO 2>&1 /dev/null;
        rpm -i /tmp/$RPMFUSION_REPO  2>&1 >/dev/null;
        dnf install -q -y freetype-freeworld 2>&1 >/dev/null;
    fi

    rhel_docker_repo

    dnf upgrade -q -y 2>&1 >/dev/null;
    dnf install -q -y ${PKGS[@]}  2>&1 >/dev/null;
    dnf install -q -y ${FEDORA_PKGS[@]}  2>&1 >/dev/null;

}

function rhel_docker_repo {

# Docker Repository
cat > /etc/yum.repos.d/docker-main.repo << -EOF
[docker-main-repo]
name=Docker Main Repository
baseurl=https://yum.dockerproject.org/repo/main/${ID}/${VERSION_ID}
enabled=1
gpgcheck=1
gpgkey=https://yum.dockerproject.org/gpg
-EOF

}

function docker_config {
    # Limit docker to using 10.5GiB of storage, from the default of 102GiB. Note that a default docker instance has a 10GiB root.
    # TODO: don't use loopback devicemapper storage
    # http://www.projectatomic.io/blog/2015/06/notes-on-fedora-centos-and-docker-storage-drivers/
    sed -i 's/^DOCKER_STORAGE_OPTIONS.*/DOCKER_STORAGE_OPTIONS = --storage-opt dm.loopdatasize=10GB --storage-opt dm.loopmetadatasize=500MB/' /etc/sysconfig/docker-storage
}

main
