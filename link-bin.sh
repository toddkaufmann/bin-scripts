#!/bin/sh

for f in ../git/bin-scripts/* ; do if [ -x $f ] ; then [ ! -f $(basename $f) ] && ln -s $f . && echo added: $f;  echo is line $f; else echo is not ex $f; fi; done
