#!/bin/sh

# install xpra on yakkety (16.10)
# instructions from the website
# makes assumptions..

if [ "$EUID" != "0" ]; then
   echo try again, as root
   exit 1
fi

set -e
set -u

codename=$(lsb_release -s -c)
if [ "$codename" != "yakkety" ]; then
    echo "I don't know how to handle '$codename' yet; "
    echo "you can try the steps manually or use them to help you find answers online."
    echo "If you have updates/fixes, send them to me.  Thanks."
    exit 1
fi
curl http://winswitch.org/gpg.asc | apt-key add -

echo "deb http://winswitch.org/ yakkety main" > /etc/apt/sources.list.d/winswitch.list;
apt-get install software-properties-common >& /dev/null;
#add-apt-repository universe >& /dev/null;
add-apt-repository universe
apt-get update;
#apt-get install winswitch
apt-get install xpra
