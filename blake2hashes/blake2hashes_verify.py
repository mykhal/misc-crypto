#!/usr/bin/env python

import hashlib
import re
import sys

rex = re.compile(r'(blake2[a-z]+)-(\d+)\s*\("(.*?)"\)\s*=\s*([0-9a-f]+)')

fails = 0

for line in sys.stdin:

    line = line.strip()

    m = rex.search(line)
    if not m:
        continue

    alg, siz, inp, hsh = m.groups()

    blake = getattr(hashlib, alg, None)
    if not blake:
        print("[skip]", line)
        continue

    h = blake(
            bytes(inp, "ascii"),
            digest_size=int(siz)//8
        ).hexdigest()

    if h != hsh:
        fails += 1
        print("[FAIL]", line)
        continue

    print("[ OK ]", line)


if fails:
    exit(2)
