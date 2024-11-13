#!/usr/bin/env python3

from hashlib import sha256

hui = sha256()
with open("./zx", "rb") as x:
    dt = x.read()
    hui.update(dt)

print(hui.hexdigest)
