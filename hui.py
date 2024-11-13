#!/usr/bin/env python3

import hashlib

with open("./zx", 'rb', buffering=0) as f:
    print(hashlib.file_digest(f, 'sha256').hexdigest())
