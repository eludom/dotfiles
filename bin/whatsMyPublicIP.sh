#! /bin/bash
# script to determine my public IP address

# deal with timeouts?
#myIP=`dig +short @resolver1.opendns.com myip.opendns.com`
myIP=`curl -s ifconfig.me`
echo "$myIP"

