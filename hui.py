#!/usr/bin/env python3

from hashlib import file_digest

with open("zx", 'rb') as x:
    print(file_digest(x, 'sha256').hexdigest())
