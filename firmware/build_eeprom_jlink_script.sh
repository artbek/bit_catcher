#!/bin/bash


### FALLINGS BITS ###

VALUES=(
	10000
	01000
	00100
	00010
	00001
	00010
	00100
	01000
)

echo -n "w4 0x08080010 "

for VALUE in ${VALUES[*]}
do
	let dec=$((2#$VALUE))
	printf '0x%08x ' $(($dec << 27))
done

echo


### DIGITS FONT ###

VALUES=(
	01001
	01010
	01001
	01010
	01001
	01010
	11101
	01011
)

echo -n "w4 0x08080200 "

for VALUE in ${VALUES[*]}
do
	let dec=$((2#$VALUE))
	printf '0x%08x ' $(($dec << 27))
done

echo

echo "q"

