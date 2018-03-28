#!/bin/sh

image="$1"
page=0

while [ $? -eq 0 ]; do
    i=$((i+1));
    sleep 1;
    echo =========== page $i;
    curl -s "https://registry.hub.docker.com/v2/repositories/library/$image/tags/?page=$i" \
	| jq '."results"[]["name"]';
done

