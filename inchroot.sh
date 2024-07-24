#!/usr/bin/env bash
echo CHROOT
read

zone=Europe/Moscow
name=hui
password=123

echo 'arch' > /etc/hostname
locale-gen
ln -sf "/usr/share/zoneinfo/$zone" /etc/localtime
hwclock --systohc
useradd -mg users -G wheel "$name"
echo "$password" | passwd --stdin "$name"

pacman -Syu --noconfirm
pacman -S opendoas networkmanager network-manager-applet git bash-completion \
          vulkan-radeon libva-mesa-driver \
          gdm gnome grub efibootmgr --noconfirm

systemctl enable NetworkManager gdm
echo 'permit persist :wheel as root' > /etc/doas.conf
chmod 400 /etc/doas.conf
grub-install /dev/vda
grub-mkconfig -o /boot/grub/grub.cfg

exit
