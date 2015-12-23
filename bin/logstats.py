#!/usr/bin/env python
# -*- coding: utf-8 -*-

"""
Print stats for log files in a list of directories

This program takes a list of log file directories and prints various statistics
for the files in the directories
"""

__author__ = 'George Jones'
__maintainer__ = 'George Jones'
__email__ = 'gmj@pobox.com'
__version__ = '0.0.1'

import optparse
import os
import fnmatch
import sys
from os import path
import time
import gzip

# Setup

def parse_args(argv):
    global optp
    usage = """
        %prog [--quiet] <dir_name> [<dir_name> ...]"""

    # Parse arguments.
    optp = optparse.OptionParser(description=__doc__.strip(), version=__version__,
                             usage=usage)
    optp.add_option('-d', '--debug', help="Print debugging output",
                action='store_true')
    optp.add_option('-q', '--quiet', help="be quiet! (For use with scripts/cron)",
                action='store_true')
    optp.add_option('-n', '--byname', help="Compare file dates lexically by filename, not mtime (not implemetned)",
                action='store_true')        
    optp.add_option('-f', '--files', type='string', action='append',
                    metavar='<files',
                    default="*.log" ,
                    help="files to match (regexp), example: '2015-10-*.log', default: '*.log'")
    (opts, args) = optp.parse_args()

    return opts, args

def p_error(msg=None):
    optp.print_help()
    if msg:
        optp.error(msg)
    sys.exit(1)

def main():

    # Parse arguments

    global opts
    opts, args = parse_args(sys.argv)
    
    if (len(args) == 0):
        p_error("need at least one directory name")
        sys.exit(1)

    if opts.debug:
        print "args", args

    # print header


    print  "|".join(["","dir","totalFiles","totalSize","totalLines","avgRecord","oldestTime","oldestFile","newestTime","newestFile",""])      

    # Enumaerate log files of interest

    for dir in args:

        # initialize totals for this directory

        dirTotalsFiles = 0
        dirTotalsSize = 0
        dirTotalsLines = 0
        dirTotalsOldestTimestamp = 4000000000 # 'Tue Oct  2 03:06:40 2096'. 
                                              # If this code is running after that...
                                              # George Jones <gmj@pobox.com>  Sat Oct 31 10:21:59 2015
        dirTotalsOldestName = ""
        dirTotalsNewestTimestamp = 0
        dirTotalsNewestName = ""

        if opts.debug:
            print "dir", dir

        if not os.path.isdir(dir):
            sys.stderr.write(dir, ' is not a directory, skipping'+ str(e))
            next

        files = [dir + "/" + f for f in os.listdir(dir)  
                 if 
                 (path.isfile(dir + "/" + f) and 
                  (fnmatch.fnmatch(f,opts.files) or
                   fnmatch.fnmatch(f,opts.files + ".*.gz")))]
        if opts.debug:
            print "files", files

        for file in files:
            
            # handle compressed files if requested
            
            # Get direct info about the file

            statinfo = os.stat(file)

            if file.endswith(".gz"):
                num_lines = sum(1 for line in gzip.open(file,'rb'))

                if opts.debug:
                    sys.stderr.write('Compressed file  ' + file + ' has  ' + str(num_lines) + ' lines' + "\n")
                
            else:
                try:
                    num_lines = sum(1 for line in open(file))
                except Exception, e:
                    sys.stderr.write('Unable to count lines in ' + file + ' '+ str(e) + "\n")
                    num_lines = 0


            if opts.debug:
                print "file:", file, "size", statinfo.st_size,  "num_lines", num_lines, "mtime:", time.ctime(statinfo.st_mtime)

            # compute derived statistics about the file

            if num_lines > 0:
                avgLineSize = statinfo.st_size / num_lines
            else:
                avgLineSize = 0

            # Add info to summary list

            dirTotalsFiles += 1
            dirTotalsSize += statinfo.st_size
            dirTotalsLines += num_lines

            # keep track of oldest and newest files

            if opts.byname:
                if dirTotalsOldestName == "" or file < dirTotalsOldestName:
                    if opts.debug:
                        print "New Oldest File ", file
                    dirTotalsOldestName = file
                    dirTotalsOldestTimestamp = 0

                if dirTotalsNewestName == "" or file > dirTotalsNewestName:
                    if opts.debug:
                        print "New Newest File ", file
                    dirTotalsNewestName = file
                    dirTotalsNewestTimestamp = 0
                    
            else:
                if statinfo.st_mtime < dirTotalsOldestTimestamp:
                    if opts.debug:
                        print statinfo.st_mtime, "<", dirTotalsOldestTimestamp
                        print "New Oldest Timestamp: ", dirTotalsOldestTimestamp                
                    dirTotalsOldestTimestamp = statinfo.st_mtime
                    dirTotalsOldestName = file


                if statinfo.st_mtime > dirTotalsNewestTimestamp:
                    if opts.debug:
                        print statinfo.st_mtime, ">", dirTotalsNewestTimestamp
                        print "New Newest Timestamp: ", dirTotalsNewestTimestamp                
                    dirTotalsNewestTimestamp = statinfo.st_mtime
                    dirTotalsNewestName = file

        # compute derived statistics about the directory

        if dirTotalsLines > 0:
            dirAvgRecord = dirTotalsSize / dirTotalsLines
        else:
            dirAvgRecord = 0

        # print directory summary
        
        print "|".join(["",dir, str(dirTotalsFiles),str(dirTotalsSize),str(dirTotalsLines),str(dirAvgRecord),time.ctime(dirTotalsOldestTimestamp),dirTotalsOldestName,time.ctime(dirTotalsNewestTimestamp),dirTotalsNewestName,""])

if __name__ == '__main__':
    main()
