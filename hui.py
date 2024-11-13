#!/usr/bin/env python3

import hashlib

def csha256(file_path):
    sha256_hash = hashlib.sha256()
    with open(file_path, "rb", buffering=0) as f:
        for byte_block in iter(lambda: f.read(1048576), b""):
            sha256_hash.update(byte_block)
    return print(sha256_hash.hexdigest())

csha256("zx")
