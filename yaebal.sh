#!/usr/bin/env bash

mkdir ./z
cd ./z

curl -ZLo 'hui' 'https://geo.mirror.pkgbuild.com/iso/2024.11.01/archlinux-2024.11.01-x86_64.iso'
echo '****'

time -p zip -9 - hui > zp
time -p 7za a -tzip za 'hui' -mx7

cd ..
echo zp
time -p unzip z/zp
sleep 1

echo za
time -p 7za x z/za.zip
sleep 1

