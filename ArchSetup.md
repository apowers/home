Arch Linux Setup Notes

* Virtual Box development workstation
* Single file system
* xfce4 graphical environment

* https://wiki.archlinux.org/index.php/Installation_guide
* https://wiki.archlinux.org/index.php/Beginners%27_guide

# In VirtualBox: System -> Motherboard -> Enable EFI
# From ISO: Boot Arch x86_64

    loadkeys dvorak
    parted /dev/sda
    mklabel gpt
    mkpart ESP fat32 1MiB 512MiB
    mkpart primary xfs 100%
    set 1 boot on
    quit
    mkfs.fat -F32 /dev/sda1
    mkfs.xfs /dev/sda2
    mount /dev/sda2 /mnt
    mkdir -p /mnt/boot
    mount /dev/sda1 /mnt/boot
    pacstrap /mnt base base-devel
    genfstab /mnt >> /mnt/etc/fstab
    arch-chroot /mnt
    passwd root
    echo apowers01 > /etc/hostname
    echo KEYMAP=dvorak >> /etc/vconsole.conf
    hwclock --systohc --utc
    export TZ='America/Los_Angeles' >> .profile
    ln -s /usr/share/zoneinfo/America/Los_Angeles /etc/localtime
    echo > /boot/loader/entries/arch.conf << EOF
    title          Arch Linux
    linux          /vmlinuz-linux
    initrd         /initramfs-linux.img
    options        root=/dev/sda2 rw
    EOF
    echo > /boot/loader/loader.conf << EOF
    timeout 3
    defalut arch
    EOF
    systemctl enable dhcpcd@enp0s3.service
    exit
    reboot

# Unmount Boot ISO
# Setup OS

    pacman -Syy
    pacman -S --noconfirm linux-headers virtualbox-guest-utils virtualbox-guest-dkms
    systemctl enable dkms.service
    dkms autoinstall
    modprobe -a vboxguest vboxsf vboxvideo
    echo > /etc/modules-load.d/virtualbox.conf << EOF
    vboxguest
    vboxsf
    vboxvideo
    EOF
    echo en_US.UTF-8 UTF-8 > /etc/locale.gen
    locale-gen

    pacman -S --noconfirm xfce4 wget
    useradd -m -G wheel apowers
    visudo
    cd ~apowers
    wget --no-check-certificate https://raw.github.com/apowers/home/master/setup_home.sh
    chmod +x setup_home.sh
    ./setup_home.sh


# Setup X (TODO: Automate)
* Settings -> Keyboard -> Layout -> English/English(Dvorak)
* Terminal -> Edit -> Preferences -> Appearance -> Monospace 9

See Also:
* https://wiki.archlinux.org/index.php/ZFS
