#!/bin/sh

# urn like:
#  $0 *.gz
#  $0 *.tar.gz

# for each .gz file, will create a .7z file.
# you delete .gz yourself if you what
# example command is output when all done.

set -eu

# works will with *sql.gz
for f in "$@"; do
    sq=$(basename "$f" .gz)
    zcat "$f" > "$sq"
    ls -l "$sq"
    time 7zr a "$sq.7z" "$sq"
    rm "$sq"
    # mv $sq.7z OLD
done

echo '# All done.  Cleanup with:'

echo
echo 'for f in  *.gz; do sq=$(basename "$f" .gz); if [ -f  "$sq".7z ]; then  rm -v "$f"; fi; done'
echo

# echo $(timestamp) status $?
