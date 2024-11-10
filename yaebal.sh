#!/usr/bin/env bash

mkdir ./z
cd ./z

curl -ZLo 'hui' 'https://geo.mirror.pkgbuild.com/iso/2024.11.01/archlinux-2024.11.01-x86_64.iso'
echo '****'

echo '- zp8'
zip -8v - hui > zp8
sleep 1

echo '- za7'
time -p 7za a -tzip za7 'hui' -mx7
sleep 1

echo '****'
ls -lS --block-size=M