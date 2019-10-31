#!/bin/bash

shopt -s extdebug
declare -F | while read foo bar fun ; do declare -F "$fun" ;done
shopt -u extdebug

# you have to source this to really make it work.
