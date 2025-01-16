#!/usr/bin/env bash
#
#

umask 0022
export LC_ALL="C.UTF-8"
[[ -v SOURCE_DATE_EPOCH ]] || printf -v SOURCE_DATE_EPOCH '%(%s)T' -1
export SOURCE_DATE_EPOCH

#SOURCE_DATE_EPOCH=$RANDOM

set -ex
pacman -Sy erofs-utils arch-install-scripts dosfstools xorriso python --noconfirm


mkdir -p /hh/so/etc/mkinitcpio{,.conf}.d /hhh /out /hh/iso/

echo 'HOOKS=(base udev modconf archiso block filesystems)' > /hh/so/etc/mkinitcpio.conf.d/hui.conf
cat << 'EOF' > /hh/so/etc/mkinitcpio.d/linux-zen.preset
ALL_kver='/boot/vmlinuz-linux-zen'
hui_config='/etc/mkinitcpio.conf.d/hui.conf'
ALL_image="/boot/initramfs-linux-zen.img"
EOF

pacstrap -cMG /hh/so base linux-zen mkinitcpio mkinitcpio-archiso &>/dev/null
mkdir -p /hh/so/etc/systemd/system-generators
ln -sf /dev/null /hh/so/etc/systemd/system-generators/systemd-gpt-auto-generator


# ESP
espsize="$(du --block-size=1024 -cs /hh/so/boot | tail -n1 | awk '{print $1}')"

espsize="$((espsize + 1024))"
mkfs.fat -v -F32 -S512 -s1 -n 'ESP' -C esp.img "${espsize}"
#mkfs.fat -v -F16 -S512 -s1 -n 'ESP' -C esp.img "${espsize}"
mount esp.img /mnt

mkdir -p /mnt/loader/entries /mnt/EFI/BOOT
cp /usr/lib/systemd/boot/efi/systemd-bootx64.efi /mnt/EFI/BOOT/BOOTx64.EFI

TZ=UTC printf -v iso_uuid '%(%F-%H-%M-%S-00)T' "$SOURCE_DATE_EPOCH"
#iso_uuid=2cf777e5-cb87-473e-bf22-c6cf14d6f3fc
cat << EOF > /mnt/loader/entries/a.conf
title a
linux /vmlinuz-linux-zen
initrd /initramfs-linux-zen.img
options arch=/ archisobasedir=/ archisosearchuuid=$iso_uuid
EOF
#echo > /hh/so/boot/${iso_uuid}.uuid
mv /hh/so/boot/* /mnt
find /mnt
umount /mnt

rm -rf /hh/so/usr/share/{doc,man}

#
mkfs.erofs --quiet -zlzma -Efragments,dedupe,force-inode-extended,ztailpacking -C262144 -T0 -- /hhh/airootfs.erofs /hh/
xorriso -no_rc -as mkisofs -iso-level 3 -rational-rock -volid HUI -appid 'Arch Linux baseline' -publisher 'Arch Linux <https://archlinux.org>' -preparer 'prepared by mkarchiso' -partition_offset 16 -append_partition 2 C12A7328-F81F-11D2-BA4B-00A0C93EC93B esp.img -appended_part_as_gpt -no-pad -output /out/archiso-v-x86_64.iso /hhh
blkid /out/archiso-v-x86_64.iso
sfdisk -l /out/archiso-v-x86_64.iso
