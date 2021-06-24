#!/usr/bin/env python

import hashlib
import re
import sys

rex = re.compile(
    r'''
    (?P<alg> blake2[a-z]+ )
    -
    (?P<len> \d+ )    \s*
    \( "
    (?P<inp> [^"]* )
    " \)               \s*
    =                  \s*
    (?P<hash> [0-9a-f]+ )
    ''',
    re.I | re.X)

fails = 0

for line in sys.stdin:

    line = line.strip()

    m = rex.search(line)
    if not m:
        continue

    d = m.groupdict()
    # d = { k: v.lower() for k, v in m.groupdict().items() }

    blake = getattr(hashlib, d["alg"], None)
    if not blake:
        print("skip", line)
        continue

    h = blake(
            bytes(d["inp"], "ascii"),
            digest_size=int(d["len"])//8
        ).hexdigest()

    if h != d["hash"]:
        fails += 1
        print("FAIL", line)
        continue

    print(" OK ", line)


if fails:
    exit(2)
