#! /bin/bash
# Symlink everything in this directory into a corresponding directory in $HOME
#
# - create a directory in $HOME with the same name as this directory
# - link all files in this directory in the new directory
# - exclude files listed in .ignore

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
     -h|--home          link directly to $HOME
     -l|--linkdir       symlink directory itself
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
	-l|--linkdir)
	    LINKDIR=1
	    d_flag="-d"
	    shift # past argument with no value
	    ;;
	-h|--home)
	    TOHOME=1
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
WHERE_AM_I=`pwd`

# Extract the directory name of this file
BASEDIR=`basename $WHERE_AM_I`

# create name of directory in $HOME

if [[ -v TOHOME ]]; then
    DIR_IN_HOME="${HOME}"
else
    DIR_IN_HOME="${HOME}/${BASEDIR}"
fi

if [[ -v LINKDIR ]]; then

    if [ -v REMOVE ]; then

	if [[ "${HOME}" == "${DIR_IN_HOME}" ]]; then
	    [[ -v VERBOSE ]] &&  info not removing "${HOME}"
	else
  	  rm -f "${DIR_IN_HOME}"
	  [[ -v VERBOSE ]] &&  info rm -f "${DIR_IN_HOME}"
        fi
    fi

    [[ -v VERBOSE ]] &&  info ln -s "${WHERE_AM_I}" "${DIR_IN_HOME}"
    ln -s "${WHERE_AM_I}"  "${DIR_IN_HOME}" || warn "Unable to link ${WHERE_AM_I}"

    exit 0
else
    # crate the directory name in $HOME if DNE
    mkdir -p "${DIR_IN_HOME}"
fi

#
# symlink everything here to $HOME
#
cd "${WHERE_AM_I}"

# get exception list
declare -A EXCLUSIONS

if [ -f '.ignore' ]; then
    for exclude in `cat .ignore`; do
	EXCLUSIONS["${exclude}"]="${exclude}"
    done
fi

#for file in * .[a-z]*; do
for file in * .[a-z0-9A-Z_\-]*; do

    SOURCE="${WHERE_AM_I}/${file}"
    TARGET="${DIR_IN_HOME}/${file}"

    [ -e "${file}" ] || continue

    if [ ${EXCLUSIONS["${file}"]+DNE} ]; then
	info skiping "${file}"
    else

	if [ -v REMOVE ]; then

	    [[ -v VERBOSE ]] &&  info rm -f "${DIR_IN_HOME}/${file}"
	    rm -f "${DIR_IN_HOME}/${file}"
	fi

	if [ -h "${TARGET}" ]; then
	    [[ -v VERBOSE ]] &&  info "${TARGET}" already exists. Skipping.
	else
	    [[ -v VERBOSE ]] &&  info ln -s "${SOURCE}" "${DIR_IN_HOME}"
	    ln -s "${SOURCE}"  "${DIR_IN_HOME}" || warn "Unable to link ${SOURCE}"
	fi

    fi


done
