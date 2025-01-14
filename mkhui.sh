#!/usr/bin/env bash
#
#

umask 0022
export LC_ALL="C.UTF-8"
[[ -v SOURCE_DATE_EPOCH ]] || printf -v SOURCE_DATE_EPOCH '%(%s)T' -1
export SOURCE_DATE_EPOCH

set -e
pacman -Sy erofs-utils arch-install-scripts dosfstools xorriso --noconfirm


mkdir -p /hh/so/etc/mkititcpio{,.conf}.d /hhh /out /hh/iso/

echo 'HOOKS=(base udev modconf archiso block filesystems)' > /hh/so/etc/mkinitcpio.conf.d/hui.conf
cat << 'EOF' > /hh/so/etc/mkinitcpio.d/linux-zen.preset
PRESETS=('archiso')
ALL_kver='/boot/vmlinuz-linux-zen'
archiso_config='/etc/mkinitcpio.conf.d/archiso.conf'
archiso_image="/boot/initramfs-linux-zen.img"
EOF

pacstrap -cMG /hh/so base linux-zen mkinitcpio mkinitcpio-archiso &>/dev/null

# ESP
#espsize="$(du --block-size=1024 -cs /boot | tail -n1 | awk '{print $1}')"
mkfs.fat -F32 -n 'ESP' -C esp.img 64000  #"${espsize}"
rm -f /hh/so/boot/*fallback*
mount esp.img /mnt

mkdir -p /mnt/loader/entries /mnt/EFI/BOOT
cp /usr/lib/systemd/boot/efi/systemd-bootx64.efi /mnt/EFI/BOOT/BOOTx64.EFI

TZ=UTC printf -v iso_uuid '%(%F-%H-%M-%S-00)T' "$SOURCE_DATE_EPOCH"
cat << EOF > /mnt/loader/entries/a.conf
title a
linux /vmlinuz-linux
initrd /initramfs-linux.img
options archisobasedir=/ archisosearchuuid=$iso_uuid
EOF
echo > /hh/so/boot/${iso_uuid}.uuid
mv /hh/so/boot/* /mnt
umount /mnt

#
mkfs.erofs --quiet -zlz4 -Efragments,dedupe,force-inode-extended,ztailpacking -C262144 -T0 -- /hh/iso/airootfs.erofs /hh/
xorriso -no_rc -as mkisofs -iso-level 3 -rational-rock -volid HUI -appid 'Arch Linux baseline' -publisher 'Arch Linux <https://archlinux.org>' -preparer 'prepared by mkarchiso' -partition_offset 16 -append_partition 2 C12A7328-F81F-11D2-BA4B-00A0C93EC93B esp.img -appended_part_as_gpt -no-pad -output /out/archiso-v-x86_64.iso /hh/iso/
blkid /out/archiso-v-x86_64.iso
