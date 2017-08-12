#! /bin/bash
# Symlink everything in this directory into a corresponding directory in $HOME
#
# - create a directory in $HOME with the same name as this directory
# - link all files in this directory in the new directory
# - exclude files listed in link2home.exclue

set -e -u

# Helper functions
PROG=`basename "$0" | tr -d '\n'`

function info()  { echo ${PROG}\: info: "$@" 1>&2; }
function warn()  { echo ${PROG}\: warning: "$@" 1>&2; }
function error() { echo ${PROG}\: error: "$@" 1>&2; }
function debug() { [[ -v DEBUG ]] && echo ${PROG}\: debug: "$@" 1>&2 || true ; }
function die()   { echo ${PROG}\: fatal: "$@" 1>&2 && exit 1; }

#
# Command line parsing
#

function usage() {
    debug "in ${FUNCNAME[0]}"

    if [[ "$#" -gt 0 ]]; then
	warn $@
    fi

    cat <<END 1>&2
Usage: ${PROG} [options]

   options

     -d|--debug         debug output
     -r|--remove        remove old files
     -v|--verbose       verbose output

END
    exit 1
}


# parse global options

for i in "$@"
do
    case $i in
	-d|--debug)
	    DEBUG=1
	    d_flag="-d"
	    shift # past argument with no value
	    ;;
	-r|--remove)
	    REMOVE=1
	    # remove old files
	    shift # past argument with no value
	    ;;
	-v|--verbose)
	    VERBOSE=1
	    v_flag="-v"
	    shift # past argument with no value
	    ;;
	-*|--*)
	    usage "Unknown state option: $i"
	    ;;
    esac
done

# Pull off command line args

if [ "$#" -ge 1 ]; then
    usage "No arguments expected"
fi

# Get abolute path to directory of current file
#REALDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
# use current directory
REALDIR=`pwd`

# Extract the directory name of this file
BASEDIR=`basename $REALDIR`

# create name of directory in $HOME
HOMEDIR="${HOME}/${BASEDIR}"

# crate the directory name in $HOME if DNE
mkdir -p "${HOMEDIR}"

#
# symlink everything here to $HOME
#
cd "${REALDIR}"

# get exception list
declare -A EXCLUSIONS

if [ -f 'link2home.exclude' ]; then
    for exclude in `cat link2home.exclude`; do
	EXCLUSIONS["${exclude}"]="${exclude}"
    done
fi

#for file in * .[a-z]*; do
for file in * .[a-z]*; do

    SOURCE="${REALDIR}/${file}"
    TARGET="${HOMEDIR}/${file}"

    [ -f "${file}" ] || continue

    if [ ${EXCLUSIONS["${file}"]+DNE} ]; then
	info skip "${file}"
    else

	if [ -v REMOVE ]; then
	    rm -f "${HOMEDIR}/${file}"
	    [[ -v VERBOSE ]] &&  info rm -f "${TARGET}"
	fi

	if [ -h "${TARGET}" ]; then
	    [[ -v VERBOSE ]] &&  info "${TARGET}" already exists. Skipping.
	else
	    ln -s "${SOURCE}"  "${HOMEDIR}" || warn "Unable to link ${SOURCE}"
	    [[ -v VERBOSE ]] &&  info ln -s "${SOURCE}" "${HOMEDIR}"

	fi

    fi


done
