#!/usr/bin/env bash
#
#
set -e
pacman -Sy erofs-utils arch-install-scripts dosfstools xorriso --noconfirm


mkdir /hh /hhh /out
pacstrap -cMG /hh base linux mkinitcpio-archiso &>/dev/null

# ESP
#espsize="$(du --block-size=1024 -cs /boot | tail -n1 | awk '{print $1}')"
mkfs.fat -F32 -n 'ESP' -C esp.img 64000  #"${espsize}"
rm -f /hh/boot/*fallback*
ls -lh esp.img /hh/boot*
mount esp.img /mnt

mkdir -p /mnt/loader/entries /mnt/EFI/BOOT
cp /usr/lib/systemd/boot/efi/systemd-bootx64.efi /mnt/EFI/BOOT/BOOTx64.EFI
cat << EOF > /mnt/loader/entries/a.conf
title a
linux /vmlinux-linux
initrd /initramfs-linux.img
options archisosearchuuid=%uuid%
EOF

mv /hh/boot/* /mnt
umount /mnt

#
mkfs.erofs --quiet -zlz4 -Efragments,dedupe,force-inode-extended,ztailpacking -C262144 -T0 -- /hhh/airootfs.erofs /hh
xorriso -no_rc -report_about SORRY -as mkisofs -iso-level 3 -rational-rock -volid NAME -appid 'Arch Linux baseline' -publisher 'Arch Linux <https://archlinux.org>' -preparer 'prepared by mkarchiso' -partition_offset 16 -append_partition 2 C12A7328-F81F-11D2-BA4B-00A0C93EC93B /hui/esp.img -appended_part_as_gpt -no-pad -output /out/archiso-v-x86_64.iso /hh
