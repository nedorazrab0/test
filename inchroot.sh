#!/usr/bin/env bash
echo CHROOT
read

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
grub-install --target=x86_64-efi --efi-directory=/boot/efi --bootloader-id=arch
grub-mkconfig -o /boot/grub/grub.cfg

exit
