#!/bin/sh

# As root..
dev=$1

# assume a baseline of 10M/s, we'll run for about a minute
blocksize=$[ 1024 * 1024 ]
count=600

time dd if=/dev/r$dev bs=1m count=600 | pv -s $[ count * blocksize ] > /dev/null
