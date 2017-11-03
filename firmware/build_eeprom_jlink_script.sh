#!/bin/bash


### FALLINGS BITS ###

SHAPE=(
	1
	2
	4
	8
	16
)

for VALUE in {1..100}
do
	while [[ $i == $prev ]]
	do
		let i=$((RANDOM % 5))
	done

	let prev=i
	printf "%2d, " ${SHAPE[$i]}
done

echo

