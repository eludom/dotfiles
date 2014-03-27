#! /bin/bash

# log command line invocation and then invoke the origianl command
#
# Usage:
#
#   mv foo foo.orig
#   ln -s logCommand.sh foo
#
# where foo is some executable, then
#
#  foo
#
# and
#
#  tail ${HOME}/logCommand.log
#
# to see command arguments.
#
# HISTORY:
#    <2014-04-01 Tue>, George Jones, crteated.

logTo=${HOME}/logCommand.log

cmdName=${0}.orig

touch $logTo
echo `date` ${cmdName} is about to execute  ${cmdName} $*  >> $logTo
$cmdName $*



