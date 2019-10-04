#!/bin/sh

exists=$(mktemp /tmp/test.XXXXX)
dne="$exists.does.not"

# mktemp creates a file
# touch $exists

out="$exists.ls"

# Send both stdout and stderr to same place (a file)
ls -l "$exists" "$dne" > "$out"  2>&1
echo ls status:  $?
echo "===="
echo "Redirection proceeds left-to-right:"
echo '$ cmd 2>&1  > afile'
echo ' results in stderr (fd 2) being redirected to stdout (eg console), and stdout to afile'
echo '$ cmd > afile 2>&1  '
echo ' stdout (fd 1) goes to a file, and then stderr goes to the same place.'

# cleanup 
sleep 3
rm "$exists" "$out"

