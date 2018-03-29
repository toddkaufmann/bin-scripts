#!/bin/bash
# to do:  add inode ?
#  fork repo, add scripts to gather interesting stats etc
HEADER="# version: $0 "'$Revision: 1944 $'
# UUID is meant to be updated whenever file format/header changes
UUID='1A418825-ED2F-4B2E-94B2-33DA497384E9'
# v1.3: UUID='11739C79-F648-4C57-8023-19525165BE21'
# v1.2: UUID='1865F58A-EACA-4FCF-8B29-FCA21ADF9B6F'
ID='$Id: root-find.sh,v 1.3 2011/05/26 21:35:22 todd Exp $'
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
timestamp=`date +%Y%m%d.%H%M`

arg1="$1"
if [ "$arg1" == "" ]; then
  pushd /
  prefix=root
else 
  if pushd "$arg1"; then
    prefix=$(echo "$arg1" | sed -e 's=/$==; s=[ /]=_=g;')
  else
    echo
    echo "** Can't cd to $arg1 -- check arguments"
    echo "** Exit 1"
    echo
    exit 1
  fi
fi
out="$HOME/$prefix.find.$timestamp"

[ -d "$HOME/.logs" ] || mkdir "$HOME/.logs"

scriptlog="$HOME/.logs/root-find"
echo "# $timestamp cwd is : "`pwd`, out is : $out  >> $scriptlog


echo cwd is : `pwd`
echo out is : $out
#exit 0

# output identifying header so we know what format to expect

FS=`df . | tail -1 | sed -e 's/.*[0-9]%  *//' `
# works for OS X:
DEV_UUID=`diskutil info "$FS" | perl -ne 'print "$1\n" if /UUID:\s+(.*)/'`


(echo "$HEADER"; \
 echo "# $UUID"; \
 echo "# run at:" `date` on `hostname`; \
 echo "# Filesystem: $FS :: $DEV_UUID"; \
 echo "# Folder: $(pwd -P)" ) \
 > "$out.out"

# TODO include ino nlinks
#  how can we go faster, and skip stat'ing everything ?
#  cache (in db), only look for dir change and then enumerate.
#  [test:  how many change between ?]
#    changes 'without evidence':  eg add/del, or mv/rename ?
#
time find . -xdev 2>"$out.find-err"  | ~todd/bin/fa stime permbits atimeh ctimeh size 2> "$out.fa-err" >> "$out.out"

popd

if [ "$arg1" == "" ]; then
  if [ -L rf.out ]; then
    echo '# adjusting symlink..'
    rm rf.out
  else
    echo "# creating symlink:  $out.out -> rf.out"
  fi
  ln -s "$out.out" rf.out
fi

echo "$0 $@ " >> $scriptlog
