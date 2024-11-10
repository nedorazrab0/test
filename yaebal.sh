#!/usr/bin/env bash

mkdir ./z
cd ./z

curl -ZLo 'hui' 'https://geo.mirror.pkgbuild.com/iso/2024.11.01/archlinux-2024.11.01-x86_64.iso'
echo '****'

7za a -tzip za 'hui' -mx7

rm -f hui
echo za
time -p 7za x za.zip
sleep 1

