#!/bin/bash

set -eu


function pull-all() {
    for repo in */; do
	if [ -d "$repo/.git" ]; then
	    echo $(date) ============================================ $repo;
	    if cd $repo; then
		if ! git fetch; then
		    echo git fetch FAIL - $?
		    sleep 2
		else
		    # how to tell if changes ?
		    if git status -uno  | grep 'Your branch is up to date'; then
			echo up to date ...................................;
		    else
			echo check it out -
			sleep 1
			if ! git pull; then
			    echo pull FAIL -  $?
			fi
			echo
			git lol | head
			echo
			read -p " << any char to proceed>> " -n 1
		    fi
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

