#!/usr/bin/env bash
set -ex

mkdir ./hui
#mount -t tmpfs -o size=9G,mode=1777 hui ./hui
cd ./hui

truncate -s 9G z
mkdir ./n
losetup /dev/loop0 ./z

#zpool create -O acltype=posixacl -O compression=zstd -O mountpoint="$(realpath ./n)" test /dev/loop0

#zfs set mountpoint="$(realpath ./n)" test

mkfs.btrfs -n65536 -f -m single --csum xxhash ./z
mount -o compression=zstd:3,noatime,nodiscatrd, nobarrier /dev/loop0 ./n

dd if=/dev/urandom of=./n/h ibs=8G obs=256K count=1 conv=fsync