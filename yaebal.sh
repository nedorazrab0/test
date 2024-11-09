#!/usr/bin/env bash

mkdir ./z
cd ./z

curl -ZLo 'hui' 'https://download.fedoraproject.org/pub/fedora/linux/releases/41/Everything/x86_64/iso/Fedora-Everything-netinst-x86_64-41-1.4.iso'

echo '- xz9'
time -p xz -9zekvc -T0 -M100% 'hui' > xz9
echo '- xz8'
time -p xz -8zekvc -T0 -M100% 'hui' > xz8
echo '- xz6'
time -p xz -6zekvc -T0 -M100% 'hui' > xz6

echo '- zt22'
time -p zstd -T0 --ultra -22zvc 'hui' > zt22
echo '- zt20'
time -p zstd -T0 --ultra -20zvc 'hui' > zt20
echo '- zt3'
time -p zstd -T0 --ultra -3zvc 'hui' > zt3
echo '- zt1'
time -p zstd -T0 --ultra -1zvc 'hui' > zt1

echo '- lz12'
time -p lz4 -12zvc 'hui' > lz12
echo '- lz9'
time -p lz4 -9zvc 'hui' > lz9
echo '- lz6'
time -p lz4 -6zvc 'hui' > lz6
echo '- lz3'
time -p lz4 -6zvc 'hui' > lz3
echo '- lz1'
time -p lz4 -1zvc 'hui' > lz1


echo '- zp9'
time -p zip -9v - 'hui' > zp9
echo '- zp8'
time -p zip -8v - 'hui' > zp8
echo '- zp6'
time -p zip -v - 'hui' > zp6

echo '- za9'
time -p 7za a - 'hui' -mx9 > za9
echo '- za8'
time -p 7za a - 'hui' -mx8 > za8
echo '- za6'
time -p 7za a - 'hui' -mx6 > za6

echo '****'
ls -l
echo '****'
ls -lh
