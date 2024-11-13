#!/usr/bin/env python3

from hashlib import sha256

file = "zx"
sha = sha256()
with open(file, "rb", buffering=0) as f:
    f.read()
    print(sha.hexdigest())
