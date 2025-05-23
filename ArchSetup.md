# Arch Linux Setup Notes

* Virtual Box development workstation
* Single xfs file system; for a vbox dev system we don't need a fancy FS.
* xfce4 graphical environment

References:
* https://wiki.archlinux.org/index.php/Installation_guide
* https://wiki.archlinux.org/index.php/Beginners%27_guide

1. In VirtualBox: System -> Motherboard -> Enable EFI
1. From ISO: Boot Arch x86_64
    ```
    loadkeys dvorak
    parted /dev/sda
      mklabel gpt
      mkpart ESP fat32 1MiB 512M
      mkpart primary xfs 512M 100%
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
    bootctl install
    cat > /boot/loader/entries/arch.conf << EOF
    title          Arch Linux
    linux          /vmlinuz-linux
    initrd         /initramfs-linux.img
    options        root=/dev/sda2 rw
    EOF
    cat > /boot/loader/loader.conf << EOF
    timeout 3
    defalut arch
    EOF
    passwd root
    echo arch01 > /etc/hostname
    echo KEYMAP=dvorak >> /etc/vconsole.conf
    hwclock --systohc --utc
    ln -s /usr/share/zoneinfo/America/Los_Angeles /etc/localtime
    systemctl enable dhcpcd@enp0s3.service

    pacman -Syy
    pacman -S wget xorg-server xfce4

    wget https://raw.github.com/apowers/home/master/setup_system.sh
    sh setup_system.sh

    useradd -m -N -g wheel apowers
    passwd apowers

    exit
    reboot
    ```
2. Unmount Boot ISO
3. Install SSH keys
4. Extra setup from README.md
5. Clone github.com/apowers/home and run additional setup scripts.

