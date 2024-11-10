#!/usr/bin/env bash

mkdir ./z
cd ./z

curl -ZLo 'hui' 'https://geo.mirror.pkgbuild.com/iso/2024.11.01/archlinux-2024.11.01-x86_64.iso'
echo '****'

echo '- zp 9'
zip -9v - hui > zp9
sleep 1

echo '- za6'
time -p 7za a -tzip za6 'hui' -mx6
echo '- za8'
time -p 7za a -tzip za8 'hui' -mx8
echo '- za9'
time -p 7za a -tzip za9 'hui' -mx9


echo '****'
ls -lS --block-size=M