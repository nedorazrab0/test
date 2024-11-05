#!/usr/bin/env bash

mkdir -p /dev/shm/hui
cd /dev/shm/hui

dd if=/dev/urandom of=z bs=1G count=1 conv=fsync

echo v7
time -p tar -H v7 -cf zn z
sleep 1
echo oldgnu
time -p tar -H oldgnu -cf zn z
sleep 1
echo ustar
time -p tar -H ustar -cf zn z
sleep 1
echo gnu
time -p tar -H gnu -cf zn z
sleep 1
echo pax
time -p tar -H pax -cf zn z
sleep 1
ls -lh zn