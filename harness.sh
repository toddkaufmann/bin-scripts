#!/bin/sh
# $Id: harness.sh 1059 2013-05-01 05:38:08Z todd $

# Simple test harness for comparing command output.  (With curl, suitable for web stuff.)
# Expects these dirs:
# settings/ - contains names of systems, file has sh env settings that can be used by test scripts
# test/  - dir with commands

# Outputs:
#  ref.name/  - reference output of tests (created first time harness is run)
#  runs/name.n/  - output of test run(s)

# Usage:
#   ./harness.sh  <system>
#   ./harness.sh  <system>  test(s)
#
# <system> is the name of a file in settings/
# test(s) is a list or wildcard matching one or more of the files in the test directory.
#         not specifying tests is equivalent to '*'
#

# Note:  all the test scripts run in the context of this script.
# run it in a sub-shell if it pollutes the environment.

settings="$1"

if [ -z "$settings" ]; then
  echo "usage:  $0 settings  [test(s)]"
  exit 1
fi

shift
tests="$*"
if [ -z "$tests" ]; then
  tests='*'
fi

echo '** check that it exists'
echo =========== loading settings for:  $settings  ============
. settings/$settings

# [ -d ref.$settings ] || mkdir ref.$settings



if [ -d ref.$settings ]; then
# works on linux
#  rundir=runs/$settings.`/bin/ls -d runs/$settings* 2>/dev/null |wc -l`
  rundir=runs/$settings.`/bin/ls -d runs/$settings* 2>/dev/null |wc -l| tr -d [:blank:]`
  thisrun=test
else 
  # this becomes reference
  rundir=ref.$settings
  thisrun=reference
fi

# make sure output dir exists
#
if [ ! -d "$rundir" ]; then
  echo making "$rundir"
  mkdir -p "$rundir"
else
  echo "$rundir" already exists
fi

#
# run each test 
# .. note everything below takes place in the 'test' directory.
#
# A test might also like to use these variables:
#   $rundir   - directory where output is going
#   $testname - name of the test currently being run
#
cd test
for testname in $tests; do
  pushd .
  case "$testname" in
   *~) ;;   # ignore emacs backup files; add other patterns, rules here 
    *) echo `date` ... running $testname
       . ./$testname > ../$rundir/$testname;;
  esac
  popd
done

# compare with reference (if exists)
if [ "$thisrun" = "reference" ]; then
  echo reference output in $rundir
  exit 0
fi

echo ....................... compare time ............
differ=no
for t in $tests; do
  case "$t" in
   *~)  ;;
    *) if [ ! -f ../ref.$settings/$t ]; then
	 echo No reference for this test, it becomes the reference:  in ../ref.$settings/$t
	 cp ../$rundir/$t ../ref.$settings/$t;
       elif ! cmp ../$rundir/$t ../ref.$settings/$t; then
          echo diff $rundir/$t ref.$settings/$t
	  differ=true
       fi;;
  esac
done

if [ $differ = no ]; then
  echo No differences from reference.
  exit 0
else
  echo see difference above.
  exit 1
fi
