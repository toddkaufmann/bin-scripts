#!/bin/sh

# in some cases it's better to have multiple different dirs on your path.
# that could require updating many shell/environments (maybe), logout/login.
# .. so maybe best of both works is to link temporarily, and add paths for later.
# 

# notes:
# - only +x scripts;  some (mine) depend on data being in the same dir where the executable is;
# if you link the script you will need to link in the data (manually)
#
# if there's any name overlap in your dirs, it's first come, first serve.


# default name, but can be overridden in the env.
# this file has one dir per line.  '#' at beginning of line will comment it out.
: ${DIRLIST:=linker.dirs}
#

if [ ! -f $DIRLIST ]; then
    echo
    echo Usage:
    echo you have to at least on dir in "$DIRLIST; or run like:"
    echo "	DIRLIST=another-dir.list  $0"
    echo "	DIRLIST=<(echo ../this-dir-once)   $0"
    exit 1
fi

# this seems to work on both linux and OSX (bsd)
#LINKING_LOG=`mktemp -t linking.XXXX`
LINKING_LOG="./.linker.sh-$(date +%Y%m%d.%H%M)"

log() {
    echo $* >> "$LINKING_LOG"
}
log "# $(date) - $0 invoked" 

echo '# you can undo all these links with by executing this script:'
echo "sh $LINKING_LOG"
sleep 1

grep -v '^#' "$DIRLIST" | \
 while read dir; do
     if [ -d "$dir" ]; then 
	 echo ============ processing $dir ...
	 log "# - processing dir=$dir"
	 for f in "$dir"/* ; do 
	     if [ -x $f ] ;  then
		 base=$(basename $f)
		 if [ ! -f "$base" ]; then
		     if ln -s $f . ; then
			 echo added: $f; 
			 log "rm ./'$base'"
		     else 
			 echo "error linking ($?)"
		     fi
		 else 
		     echo .. is already here: "$f"; 
		 fi
	     else 
		 echo "(is not +x:  $f"
	     fi
	 done
     else
	 echo "X X X  dir does not exist: $dir"
     fi
done 

echo '# you can undo all these links with by executing this script:'
echo "sh $LINKING_LOG"



