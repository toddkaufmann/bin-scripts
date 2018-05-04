#!/bin/bash
# to do:  add inode ?
#  fork repo, add scripts to gather interesting stats etc
HEADER="# version: $0 2018.04.30"
# PROG_VERSION_UUID is meant to be updated whenever file format/header changes
PROG_VERSION_UUID='1A418825-ED2F-4B2E-94B2-33DA497384E9'
# v1.3: PROG_VERSION_UUID='11739C79-F648-4C57-8023-19525165BE21'
# v1.2: PROG_VERSION_UUID='1865F58A-EACA-4FCF-8B29-FCA21ADF9B6F'

# HISTORY:
#  root-find.sh,v 1.3 2011/05/26 21:35:22
# 
#
# run with no arguments;
# creates a timestamp'd file of the root filesystem (only -- -xdev)
# containing a list of all filenames and their access/creation times
#
# this is a stopgap until there is a proper program to monitor
# filesystem changes (for which a system OS-level interface exists;
# for OSX/linux at least), however is still useful for gathering a
# snapshot from a remote system.
#

# 11/7  with arg:  is a subdir name and filename prefix instead of root
# 11/23 with arg:  ignore trailing slash, and convert '/' to '_' in output filename.
timestamp=$(date +%Y%m%d.%H%M)

set -eu

#: "${arg1:=/}"
arg1=${1-/}
#echo arg1=$arg1

if [ "$arg1" == "" ] ||  [ "$arg1" == "/" ]; then
    arg1=/
    prefix=root
else
    arg1="$1"
    prefix=$(echo "$arg1" | sed -e 's=/$==; s=/=_=g;')
fi

if ! pushd "$arg1"; then
    echo
    echo "** Can't cd to $arg1 -- check arguments"
    echo "** Exit 1"
    echo
    exit 1
  fi

out="$HOME/$prefix.find.$timestamp"

[ -d "$HOME/.logs" ] || mkdir "$HOME/.logs"

scriptlog="$HOME/.logs/root-find"
echo "# $timestamp cwd is : $(pwd), out is : $out"  >> "$scriptlog"


echo cwd is : "$(pwd)"
echo out is : "$out"
#exit 0

# output identifying header so we know what format to expect

dfline=$(df . | tail -1)
#blkdev=$(echo $dfline | sed -e 's= .*==' )
blkdev=${dfline/ */}
#       $(echo $dfline | sed -e 's= .*==' )
FS=${dfline/*%/}

if [ Darwin = "$(uname -s)" ]; then
  # works for OS X:
  DEV_UUID=$(diskutil info "$blkdev" | perl -ne 'print "$1\n" if /UUID:\s+(.*)/')
else
  DEV_UUID=$(blkid "$blkdev")
fi

(echo "$HEADER"; \
 echo "# $PROG_VERSION_UUID"; \
 echo "# run at: $(date) on $(hostname)"; \
 echo "# Filesystem: $FS :: $DEV_UUID"; \
 echo "# Folder: $(pwd -P)" ) \
 > "$out.out"

time find . -xdev 2>"$out".find-err  | fa stime permbits atimeh ctimeh size 2>"$out".fa-err >> "$out".out 

popd

if [ "$arg1" == "" ]; then
  if [ -L rf.out ]; then
    echo '# adjusting symlink..'
    rm rf.out
  else
    echo "# creating symlink:  $out.out -> rf.out"
  fi
  ln -s "$out".out rf.out
fi

echo "$0 $*" >> "$scriptlog"
