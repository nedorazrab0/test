#!/usr/bin/env python3

from hashlib import sha256

with open("./zx", "rb") as f:
    f.read()
    print(sha256(f).hexdigest)
