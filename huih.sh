#!/usr/bin/env bash
set -ex

mkdir ./hui
#mount -t tmpfs -o size=9G,mode=1777 hui ./hui
cd ./hui

truncate -s 9G z
mkdir ./n

umount ./z
mkfs.xfs -i size=1024 -m crc=0 ./z
mount -o dax=always ./z ./n

dd if=/dev/zero of=./n/h ibs=8G obs=256K count=1 conv=fsync
