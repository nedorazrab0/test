#!/usr/bin/env python3

import hashlib

with open("zx", 'rb') as x:
    print(hashlib.file_digest(x, 'sha256').hexdigest())
