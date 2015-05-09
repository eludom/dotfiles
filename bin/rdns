#!/bin/bash
# Do reverse DNS lokup
myhostname=`host $1`
if [ "$?" -eq 0 ]; then
  echo `echo $myhostname | cut -d " " -f 5`
fi
