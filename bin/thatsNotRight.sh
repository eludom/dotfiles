1#! /bin/bash
# Create a report about Things That Are Not Right on my home Ubuntu system.
#
# Usage:
#
#	thatsNotRight.sh 
#
# Inputs:
#
# Outputs:
#	output on stdout for logging, mailing, grepping, etc.
#
#
# Author: Geroge Jones
# Date: 2014-11-16
#

#
# When is this run ?
#

#
# uptime
#
# Start simple with a (nonroot) cron like this
#
#   6 * * * *  uptime >> ${HOME}/log/$(date +\%Y\%m\%d)_uptime.log
#
# then parse the output (should be 24 entries/day)
# For more fancy solutions, see http://stackoverflow.com/questions/79490/linux-uptime-history 

updateLogfile=/home/george/log/$(date +\%Y\%m\%d)_uptime.log
wc -l ${updateLogfile=} | sed 's/^/UptimeCount: /g'

#
# System reboots 
#

last reboot | sed 's/^/lastReboot: /g'

#
# Bad login attempts
#
# Thanks to http://securitasdato.blogspot.com/2010/01/fun-with-lastb.html
#

lastb -i -a | head -20 | sed 's/^/lastb: /g'

# Reporting bad behavior
#
# Possibly participate here http://www.blocklist.de/en/index.html
#


