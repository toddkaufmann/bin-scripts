#!/bin/bash

# As root..
dev=$1

# assume a baseline of 10M/s, we'll run for about a minute
blocksize=$[ 1024 * 1024 ]
count=600

# 1m or 1M ?

if dd count=1 if=/dev/null of=/dev/null bs=1M >/dev/null 2>&1; then
    onemeg=1M;
else
    if dd count=1 if=/dev/null of=/dev/null bs=1m >/dev/null 2>&1; then
	onemeg=1m;
    else
	echo "dd is wonky and doesn't know megabytes?  Sorry."
	exit 1
    fi
fi

# now, which device?

if [ -b "$dev" ]; then
    disk="$dev";
elif [ -b /dev/$dev ]; then
    disk=/dev/$dev;
elif [ -b /dev/r$dev ]; then
    disk=/dev/r$dev;
else
    echo name your disk
    exit 1
fi

time dd if=$disk bs=$onemeg count=600 | pv -s $[ count * blocksize ] > /dev/null
