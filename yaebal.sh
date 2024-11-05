#!/usr/bin/env bash

mkdir -p /dev/shm/hui
cd /dev/shm/hui

dd if=/dev/urandom of=z bs=1G count=1 conv=fsync

time -p echo z | cpio -oH odc > zn
time -p echo z | cpio -oH bin > zn
time -p echo z | cpio -oH newc > zn
time -p echo z | cpio -oH crc > zn

time -p tar -H v7 -cf zn z
time -p tar -H oldgnu -cf zn z
time -p tar -H ustar -cf zn z
time -p tar -H gnu -cf zn z
time -p tar -H pax -cf zn z