#!/bin/bash

# Wrapper script which adds '--debug' to sam command as appropriate

set -eu

cmd="$1"
shift

function logger() {
    local LOGFILE=~/.logs/sam-wrapper 
    if [ -f $LOGFILE ]; then
	# echo "$(date) $0 $*" >> $LOGFILE
	echo "$(date) $0 $@" >> $LOGFILE
    fi
    echo "$(date) $0 $*"
}

case "$cmd" in
    --info)
	# '--info' returns json parsed by some IDEs, outputing extra text will break Pycharm/sam
	# as of 2021-06-04 I have:  {"version": "1.23.0"} 
	exec /usr/local/bin/sam $cmd
	;;
    *)
	# For 'local' commands, --debug flag must come after sub-command.
	if [ "$cmd" == "local" ]; then
	    subcmd="$1"
	    shift
	    cmd="$cmd $subcmd"
	fi
	# redundant ?  we log do it later?
	logger " 0003 New sam command is:" /usr/local/bin/sam $cmd --debug "$@"
	# echo "/usr/local/bin/sam $cmd --debug" "$@"
	# : shift
	;;
esac



# separate concern:  python path / warning from 
# echo ======================  Which python:
logger ======================  Which python: $(which python)
if false; then
    echo ====================== with venv -
    source  ~/SYNC/dev-SHARED/pipenvs/bag_identifier/bin/activate
    which python
    python --version
fi

# quoting seems wrong -- 
# exec /usr/local/bin/sam $cmd --debug "$@"
# ->
# /Volumes/tk_cAsE/bin/sam-wrapper.sh local invoke S3EventFilterFunction --template /Volumes/tk_cAsE/git/S3EventFilterExecCommandLambda/.aws-sam/build/template.yaml --event "/private/var/folders/kz/73bxqchd1rsbxvyvc98dnmch0000gn/T/[Local] S3Event - x.not-bag-event.json" --debug-port 60006 --debugger-path /Applications/PyCharm.app/Contents/plugins/python/helpers/pydev --debug-args "-u /tmp/lambci_debug_files/pydevd.py --multiprocess --port 60006 --file"
# New sam command is:
# /usr/local/bin/sam local invoke --debug "invoke S3EventFilterFunction --template /Volumes/tk_cAsE/git/S3EventFilterExecCommandLambda/.aws-sam/build/template.yaml --event /private/var/folders/kz/73bxqchd1rsbxvyvc98dnmch0000gn/T/[Local] S3Event - x.not-bag-event.json --debug-port 60006 --debugger-path /Applications/PyCharm.app/Contents/plugins/python/helpers/pydev --debug-args -u /tmp/lambci_debug_files/pydevd.py --multiprocess --port 60006 --file"

function c_arg() { echo "$c: $*"; c=$((c+1)); }

# echo '============ just $@'
# c=1; for a in $@; do c_arg $a; done
# .. difference between $* $@ "$@" is hard ..
echo '============ arg breakdown - quoted: "$@"'
c=1; for a in "$@"; do c_arg $a; done

echo '====================== DOIT (exec): '
logger "exec /usr/local/bin/sam $cmd --debug $@"
exec /usr/local/bin/sam $cmd --debug "$@"

# fixed shift/subcmd --
