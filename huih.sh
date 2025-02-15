#!/usr/bin/env bash
set -ex

mkdir ./hui
#mount -t tmpfs -o size=9G,mode=1777 hui ./hui
cd ./hui

truncate -s 9G z
mkdir ./n
losetup /dev/loop0 ./z

#zpool create -O acltype=posixacl  -O mountpoint="$(realpath ./n)" test /dev/loop0
#-O compression=zstd
#zfs set mountpoint="$(realpath ./n)" test

mkfs.xfs -i size=1024 -m crc=0 ./z
mount /dev/loop0 ./n

dd if=/dev/urandom of=./n/h ibs=8G obs=256K count=1 conv=fsync