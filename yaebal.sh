#!/usr/bin/env bash
set +e

mkdir z
cd z
sudo apt install libarchive-tools

for i in {0..9}; do
    dd if=/dev/urandom bs=128M count=1 conv=fsync
done

time -p tar -b1 -H ustar -cvf - {0..9} > tr
sleep 1
time -p bsdtar -b1 -cv {0..9} > btr
sleep 1