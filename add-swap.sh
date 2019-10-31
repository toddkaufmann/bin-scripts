#!/bin/sh

# quickly add a swapfile, fstab entry, and turn it on.

# size, in MB's
size=2048
swapfile=/swap.${size}M.$$

dd if=/dev/zero bs=1M count=$size of=$swapfile
mkswap $swapfile
echo "$swapfile   none  swap  sw  0  0" >> /etc/fstab
swapon -a
