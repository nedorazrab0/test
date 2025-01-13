#!/usr/bin/env bash
#
#
set -e
pacman -Sy erofs-utils arch-install-scripts dosfstools xorriso --noconfirm


mkdir -p /hh/so /hhh /out /hh/iso/
pacstrap -cMG /hh/so base linux mkinitcpio-archiso &>/dev/null

# ESP
#espsize="$(du --block-size=1024 -cs /boot | tail -n1 | awk '{print $1}')"
mkfs.fat -F32 -n 'ESP' -C esp.img 64000  #"${espsize}"
rm -f /hh/so/boot/*fallback*
mount esp.img /mnt

mkdir -p /mnt/loader/entries /mnt/EFI/BOOT
cp /usr/lib/systemd/boot/efi/systemd-bootx64.efi /mnt/EFI/BOOT/BOOTx64.EFI
cat << 'EOF' > /mnt/loader/entries/a.conf
title a
linux /hh/so/boot/vmlinux-linux
initrd /hh/so/boot/initramfs-linux.img
options archisobasedir=/hh/so archisolabel=HUI
EOF

mv /hh/so/boot/* /mnt
umount /mnt

iso_uuid=6b012502-9b5a-45bd-a94e-146f91f98fe5
#
mkfs.erofs -zlz4 -Efragments,dedupe,force-inode-extended,ztailpacking -C262144 -T0 -- /hh/iso/airootfs.erofs /hh/so
xorriso -no_rc -as mkisofs -iso-level 3 -rational-rock -volid HUI -appid 'Arch Linux baseline' -publisher 'Arch Linux <https://archlinux.org>' -preparer 'prepared by mkarchiso' -partition_offset 16 -append_partition 2 C12A7328-F81F-11D2-BA4B-00A0C93EC93B esp.img -appended_part_as_gpt -no-pad -output /out/archiso-v-x86_64.iso /hh/iso/
blkid /out/archiso-v-x86_64.iso
