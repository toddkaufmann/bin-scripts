#!/bin/sh

for i in "$@"; do
    case "$i" in
	*.mkv)
	    mp4="${i%.mkv}.mp4"
	    if [ -f "$mp4" ]; then
		echo wont overwrite
		exit 1;
	    fi
	    echo cmd is:
	    echo ffmpeg -i "$i" -vcodec copy -acodec copy $mp4;
	    time ffmpeg -i "$i" -vcodec copy -acodec copy $mp4;
	    ;;
	*)
	    echo
	    echo dont know what to do with - "$i"
	    echo
	    ;;
    esac   
		       
done
