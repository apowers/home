#!/bin/bash
# Set dev system

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
    nmap
    perl
    rsync
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
    python-devel
    ruby-dev
    vim-athena
)

RHEL_PKGS=(
    docker
    gitflow
    kernel-devel
    kernel-headers
    nmap-ncat
    python-devel
    ruby-devel
    vim-enhanced
)

FEDORA_PKGS=(
    gcc-c++
)

ARCH_PKGS=(
    dmidecode
    docker
    mlocate
    python
    ruby
    dina-font
    vim
    openssh
)

# RDP app
# remmina
# remmina-plugins-rdp

GEMS=(
    rubocop
)

function main {
    # Install dotfiles
    for F in .bashrc .profile .inputrc .vimrc .dircolors .tmux.conf .gitconfig .rubocop.yml ; do
      wget --no-check-certificate https://raw.github.com/apowers/home/master/$F -O /etc/skel/$F
    done

    source ~/.bashrc

    case $ID in
      [Aa]rch)
        arch_packages
        ;;
      [uU]buntu|[dD]ebian)
        debian_packages
        ;;
      [cC]ent[oO][sS]|[rR]ed[hH]at)
        rhel_packages
        ;;
      [fF]edora)
        fedora_packages

        # subpixel rendinging from freetype-freeworld, may not be necessary
        #echo "Xft.lcdfilter: lcddefault" > ~/.Xresources
        ;;
      *)
        echo "Unsupported Operating System: $ID"
        exit 3
    esac

    # Ruby Gems
    /usr/bin/gem install ${GEMS[@]} --no-rdoc --no-ri

    eval chown -R ${SUDO_USER} ~${SUDO_USER}

}

function debian_packages {
    DEBIAN_FRONTEND=noninteractive;
    RUNLEVEL=1
    APT_OPTS='-qq -y'
    echo force-confold >> /etc/dpkg/dpkg.cfg.d/force_confold;
    echo 'Dpkg::Options{"--force-confdef";"--force-confold";}' >> /etc/apt/apt.conf.d/local

    # Docker repository
    apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys
    echo deb https://get.docker.io/ubuntu docker main > /etc/apt/sources.list.d/docker.list

    /usr/bin/apt-get ${APT_OPTS} upgrade 
    /usr/bin/apt-get ${APT_OPTS} install ${PKGS[@]}
    /usr/bin/apt-get ${APT_OPTS} install ${DEB_PKGS[@]}

    unset RUNLEVEL
}

function rhel_packages {

    rhel_docker_repo

    yum upgrade -q -y 2>&1 >/dev/null;
    yum install -q -y ${PKGS[@]}  2>&1 >/dev/null;
    yum install -q -y ${RHEL_PKGS[@]}  2>&1 >/dev/null;

    docker_config

}

function fedora_packages {

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
    dnf install -q -y ${RHEL_PKGS[@]}  2>&1 >/dev/null;
    dnf install -q -y ${FEDORA_PKGS[@]}  2>&1 >/dev/null;

    docker_config

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

# This function does a bit more than just install packages because Arch is Arch.
# See ArchSetup.md for more information.
function arch_packages {
    /usr/bin/pacman -S --noconfirm ${PKGS[@]}  2>&1 >/dev/null;
    /usr/bin/pacman -S --noconfirm ${ARCH_PKGS[@]}  2>&1 >/dev/null;
    eval wget --no-check-certificate https://raw.github.com/apowers/home/master/.xinitrc -O ~${SUDO_USER}/.xinitrc

    /bin/updatedb
    echo '%wheel ALL=(ALL) NOPASSWD: ALL' > /etc/sudoers.d/wheel

    # AUR package manager
    cd /tmp
    wget -k https://aur.archlinux.org/cgit/aur.git/snapshot/apacman.tar.gz
    tar  -xf /tmp/apacman.tar.gz
    cd /tmp/apacman
    chown nobody .
    sudo -u nobody makepkg -rsi --noconfirm

    # Language
    echo en_US.UTF-8 UTF-8 > /etc/locale.gen
    locale-gen

    cp /etc/fonts/conf.avail/10-sub-pixel-rgb.conf /etc/fonts/conf.avail/11-sub-pixel-rgb.conf
    sed -i 's/append/assign/' /etc/fonts/conf.avail/11-sub-pixel-rgb.conf

    # Virtualbox Drivers
    case $(dmidecode -s system-product-name) in
        VirtualBox)
            pacman -S --noconfirm linux-headers virtualbox-guest-utils virtualbox-guest-dkms
            systemctl enable dkms.service
            dkms autoinstall
        ;;
        *) ;;
    esac
}

main
