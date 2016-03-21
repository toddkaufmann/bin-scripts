#!/bin/bash
# adjust volume
# for OSX
# from:  http://apple.stackexchange.com/questions/19146/is-fine-volume-adjustment-possible-in-os-x-lion

usage()
{
    echo 1>&2 "Usage:" "$0" "[relative volume change in the range -100..100 (default -2)]"
    exit -1
}

case $# in
    0)
        VOLCHANGE=-2
        ;;
    1)
        VOLCHANGE=$1
        ;;
    *)
        usage
        ;;
esac

## Check the VOLCHANGE parameter.
if ! ( echo "${VOLCHANGE}" | egrep '^-?[0-9]+$' > /dev/null )
then
    echo 1>&2 "ERROR: Bad volume adjustment parameter:" "${VOLCHANGE}"
    usage
fi

osascript -e "set volume output volume ((output volume of (get volume settings)) + ${VOLCHANGE})"

echo "New volume:" $(osascript -e 'output volume of (get volume settings)') "(adjusted by ${VOLCHANGE})"
