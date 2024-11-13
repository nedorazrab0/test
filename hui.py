#!/usr/bin/env python3

import hashlib

def csha256(file_path):
    sha256_hash = hashlib.sha256()
    with open(file_path, "rb") as f:
        for byte_block in iter(lambda: f.read(524288), b""):
            sha256_hash.update(byte_block)
    return sha256_hash.hexdigest()

csha256("zx")
