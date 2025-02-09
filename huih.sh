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
mkfs.xfs -i size=1024 -m crc=1 -l size=2097152 -f ./z
mount ./z ./n

dd if=/dev/zero of=./n/h ibs=8G obs=256K count=1 conv=fsync
