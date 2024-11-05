#!/usr/bin/env bash

mkdir -p /dev/shm/hui
cd /dev/shm/hui

dd if=/dev/urandom of=z bs=1G count=1 conv=fsync

echo odc
time -p echo z | cpio -oH odc > zn
echo bin
time -p echo z | cpio -oH bin > zn
echo newc
time -p echo z | cpio -oH newc > zn
echo crc
time -p echo z | cpio -oH crc > zn

echo v7
time -p tar -H v7 -cf zn z
echo oldgnu
time -p tar -H oldgnu -cf zn z
echo ustar
time -p tar -H ustar -cf zn z
echo gnu
time -p tar -H gnu -cf zn z
echo pax
time -p tar -H pax -cf zn z
ls -lh zn