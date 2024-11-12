#!/usr/bin/env bash
set +e


sudo apt install libarchive-tools
bsdtar --version
command -v bsdtat
ls -lhL $(which bsdtar)
