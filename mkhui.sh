#!/usr/bin/env bash
#
# Build an archiso

set -ex
umask 0077
idir='/var/archiso-v/idir'
odir='/var/archiso-v/odir'
isodir='/var/archiso-v/iso'

# poshol nahui dolbaeb kotoriy pridumal pihat datu v uuid
[[ -v SOURCE_DATE_EPOCH ]] || printf -v SOURCE_DATE_EPOCH '%(%s)T' -1
printf -v iso_uuid '%(%F-%H-%M-%S-00)T' "${SOURCE_DATE_EPOCH}"
export SOURCE_DATE_EPOCH

pacman -Sy arch-install-scripts mtools \
  xorriso dosfstools erofs-utils --noconfirm

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

mkdir -p "${idir}/etc/mkinitcpio"{,.conf}.d \
  "${odir}" "${idir}" "${isodir}"

cat << 'EOF' > "${idir}/etc/mkinitcpio.conf.d/arch9660.conf"
HOOKS=(base udev archiso_loop_mnt microcode modconf archiso block filesystems)
COMPRESSION='xz'
COMPRESSION_OPTIONS=(-9e -T0 -M100%)
EOF

cat << 'EOF' > "${idir}/etc/mkinitcpio.d/linux-zen.preset"
PRESETS=('arch9660')
ALL_kver='/boot/vmlinuz-linux-zen'
arch9660_config='/etc/mkinitcpio.conf.d/arch9660.conf'
arch9660_image='/boot/initramfs-linux-zen.img'
EOF

pacstrap -cGP "${idir}" ${pkgs} &>/dev/null


mkdir -p "${idir}/etc/systemd/system-generators"
ln -sf /dev/null \
  "${idir}/etc/systemd/system-generators/systemd-gpt-auto-generator"

date +'archiso_v%d-%m-%y' \
  > "${idir}/etc/hostname"

echo 'root:x:0:0::/root:/usr/bin/bash' \
  > "${idir}/etc/passwd"
echo 'root::1::::::' \
  > "${idir}/etc/shadow"
chmod 400 "${idir}/etc/shadow"

rm -rf "${idir}/usr/share/"{doc,man}

# ESP
rm -f "${idir}/boot/amd-ucode.img"
bootsize="$(du -B1024 -s "${idir}/boot" \
  | tail -n1 | awk '{print $1}')"
espsize="$((bootsize + 512))"

mkfs.fat -F32 -S512 -R2 -v -f1 -s1 -b0 -n 'ESP9660' \
  --codepage=437 -C "${isodir}/esp.img" "${espsize}"
mount "${isodir}/esp.img" /mnt

echo 'editor no' \
  > /var/loader.conf
  
cat << EOF > /var/arch9660-zen.conf
title Arch9660 ZEN
linux /vmlinuz-linux-zen
initrd /initramfs-linux-zen.img
options archisosearchuuid=${iso_uuid} zswap.enabled=false copytoram=y arch=/ archisobasedir=/
EOF

mmd -i "${isodir}/esp.img" \
  '::/loader' '::/loader/entries' \
  '::/EFI' '::/EFI/BOOT'

mcopy -i "${isodir}/esp.img" \
  "${idir}/boot/"{vmlinuz-linux-zen,initramfs-linux-zen.img} \
  '::/'
mcopy -i "${isodir}/esp.img" \
  "${idir}/usr/lib/systemd/boot/efi/systemd-bootx64.efi" \
  '::/EFI/BOOT/BOOTx64.EFI'
mcopy -i "${isodir}/esp.img" \
  /var/loader.conf '::/loader'
mcopy -i "${isodir}/esp.img" \
  /var/arch9660-zen.conf '::/loader/entries'

rm -rf "${idir}/"{boot,var,tmp}/*
rm -rf /usr/include \
  /usr/lib/lib{go,icudata}.so* /usr/share/info /usr/share/terminfo
find "${idir}" -name '*.pacnew' \
  -o -name '*.pacsave' -o -name '*.pacorig' -delete


# EROFS compressed img
mkfs.erofs -Efragments,dedupe,force-inode-extended,ztailpacking --quiet \
  -T0 -zlzma,109,dictsize=8388608 -C1048576 "${odir}/airootfs.erofs" "${idir}"
#aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
# ISO file
xorriso -no_rc -temp_mem_limit 1024m -as mkisofs -iso-level 2 -rational-rock \
  -volid 'ARCH9660' -appid 'arch9660' -preparer 'prepared by arch9660' \
  -publisher 'Arch9660 <https://github.com/nedorazrab0/arch9660>' \
  -append_partition 2 'C12A7328-F81F-11D2-BA4B-00A0C93EC93B' "${isodir}/esp.img" \
  -appended_part_as_gpt -partition_offset 16 -no-pad \
  -output "${isodir}/arch9660.iso" "${odir}"
