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
        ;;
    [cC]ent[oO][sS]|[rR]ed[hH]at)
        INSTALL_CMD='/usr/bin/yum -q -y install'
        REPO_SCRIPT='script.rpm.sh'
        ;;
     [fF]edora)
        INSTALL_CMD='/bin/dnf -q -y install'
        REPO_SCRIPT='script.rpm.sh'
        ;;
    *)
        echo "Unsupported Operating System: $ID"
        exit 3
        ;;
    esac

    # Install Chef repo
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


