#/bin/sh
version='$Id: root-du.sh 1148 2013-06-22 19:58:38Z todd $'

cd /
timestamp=`date +%Y%m%d.%H%M`

(echo "# $version"; \
 echo "# output produced: " `date`; \
 \ls -d */ .??*/ \
  | egrep -v '^dev|^Volumes' \
  | sed -e 's=/==; s= =\\ =g' \
  | xargs time du -k -x ) \
> du.$timestamp

