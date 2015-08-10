#!/bin/bash
version='$Id: how-long.sh 1997 2015-07-20 12:09:33Z todd $'

# given pid, log and see how long it takes 
pid=$1

logdir=$HOME/.logs
[ -d "$logdir" ] || mkdir "$logdir"


timestamp=`date +%Y%m%d.%H%M%S`

# a log of all invocations (and completion to end)
scriptlogall="$logdir/how-long"
# scriptlogall="$logdir/how-long.TEST"

# temp log for just this run--to be appended to scriptlogall on completion.
# this allows for multiple invocations to occur simultaneously 
# without interleaved output.
scriptlog="$scriptlogall.$pid.$timestamp"

# and temp file, for the last ps output
# just a line (or two), which we'll add to the log
TEMPOUT=`mktemp "$scriptlog.$pid.tmpXXX"`
# no mktemp?  this is probably fine:
# TEMPOUT=$scriptlog.$pid.tmp

running() {  ps -p$pid> "$TEMPOUT.x" && cp "$TEMPOUT.x" "$TEMPOUT"; }
cleanup() {  rm -f "$TEMPOUT" "$TEMPOUT.x"; }
trap cleanup EXIT

# before we go any farther make sure we have the right process / still running.
#if ! kill -0 $pid; then ... #  - only if you own it.
#if ! pgrep -F <(echo $pid); then
if ! running; then
  echo "$pid is not / no longer running"
  # cleanup
  exit 1
fi


t0=`date +%s`

(echo "# $timestamp :: $version"; \
 echo "# wd: " `/bin/pwd`; \
 echo "# $pid is being watched"; \
 ps -p$pid -l; ps -p$pid -f; \
  )            >> $scriptlog

# while kill -0 $pid; do 
#while pgrep -F <(echo $pid) > /dev/null; do
while running; do
  sleep 10;   
done
t1=`date +%s`
timestamp=`date +%Y%m%d.%H%M%S`
(echo "# $timestamp done: $pid"; \
 cat "$TEMPOUT"; \
 echo $[t1-t0] 'seconds elapsed (at least)';echo )   >> $scriptlog

cat $scriptlog >> $scriptlogall  &&  rm  $scriptlog

#cleanup