#!/bin/bash
# Set Home dev environment in Fedora

if [[ $(id -u) != 0 ]]; then
    echo "Must be root to install packages"
    exit 2
fi

if [[ -f '/etc/os-release' ]]; then
    source /etc/os-release
else
    ID=$(cat /etc/issue | head -1 | cut -f1 -d " ")
fi

PKGS='
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
'

GEMS='bundler puppet_facts puppet-lint puppet-syntax rspec-puppet beaker beaker-rspec'

function main {
    case $ID in
      [uU]buntu|[dD]ebian)
        /usr/bin/apt-get -qq -y install wget;
        PUPPET_URL="http://apt.puppetlabs.com";
        PUPPET_REPO="puppetlabs-release-$(lsb_release -c -s).deb";
        DIST_PKGS='
            git-flow
            vim-athena
            build-essential
            lxc-docker
        '
        # zlib1g-dev ldap-utils ruby-dev libxslt-dev libxml2-dev
        debian_packages
      ;;
      [cC]ent[oO][sS]|[rR]ed[hH]at)
        yum install -y -q wget
        [[ -z "$VERSION_ID" ]] && VERSION_ID=6
        PUPPET_URL="http://yum.puppetlabs.com";
        PUPPET_REPO="puppetlabs-release-el-${VERSION_ID}.noarch.rpm";
        DIST_PKGS='
            gitflow
            kernel-devel
            kernel-headers
            vim-enhanced
            docker
        '
        fedora_packages
      ;;
      [fF]edora)
        yum install -y -q wget

        # Install rpmfusion repository
        wget http://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-22.noarch.rpm -O /tmp/rpmfusion-free-release-22.noarch.rpm
        rpm -i /tmp/rpmfusion-free-release-22.noarch.rpm

        PUPPET_URL="http://yum.puppetlabs.com";
        PUPPET_REPO="puppetlabs-release-fedora-${VERSION_ID}.noarch.rpm";
        DIST_PKGS='
            gitflow
            kernel-devel
            kernel-headers
            vim-enhanced
            docker
            freetype-freeworld
        '
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
    /usr/bin/gem install $GEMS --no-rdoc --no-ri

    # Install sublime
    wget https://gist.githubusercontent.com/henriquemoody/3288681/raw/dc9276c8caa1dfcbebb73af960738eff2ca0a4d7/sublime-text-2.sh -O ~/Downloads/sublime-text-2-install.sh
    chmod +x ~/Downloads/sublime-text-2-install.sh
    ~/Downloads/sublime-text-2-install.sh

    # install configs for sublime
    cp sublime/* ~/.config/sublime-text-2/Packages/User/.

}

function debian_packages {
        DEBIAN_FRONTEND=noninteractive;
        RUNLEVEL=1
        APT_OPTS='-qq -y'
        echo force-confold >> /etc/dpkg/dpkg.cfg.d/force_confold;
        echo 'Dpkg::Options{"--force-confdef";"--force-confold";}' >> /etc/apt/apt.conf.d/local

        /usr/bin/wget -O /tmp/$PUPPET_REPO $PUPPET_URL/$PUPPET_REPO 2>&1 >/dev/null;
        /usr/bin/dpkg -i /tmp/$PUPPET_REPO;

        # Docker repository
        apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys
        echo deb https://get.docker.io/ubuntu docker main > /etc/apt/sources.list.d/docker.list

        /usr/bin/apt-get ${APT_OPTS} upgrade 2>&1 >/dev/null;
        /usr/bin/apt-get ${APT_OPTS} install $PKGS 2>&1 >/dev/null;
        /usr/bin/apt-get ${APT_OPTS} install $DIST_PKGS 2>&1 >/dev/null;

        unset RUNLEVEL
}

function fedora_packages {
        /usr/bin/wget -O /tmp/$PUPPET_REPO $PUPPET_URL/$PUPPET_REPO 2>&1 >/dev/null;
        rpm -i /tmp/$PUPPET_REPO

        # Docker Repository
        cat > /etc/yum.repos.d/docker-main.repo << -EOF
        [docker-main-repo]
        name=Docker Main Repository
        baseurl=https://yum.dockerproject.org/repo/main/${ID}/${VERSION_ID}
        enabled=1
        gpgcheck=1
        gpgkey=https://yum.dockerproject.org/gpg
        EOF

        yum upgrade -q -y upgrade 2>&1 >/dev/null;
        yum install -q -y $PKGS  2>&1 >/dev/null;
        yum install -q -y $DIST_PKGS  2>&1 >/dev/null;

}


main
