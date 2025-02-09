#!/usr/bin/env bash
set -ex

mkdir ./hui
mount -t tmpfs -o size=9G,mode=1777 hui ./hui
cd ./hui

truncate -s 9G z
mkdir ./n

mkfs.btrfs -m single -n65536 ./z
mount -o ssd,nodiscard,nodatacow,nodatasum,nobarrier ./z ./n

dd if=/dev/zero of=./n/h ibs=8G obs=256K count=1 conv=fsync

umount ./z
mkfs.xfs -f -i 'size=1024' ./z
mount ./z ./n

dd if=/dev/zero of=./n/h ibs=8G obs=256K count=1 conv=fsync
