#!/usr/bin/env bash

mkdir ./z
cd ./z

curl -ZLo 'hui' 'https://mirrorbits.lineageos.org/full/lisa/20241105/boot.img'
echo '****'

echo '- tv7'
time -p tar -H v7 -cf - hui > tv7
sleep 1

echo '- tps'
time -p tar -H pax -cf - hui > tps
sleep 1

echo '- lz1'
time -p lz4 -1zc tps > lz1
sleep 1

echo '-lz12'
time -p lz4 -12zc tps > lz12
sleep 1

echo '- zt20'
time -p zstd -T0 --ultra -20zc tps > zt20
sleep 1

echo '****'
ls -lS --block-size=M
