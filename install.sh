#!/usr/bin/env bash

read -p '- Username: ' name
read -p '- Password: ' password
read -p '- Timezone (Europe/Moscow):' zone
read -p '- Country ISO code (for mirrors): ' loc
read -p '- раскладка (ru_RU)' kblr
read -p '- Do you want to destroy your own disk? (y/n): ' agreement

name=hui
password=123
zone=Europe/Moscow
loc=RU
kblr=en_US

case "$agreement" in
    y) true;;
    n) exit 0;;
    *) true;;
esac

lsblk -do name,model,size,rm,tran
read -p '- Disk name: ' disk
sleep 1

blk="/dev/$disk"
umount ${blk}*
wipefs --all "$blk"
parted -s "$blk" mktable gpt
parted -s "$blk" mkpart primary 1Mib 33Mib
parted -s "$blk" mkpart primary ext4 33Mib 1057MiB
parted -s "$blk" mkpart primary f2fs 1057MiB 100%
mkfs.fat -F32 -n 'esp' /dev/vda1
mkfs.ext4 -FL 'boot' /dev/vda2
mkfs.f2fs -fl 'arch' /dev/vda3
parted -s "$blk" set 1 boot on

mount ${blk}3 /mnt/
mkdir -p /mnt/boot/
mount ${blk}2 /mnt/boot/
mkdir -p /mnt/boot/efi/
mount ${blk}1 /mnt/boot/efi/
read

sed -i -e 's/#ParallelDownloads = 5/ParallelDownloads = 15/' -e 's/#Colors/Colors/' -e 's/#VerbosePkgLists/VerbosePkgLists/' /etc/pacman.conf

pacman-key --init
pacman-key --populate archlinux
pacman -Syy
pacman -S pacman-contrib --noconfirm
curl "https://archlinux.org/mirrorlist/?country=${loc}&protocol=https&use_mirror_status=on" | sed -e 's/^#Server/Server/' -e '/^#/d' | rankmirrors -wn 6 - > /var/eai/mirrorlist
cat /var/eai/mirrorlist > /etc/pacman.d/mirrorlist

pacstrap -K /mnt base linux-lts linux-firmware amd-ucode

kbl="${kblr}.UTF-8 UTF-8"
sed -i -e "s/#$kbl/$kbl/" /mnt/etc/locale.gen
genfstab -Up /mnt > /mnt/etc/fstab

mkdir /var/eai
curl -o /var/eai/inchroot.sh https://raw.githubusercontent.com/nedorazrab0/test/main/inchroot.sh
chmod +x /var/eai/inchroot.sh
arch-chroot /mnt /var/eai/inchroot.sh
read
echo 'Goodbye ;)'
umount -R /mnt
sleep 1
poweroff
