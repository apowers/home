#!/bin/bash
# Set dev system
# Docker is installed in setup_docker.sh because it keeps changing.

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
    nc
    python-devel
    python3
    python3-dev
    python3-pip
    ruby-dev
    vim-athena
    unattended-upgrades
    ldap-utils
    awscli
)

RHEL_PKGS=(
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
    mlocate
    python
    ruby
    dina-font
    vim
    openssh
    bind-tools
    net-tools
    ntp
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

}

function debian_packages {
    DEBIAN_FRONTEND=noninteractive;
    RUNLEVEL=1
    APT_OPTS='-qq -y'
    echo force-confold >> /etc/dpkg/dpkg.cfg.d/force_confold;
    echo 'Dpkg::Options{"--force-confdef";"--force-confold";}' >> /etc/apt/apt.conf.d/local

    /usr/bin/apt ${APT_OPTS} upgrade
    /usr/bin/apt ${APT_OPTS} install ${PKGS[@]}
    /usr/bin/apt ${APT_OPTS} install ${DEB_PKGS[@]}

    unset RUNLEVEL

    pip3 install pylint
    pip3 install autopep8

    #Configure unattended-upgrades
    APT_CFG_FILE="/etc/apt/apt.conf.d/20apt-periodic-upgrades"
    echo 'APT::Periodic::Enable "1";' > ${APT_CFG_FILE}
    echo 'APT::Periodic::Update-Package-Lists "1";' >> ${APT_CFG_FILE}
    echo 'APT::Periodic::Unattended-Upgrade "1";' >> ${APT_CFG_FILE}
    echo 'APT::Periodic::AutocleanInterval "21";' >> ${APT_CFG_FILE}
}

function rhel_packages {
    yum upgrade -q -y 2>&1 >/dev/null;
    yum install -q -y ${PKGS[@]}  2>&1 >/dev/null;
    yum install -q -y ${RHEL_PKGS[@]}  2>&1 >/dev/null;
}

function fedora_packages {
    if [[ ! -z $XORG ]] ; then
        # RPM Fusion for freetype
        RPMFUSION_URL='http://download1.rpmfusion.org/free/fedora'
        RPMFUSION_REPO='rpmfusion-free-release-22.noarch.rpm'
        /usr/bin/wget -O /tmp/$RPMFUSION_REPO $RPMFUSION_URL/$RPMFUSION_REPO 2>&1 /dev/null;
        rpm -i /tmp/$RPMFUSION_REPO  2>&1 >/dev/null;
        dnf install -q -y freetype-freeworld 2>&1 >/dev/null;
    fi

    dnf upgrade -q -y 2>&1 >/dev/null;
    dnf install -q -y ${PKGS[@]}  2>&1 >/dev/null;
    dnf install -q -y ${RHEL_PKGS[@]}  2>&1 >/dev/null;
    dnf install -q -y ${FEDORA_PKGS[@]}  2>&1 >/dev/null;
}

# This function does a bit more than just install packages because Arch is Arch.
# See ArchSetup.md for more information.
function arch_packages {
    /usr/bin/pacman -S --noconfirm ${PKGS[@]}  2>&1 >/dev/null;
    /usr/bin/pacman -S --noconfirm ${ARCH_PKGS[@]}  2>&1 >/dev/null;

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
