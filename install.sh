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
umount /dev/$disk*
wipefs --all /dev/$disk
echo -e 'label:gpt\n,512M,U,-,\n,1G,\n,+,\n' | sfdisk /dev/$disk

mkfs.fat -F32 -n 'ESP' /dev/$disk*1
mke2fs -FL 'boot' /dev/$disk*2
mkfs.f2fs -fil 'arch' -O extra_attr,inode_checksum,sb_checksum,compression /dev/$disk*3

read
mount /dev/$disk*3 /mnt/
mkdir -p /mnt/boot/
mount /dev/$disk*2 /mnt/boot/
mkdir -p /mnt/boot/efi/
mount /dev/$disk*1 /mnt/boot/efi/
read
sed -i -e 's/#ParallelDownloads = 5/ParallelDownloads = 15/' -e 's/#Colors/Colors/' -e 's/#VerbosePkgLists/VerbosePkgLists/' /etc/pacman.conf

pacman-key --init
pacman-key --populate archlinux
pacman -Syy
pacman -S pacman-contrib --noconfirm
curl "https://archlinux.org/mirrorlist/?country=${loc}&protocol=https&use_mirror_status=on" | sed -e 's/^#Server/Server/' -e '/^#/d' | rankmirrors -wn 2 - > /etc/hui
cat /etc/hui > /etc/pacman.d/mirrorlist

pacstrap -K /mnt base linux-lts linux-firmware amd-ucode
echo
cat /etc/pacman.d/mirrorlist
read
cat /etc/hui > /mnt/etc/pacman.d/mirrorlist
kbl="${kblr}.UTF-8 UTF-8"
sed -i -e "s/#$kbl/$kbl/" /mnt/etc/locale.gen
genfstab -Up /mnt | sed 's/lz4/zstd:6,compress_chksum/' > /mnt/etc/fstab
sed -i -e 's/#ParallelDownloads = 5/ParallelDownloads = 15/' -e 's/#Colors/Colors/' -e 's/#VerbosePkgLists/VerbosePkgLists/' /mnt/etc/pacman.conf

curl -o /mnt/etc/pizda https://raw.githubusercontent.com/nedorazrab0/test/main/inchroot.sh
chmod +x /mnt/etc/pizda
arch-chroot /mnt /etc/pizda
read
echo 'Goodbye ;)'
umount -R /mnt
sleep 1
poweroff
