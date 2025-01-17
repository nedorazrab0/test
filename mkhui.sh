#!/usr/bin/env bash
#
#

umask 0022
export LC_ALL="C.UTF-8"
[[ -v SOURCE_DATE_EPOCH ]] || printf -v SOURCE_DATE_EPOCH '%(%s)T' -1
export SOURCE_DATE_EPOCH

set -ex
cd /var
pacman -Sy erofs-utils arch-install-scripts dosfstools xorriso python --noconfirm

pkgs='amd-ucode
base
bash-completion
linux-zen
linux-firmware
gptfdisk
mkinitcpio
mkinitcpio-archiso
python
arch-install-scripts
reflector
btrfs-progs
dosfstools
iwd
iptables-nft
less
nano
zram-generator'

mkdir -p /hh/etc/mkinitcpio{,.conf}.d /hhh /hh

echo 'HOOKS=(base systemd modconf archiso block filesystems keyboard)' > /hh/etc/mkinitcpio.conf.d/hui.conf
cat << 'EOF' > /hh/etc/mkinitcpio.d/linux-zen.preset
PRESETS=('hui')
ALL_kver='/boot/vmlinuz-linux-zen'
hui_config='/etc/mkinitcpio.conf.d/hui.conf'
hui_image='/boot/initramfs-linux-zen.img'
EOF

pacstrap -cMG /hh ${pkgs} &>/dev/null
mkdir -p /hh/etc/systemd/system-generators
ln -sf /dev/null /hh/etc/systemd/system-generators/systemd-gpt-auto-generator

# ESP
bootsize="$(du --block-size=1 -cs /hh/boot \
  | tail -n1 | awk '{print $1}')"
espsize="$((bootsize + 1*1024*1024))"

dd if=/dev/zero of=./esp.img iflag=fullblock oflag=noatime ibs="${espsize}" count=1 obs=256K conv=fsync

mkfs.fat -v -F32 -S512 -s1 -n 'ESP' ./esp.img
mount esp.img /mnt

mkdir -p /mnt/loader/entries /mnt/EFI/BOOT
cp /usr/lib/systemd/boot/efi/systemd-bootx64.efi /mnt/EFI/BOOT/BOOTx64.EFI

TZ=UTC printf -v iso_uuid '%(%F-%H-%M-%S-00)T' "$SOURCE_DATE_EPOCH"
cat << EOF > /mnt/loader/entries/a.conf
title a
linux /vmlinuz-linux-zen
initrd /amd-ucode.img
initrd /initramfs-linux-zen.img
options archisosearchuuid=$iso_uuid arch=/ init=/usr/lib/systemd/systemd archisobasedir=/
EOF

mv /hh/boot/* /mnt
find /mnt
umount /mnt

rm -rf /hh/usr/share/{doc,man}

#
mkfs.erofs --quiet -zlzma,109,dictsize=8388608 -Efragments,dedupe,force-inode-extended,ztailpacking   -C1048576 -T0 -- /hhh/airootfs.erofs /hh/
xorriso -no_rc -as mkisofs -iso-level 2 -rational-rock -volid HUI -appid 'Arch Linux baseline' -publisher 'Arch Linux <https://archlinux.org>' -preparer 'prepared by mkarchiso' -partition_offset 16 -append_partition 2 C12A7328-F81F-11D2-BA4B-00A0C93EC93B esp.img -appended_part_as_gpt -no-pad -output /out/archiso-v-x86_64.iso /hhh
blkid /out/archiso-v-x86_64.iso
sfdisk -l /out/archiso-v-x86_64.iso
