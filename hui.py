#!/usr/bin/env python3

from hashlib import sha256

file = "zx"
sha = sha256()
with open(file, "rb", buffering=0) as f:
    while sha := f.readinto(65536):
        sha.update(ch)
    print(sha.hexdigest())
