#!/usr/bin/env python3

from hashlib import sha256

with open(zx, 'rb', buffering=0) as f:
    hashlib.file_digest(f, 'sha256').hexdigest()
