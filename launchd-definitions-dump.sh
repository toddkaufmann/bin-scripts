#!/bin/bash

# Output directory is timestamped YYYYMMDD.HHMM 
timestamp () { 
  date +%Y%m%d.%H%M
}

# TMPDIR not set by default for root on OSX ?
: ${TMPDIR:=/tmp}

outdir="$TMPDIR/launchd.`timestamp`"

if [ -d "$outdir" ]; then
  echo wont overwrite $outdir, wait a min and try again
else
    if mkdir "$outdir"; then
	echo output will be in "$outdir"
    else
	echo FAIL to create  "$outdir"
	exit 1
    fi
fi

cd "$outdir"
launchctl list > list

tail +2  list | cut -f3 \
 | while read lname; do
       if launchctl list "$lname" > "$lname"; then 
	   echo -n .
       else
	   echo failed to list "$lname  ($?)"
       fi
   done
echo
echo ...  results in:  "$outdir"

