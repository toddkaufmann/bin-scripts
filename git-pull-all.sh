#!/bin/bash

set -eu


function pull-all() {
    for repo in */; do
	if [ -d "$repo/.git" ]; then
	    echo $(date) ============================================ $repo;
	    if cd $repo; then
		if ! git pull; then
		    echo git pull FAIL - $?
		    sleep 2
		else
		    # how to tell if changes ?
		    echo check it out -
		    sleep 1
		    git lol | head
		    echo
		    read -p "<<any char to proceed>> " -n 1
		    echo
		fi
		cd ..;
	    else
		echo "Can't do to $repo ? -- $?"
	    fi;
	else
	    echo $(date) ============================== Not a repo -- $repo;
	fi
    done;
}

pull-all

