#!/usr/bin/env bash
set +e

mkdir z
cd z
sudo apt install libarchive-tools

for i in $(seq 10); do
    dd if=/dev/urandom of="$1" bs=128M count=1 conv=fsync
done

time -p tar -b1 -H ustar -cvf - {1..10} > tr
sleep 1
time -p bsdtar -b1 -cv {1..10} > btr
sleep 1