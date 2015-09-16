#!/bin/sh

# $ VBoxManage list 
# Usage:
# 
# VBoxManage list [--long|-l] vms|runningvms|ostypes|hostdvds|hostfloppies|
#                             intnets|bridgedifs|hostonlyifs|natnets|dhcpservers|
#                             hostinfo|hostcpuids|hddbackends|hdds|dvds|floppies|
#                             usbhost|usbfilters|systemproperties|extpacks|
#                             groups|webcams

for thing in \
    vms runningvms ostypes hostdvds hostfloppies intnets bridgedifs \
    hostonlyifs natnets dhcpservers hostinfo hostcpuids hddbackends hdds \
    dvds floppies usbhost usbfilters systemproperties extpacks groups \
    webcams \
 ; do
    echo ============================================ $thing
    VBoxManage list $LONG $thing
done
