#!/bin/sh

# Create symbolic links to executable files in multiple directories.
# The file in $DIRLIST should contain a list of directories.
# $DIRLIST defaults to 'linker.dirs' in the current directory but can be overridden on command line.

# In some cases it's better to have multiple different dirs on your path.
# That might require updating many shell/environments, logout/login, etc.
# Maybe best of both worlds is to link temporarily, and add paths for later.
# 

# Notes:
# - only +x scripts;  some scripts may depend on data being in the same dir where the executable is;
# if you link the script you may need to link in the data manually
# (depends how the script is written).
#
# If there's any name overlap in your dirs, it's first come, first serve.


# Default name, but can be overridden in the env.
# this file has one dir per line.  '#' at beginning of line will comment it out.
: ${DIRLIST:="linker.dirs"}
#

if [ ! -f "$DIRLIST" ]; then
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
    echo "$*" >> "$LINKING_LOG"
}
log "# $(date) - $0 invoked" 

echo '# you can undo all these links with by executing this script:'
echo "sh $LINKING_LOG"
sleep 1

grep -v '^#' "$DIRLIST" | \
 while read dir; do
     if [ -d "$dir" ]; then 
	 echo "============ processing $dir ..."
	 log "# - processing dir=$dir"
	 for f in "$dir"/* ; do 
	     if [ -x "$f" ] && [ -f "$f" ] ;  then
		 base=$(basename "$f")
		 if [ ! -e "$base" ]; then
		     if ln -s "$f" . ; then
			 echo "added: $f"; 
			 log "rm ./'$base'"
		     else
			 lnstatus=$?
			 echo "error linking ($lnstatus)"
			 log  "# error linking $f ($lnstatus)"
		     fi
		 else 
		     log "#  .. is already here:  $f"
		 fi
	     else 
		 echo "(is not +x:  $f"
	     fi
	 done
     else
	 echo "X X X  dir does not exist: $dir"
     fi
done 

echo
echo '# you can undo all these links (if any) by executing this script:'
echo "sh $LINKING_LOG"



