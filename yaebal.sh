#!/usr/bin/env bash

mkdir ./z
cd ./z

curl -ZLo 'hui' 'https://geo.mirror.pkgbuild.com/iso/2024.11.01/archlinux-2024.11.01-x86_64.iso'
echo '****'

echo '- lz1'
time -p lz4 -1zc 'hui' > lz1
echo '- lz3'
time -p lz4 -3zc 'hui' > lz3
echo '- lz6'
time -p lz4 -6zc 'hui' > lz6
echo '- lz9'
time -p lz4 -9zc 'hui' > lz9
echo '- lz12'
time -p lz4 -12zc 'hui' > lz12

echo '- zp6'
time -p zip -6 - 'hui' > zp6
echo '- zp8'
time -p zip -8 - 'hui' > zp8
echo '- zp9'
time -p zip -9 - 'hui' > zp9

echo '- za6'
time -p 7za a za6 'hui' -mx6
echo '- za8'
time -p 7za a za8 'hui' -mx8
echo '- za9'
time -p 7za a za9 'hui' -mx9

echo '- zt1'
time -p zstd -T0 --ultra -1zc 'hui' > zt1
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
ls -lh
