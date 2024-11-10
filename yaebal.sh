#!/usr/bin/env bash

mkdir ./z
cd ./z

curl -ZLo 'hui' 'https://geo.mirror.pkgbuild.com/iso/2024.11.01/archlinux-2024.11.01-x86_64.iso'
echo '****'

echo '- lz12'
time -p lz4 -12zc 'hui' > lz12

echo '- zp9'
time -p zip -9 - 'hui' > zp9

echo '- za6'
time -p 7za a za6 'hui' -mx6
echo '- za7'
time -p 7za a za7 'hui' -mx7
echo '- za8'
time -p 7za a za8 'hui' -mx8
echo '- za9'
time -p 7za a za9 'hui' -mx9

echo '- zt3'
time -p zstd -T0 --ultra -3zc 'hui' > zt3
echo '- zt6'
time -p zstd -T0 --ultra -6zc 'hui' > zt6
echo '- zt20'
time -p zstd -T0 --ultra -20zc 'hui' > zt20
echo '- zt22'
time -p zstd -T0 --ultra -22zc 'hui' > zt22

echo '- xz6'
time -p xz -6zekc -T0 -M100% 'hui' > xz6
echo '- xz8'
time -p xz -8zekc -T0 -M100% 'hui' > xz8
echo '- xz9'
time -p xz -8zekc -T0 -M100% 'hui' > xz9

echo '****'
ls -lS --block-size=M