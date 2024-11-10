#!/usr/bin/env bash

mkdir ./z
cd ./z

curl -ZLo 'hui' 'https://geo.mirror.pkgbuild.com/iso/2024.11.01/archlinux-2024.11.01-x86_64.iso'
echo '****'

echo 'b1'
brotli -1vc 'hui' > b¹
sleep 1
echo 'b3'
brotli -3vc 'hui' > b3
sleep 1
echo 'b6'
brotli -6vc 'hui' > b6
sleep 1
echo 'b9'
brotli -9vc 'hui' > b9
sleep 1
echo 'b10'
brotli -q10 -vc 'hui' > b10
sleep 1
echo 'b11'
brotli -Zvc 'hui' > b11
sleep 1

echo '- za6'
time -p 7za a -t zip za6 'hui' -mx6
echo '- za8'
time -p 7za a -t zip za8 'hui' -mx8
echo '- za9'
time -p 7za a -t zip za9 'hui' -mx9


echo '****'
ls -lS --block-size=M