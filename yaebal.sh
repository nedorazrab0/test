#!/usr/bin/env bash

mkdir ./z
cd ./z

curl -ZLo 'hui' 'https://geo.mirror.pkgbuild.com/iso/2024.11.01/archlinux-2024.11.01-x86_64.iso'
echo '****'

time -p 7za a -tzip za 'hui' -mx7

echo za
time -p 7za x z/za.zip
sleep 1

