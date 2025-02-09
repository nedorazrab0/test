#!/usr/bin/env bash
set -ex

mkdir ./hui
mount -t tmpfs -o size=9G,mode=1777 hui ./hui
cd ./hui

truncate -s 9G z
mkdir ./n

mkfs.btrfs -m single -n65536  ./z
mount -o ssd,nodiscard,nodatacow,nodatasum,nobarrier,noatime ./z ./n

dd if=/dev/zero of=./n/h ibs=8G obs=256K count=1 conv=fsync

modprobe null_blk
umount ./z
mkfs.xfs -i size=1024 -m crc=0 -l logdev=/dev/nullb1 -f ./z
mount ./z ./n

dd if=/dev/zero of=./n/h ibs=8G obs=256K count=1 conv=fsync
