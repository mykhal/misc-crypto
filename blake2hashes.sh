#!/bin/bash

b2exe=${1:-$HOME/src/BLAKE2/b2sum/b2sum}
pyexe=python3

vfypyscript=blake2hashes_verify.py

# blake2s blake2sp blake2b blake2bp
algos=$(exec $b2exe -h 2>&1 | perl -ne 'print join " ", /(blake2\w+)/g if /\[\s?blake2/')

for a in $algos; do
  seq 1 99 | while read i; do
    l=$((8*i))
    o=$(exec $b2exe -a $a -l $l /dev/null 2>/dev/null)
    [ $? -eq 0 ] || break
    printf '%-12s ("") = %s\n' "$a-$l"  "${o%% *}"
  done
done  | \
  { [ -f $vfypyscript ] && exec $pyexe $vfypyscript || cat ; }
