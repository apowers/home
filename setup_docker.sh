#!/bin/bash
# Setup or upgrade docker
# This is similar to setup_system.sh and specific to Docker

# TODO - Currently only Ubuntu is updated to new docker (2018-01-08)

if [[ $(id -u) != 0 ]]; then
    echo "Must be root to install packages"
    exit 2
fi

if [[ -f '/etc/os-release' ]]; then
    source /etc/os-release
else
    ID=$(cat /etc/issue | head -1 | cut -f1 -d " ")
fi

function main {
  case $ID in
    [Aa]rch)
      DOCKER_PKG="docker"
      arch_packages
      ;;
    [uU]buntu|[dD]ebian)
      DOCKER_PKG="docker-ce"
      debian_packages
      ;;
    [cC]ent[oO][sS]|[rR]ed[hH]at)
      DOCKER_PKG="docker"
      rhel_packages
      ;;
    [fF]edora)
      DOCKER_PKG="docker"
      fedora_packages
      ;;
    *)
      echo "Unsupported Operating System: $ID"
      exit 3
  esac
}

function debian_packages {
  DEBIAN_FRONTEND=noninteractive;
  RUNLEVEL=1
  APT_OPTS='-qq -y'
  echo force-confold >> /etc/dpkg/dpkg.cfg.d/force_confold;
  echo 'Dpkg::Options{"--force-confdef";"--force-confold";}' >> /etc/apt/apt.conf.d/local

  # Prep apt with tools to access HTTP repository
  /usr/bin/apt ${APT_OPTS} install apt-transport-https ca-certificates curl software-properties-common

  # Docker repository
  curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -
  add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu ${VERSION_CODENAME} stable"
  /usr/bin/apt ${APT_OPTS} update

  # Remove old docker
  /usr/bin/apt ${APT_OPTS} remove docker docker-engine docker.io aufs-tools cgroupfs-mount

  # Install new docker
  /usr/bin/apt ${APT_OPTS} install ${DOCKER_PKG}

  unset RUNLEVEL
}

# TODO - fix this for new docker
function rhel_packages {

  rhel_docker_repo

  yum upgrade -q -y 2>&1 >/dev/null;
  yum install -q -y ${PKGS[@]}  2>&1 >/dev/null;
  yum install -q -y ${RHEL_PKGS[@]}  2>&1 >/dev/null;

  docker_config

}

# TODO - fix this for new docker
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

# TODO - fix this for new docker
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

# TODO - fix this for new docker
function arch_packages {
    /usr/bin/pacman -S --noconfirm ${PKGS[@]}  2>&1 >/dev/null;
    /usr/bin/pacman -S --noconfirm ${ARCH_PKGS[@]}  2>&1 >/dev/null;
}

main
