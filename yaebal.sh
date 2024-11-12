#!/usr/bin/env bash

mkdir ./z
cd ./z

curl -ZLo 'hui' https://eu.dl.twrp.me/taoyao/twrp-3.7.1_12-0-taoyao.img'
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

echo '- zt19'
time -p zstd -T0 -19zc tps > zt19
sleep 1

echo '- zt20'
time -p zstd -T0 --ultra -20zc tps > zt20
sleep 1

echo '- zt22'
time -p zstd -T0 --ultra -22zc tps > zt22
sleep 1

echo '****'
ls -lS --block-size=M
