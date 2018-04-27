#!/bin/bash

# TODO:  parse args, check two supplied
# select ignore-dirs or not

set -eu

function tgz-diff() {
    local tgz1="$1"
    local tgz2="$2"
    
    diff <(tar ztvf  $tgz1) \
	 <(tar ztvf  $tgz2)
}

function tgz-diff-ignore-dirs() {
    local tgz1="$1"
    local tgz2="$2"
    
    diff <(tar ztvf $tgz1 | grep -v '^drwxrwxr-x ') \
	 <(tar ztvf $tgz2 | grep -v '^drwxrwxr-x ')
}

# usually dirs only matter w/ times, and if anything of import there will probably be files involved.
echo CMD: tgz-diff "$1" "$2"
 tgz-diff "$1" "$2"
echo  tgz-diff status: $?
echo --
echo CMD: tgz-diff-ignore-dirs "$1" "$2"
tgz-diff-ignore-dirs "$1" "$2"
echo  tgz-diff-ignore-dirs status: $?
