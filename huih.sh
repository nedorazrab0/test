#!/usr/bin/env bash
set -ex

mkdir ./hui
#mount -t tmpfs -o size=9G,mode=1777 hui ./hui
cd ./hui

truncate -s 9G z
mkdir ./n

mkfs.btrfs -m single -n65536 --csum xxhash  ./z
mount -o compress=zstd:3,ssd,nodiscard,nobarrier,noatime ./z ./n

dd if=/dev/zero of=./n/h ibs=8G obs=256K count=1 conv=fsync

umount ./z
mke2fs -t ext4 -I1024 -F ./z
mount ./z ./n

dd if=/dev/zero of=./n/h ibs=8G obs=256K count=1 conv=fsync
