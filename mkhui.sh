#!/usr/bin/env bash
#
#

set -ex
umask 0077
idir='/var/archiso-v/idir'
odir='/var/archiso-v/odir'
isodir='/var/archiso-v/iso'


# poshol nahui dolbaeb kotoriy pridumal pihat datu v uuid
[[ -v SOURCE_DATE_EPOCH ]] || printf -v SOURCE_DATE_EPOCH '%(%s)T' -1
printf -v iso_uuid '%(%F-%H-%M-%S-00)T' "${SOURCE_DATE_EPOCH}"

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

mkdir -p "${idir}/etc/mkinitcpio"{,.conf}.d "${odir} "${idir} "${isodir}"

cat << 'EOF' > "${idir}/etc/mkinitcpio.conf.d/hui.conf
HOOKS=(base udev archiso_loop_mnt modconf archiso block filesystems)
COMPRESSION='xz'
COMPRESSION_OPTIONS=(-9e -T0 -M100%)
EOF

cat << 'EOF' > "${idir}/etc/mkinitcpio.d/linux-zen.preset"
PRESETS=('hui')
ALL_kver='/boot/vmlinuz-linux-zen'
hui_config='/etc/mkinitcpio.conf.d/hui.conf'
hui_image='/boot/initramfs-linux-zen.img'
EOF

pacstrap -cMG "${idir}" ${pkgs} &>/dev/null
mkdir -p "${idir}/etc/systemd/system-generators"
ln -sf /dev/null "${idir}/etc/systemd/system-generators/systemd-gpt-auto-generator"

# ESP
bootsize="$(du --block-size=1 -cs "${idir}/boot" \
  | tail -n1 | awk '{print $1}')"
espsize="$((bootsize + 1*1024*1024))"

dd if=/dev/zero of="${isodir}/esp.img" iflag=fullblock oflag=noatime \
  ibs="${espsize}" obs=256K count=1 conv=fsync

mkfs.fat -v -F32 -S512 -s1 -n 'ESP' "${isodir}/esp.img"
mount "${isodir}/esp.img" /mnt

mkdir -p /mnt/loader/entries /mnt/EFI/BOOT
cp /usr/lib/systemd/boot/efi/systemd-bootx64.efi /mnt/EFI/BOOT/BOOTx64.EFI

cat << EOF > /mnt/loader/entries/archiso-zen.conf
title ArchISO-V ZEN
linux /vmlinuz-linux-zen
initrd /amd-ucode.img
initrd /initramfs-linux-zen.img
options archisosearchuuid=${iso_uuid} arch=/ archisobasedir=/
EOF

mv "${idir}/boot/"* /mnt
find /mnt
umount /mnt

rm -rf "${idir}/usr/share/"{doc,man}

#
mkfs.erofs -Efragments,dedupe,force-inode-extended,ztailpacking -T0 \
  --quiet -zlzma,109,dictsize=8388608 -C1048576 "${odir}/airootfs.erofs" "${idir}"
#aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
xorriso -no_rc -temp_mem_limit 1024m -as mkisofs -iso-level 2 -rational-rock \
  -volid 'ARCHISO' -appid 'archiso-v' -preparer 'prepared by archiso-v' \
  -publisher 'arch-v <https://github.com/nedorazrab0/archiso-v>' \
  -append_partition 2 'C12A7328-F81F-11D2-BA4B-00A0C93EC93B' ./esp.img \
  -appended_part_as_gpt -partition_offset 16 -no-pad \
  -output "${isodir}/archiso-v.iso" "${odir}"
