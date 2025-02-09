#!/usr/bin/env bash
set -ex

cd /dev/shm
dd if=/dev/zero of=./z bs=8G count=1 conv=fsync
mkdir ./n

mke2fs -t ext4 -Fq -I1024 -m0 -O "^has_journal,^metadata_csum,sparse_super2,\
^metadata_csum_seed,^resize_inode,stable_inodes,uninit_bg,extra_isize" ./z
mount ./z ./n

dd if=/dev/zero of=./n/h bs=7G count=1 conv=fsync

umount ./z
mkfs.xfs -f -i 'size=2048' ./z
mount ./z ./n

dd if=/dev/zero of=./n/h bs=7G count=1 conv=fsync
