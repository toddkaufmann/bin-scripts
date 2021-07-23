#!/bin/bash

# https://unix.stackexchange.com/questions/41571/what-is-the-difference-between-and/41595#41595

# run like this:
# $0 "a" "a b" "a b c"

function c_arg() { echo "$c: $*"; }

echo '============ just $@'
c=1; for a in $@; do c_arg $a; done

echo '============ quoted: "$@"'
c=1; for a in "$@"; do c_arg $a; done

echo '============ just $*'
c=1; for a in $*; do c_arg $a; done

echo '============ quoted: "$*"'
c=1; for a in "$*"; do c_arg $a; done
