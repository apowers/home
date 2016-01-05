# Install stand alone Chef and some useful development tools

# https://packagecloud.io/chef/

# Chef
# https://downloads.chef.io/
# https://docs.chef.io/install_server.html

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
)

function main {
    case $ID in
    [uU]buntu|[dD]ebian)
        INSTALL_CMD='/usr/bin/apt-get -qq -y install'
        REPO_SCRIPT='script.deb.sh'
        install_chef
        ;;
    [cC]ent[oO][sS]|[rR]ed[hH]at)
        INSTALL_CMD='/usr/bin/yum -q -y install'
        REPO_SCRIPT='script.rpm.sh'
        install_chef
        ;;
     [fF]edora)
        INSTALL_CMD='/bin/dnf -q -y install'
        REPO_SCRIPT='script.rpm.sh'
        install_chef
        ;;
    [Aa]rch)
        gem source --add https://packagecloud.io/chef/stable/
        gem install --no-rdoc --no-ri chef
        wget https://aur.archlinux.org/cgit/aur.git/snapshot/chef-dk.tar.gz -O /tmp/chef-dk.tar.gz
        tar -C /tmp -xf /tmp/chef-dk.tar.gz
        cd /tmp/chef-dk
        makepkg -sri --noconfirm
        exit
        ;;
    *)
        echo "No Repository for $ID."
        echo "Installing chef from gem source."
        echo "Chef DevKit will not be installed."

        gem source --add https://packagecloud.io/chef/stable/
        gem install --no-rdoc --no-ri chef
        exit
        ;;
    esac
}

function install_chef {
    # Install Chef repo
    # https://packagecloud.io/chef/stable/install
    ${INSTALL_CMD} wget
    wget -O /tmp/chef_repo.sh https://packagecloud.io/install/repositories/chef/stable/${REPO_SCRIPT}
    chmod +x /tmp/chef_repo.sh
    /tmp/chef_repo.sh
    gem source --add https://packagecloud.io/chef/stable/

    # Install Chef
    ${INSTALL_CMD} chef chefdk

    # Chef development tools
    #/usr/bin/gem install ${GEMS[@]} --no-rdoc --no-ri
}

main


