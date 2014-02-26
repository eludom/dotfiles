#! /bin/sh
# WHAT: find files modified in the current directory and subdirectories in a given range of days.
#
# WHY: I use this to find files I've been working on in a given date range.
#
# USAGE:
#	modified [oldest [youngest]]
#
#         - oldest is the oldest modtime to include.  Default 7.
#         - youngest is the youngest modtime to  include.  Default 0.
#
# EXAMPLES:
#	Show the files modified in the last week.
#
#	  $ modified
#
#       Show the files modified last week
#
#	  $ modified 14 7
#
#       Show fils modified 3 weeks ago
#
#         $ modified 28 21
#
# NOTES:
#	Filenames with a space (" ") in them are a problem.  
#       For now, we use "*" to match spaces.
#
# TODO:
#       - Do something better for filenames with spaces.
#       - Use some flavor of getopt
#         + Allow specification of atime
#	  + Allow specification of directory and filename
#          
#
# HISTORY
#	gmj@pobox.com - 2014-02-26 - created.


# usecomand line args, or supply defaults
OLDEST=${1:-7}
YOUNGEST=${2:-0}

ls -ltd `find . -mtime +${YOUNGEST} -mtime -${OLDEST} -print | sed 's/ /*/g'`
