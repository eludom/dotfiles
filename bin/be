#! /bin/bash
# change aws and ssh credentials
#
# If  ~/.aws/credentials.$1 exists, copy to ~/.aws/credentials
# If  ~/.ssh/id_{dsa,rsa}.$1 exists, copy to ~/.ssh/id_{dsa,rsa}
#
# exists.  It is copied to

set -e; set -u

# Helper functions
PROG=`basename "$0" | tr -d '\n'`

function info()  { echo ${PROG}\: info: "$@" 1>&2; }
function warn()  { echo ${PROG}\: warning: "$@" 1>&2; }
function error() { echo ${PROG}\: error: "$@" 1>&2; }
function debug() { [[ -v DEBUG ]] && echo ${PROG}\: debug: "$@" 1>&2 || true ; }
function die()   { echo ${PROG}\: fatal: "$@" 1>&2 && exit 1; }

function usage() {
    debug "in ${FUNCNAME[0]}"

    if [[ "$#" -gt 0 ]]; then
	warn $@
    fi

    cat <<END 1>&2
Usage: ${PROG} [options] who

   arguments
     who	       name of identity

   options

     -a|--aws		change/list aws credentials
     -d|--debug         debug output
     -l|--list		list availabe credentials.
     -s|--ssh		change/list ssh credentials
     -v|--verbose       verbose output

END
    exit 1
}


# parse global options

for i in "$@"
do
    case $i in
	-a|--aws)
	    AWS=1
	    d_flag="-d"
	    shift # past argument with no value
	    ;;
	-d|--debug)
	    DEBUG=1
	    d_flag="-d"
	    shift # past argument with no value
	    ;;
	-l|--list)
	    LIST=1
	    d_flag="-d"
	    shift # past argument with no value
	    ;;
	-s|--ssh)
	    SSH=1
	    d_flag="-d"
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

if [[ !  -v LIST ]]; then
    if [ "$#" -ne 1 ]; then
	usage need a username
    fi

    who="${1}"
fi

if [[ ! -v SSH && ! -v AWS ]]; then
    die "Must specify at least one of '--aws' and '--ssh'"
fi


# Change aws credentials

if [ -v AWS ]; then

    cd ~/.aws || die "Error connecting to ~/.aws"


    if [[ -v LIST ]]; then
	info available AWS credentials
	ls credentials.*
    else
	aws_creds="credentials.""${who}"
	if [ ! -f "${aws_creds}"  ]; then
	    warn file "${aws_creds}" does not exist.  Not changing aws identity.
	else
	    [[ -v VERBOSE ]] && set -x
	    cp "${aws_creds}" credentials
	    [[ -v VERBOSE ]] && set +x
	fi
    fi
fi

# Change ssh credentials

if [ -v SSH ]; then

    cd ~/.ssh || die "Error connecting to ~/.ssh"

    if [[ -v LIST ]]; then
	info available SSH credentials
	ls -1 id_rsa.* id_dsa.*
    else
	rsa_creds="id_rsa.""${who}"
	dsa_creds="id_dsa.""${who}"


	if [ -f "${dsa_creds}" ]; then
	    ssh_creds="${dsa_creds}"
	elif [ -f "${rsa_creds}" ]; then
	    ssh_creds="${rsa_creds}"
	else
	    echo "No ssh creds found."
	fi

	target=`basename $ssh_creds ".""${who}"`

	if [ -f "${ssh_creds}"  ]; then
	    [[ -v VERBOSE ]] && set +x
	    cp "${ssh_creds}" "${target}"
	    chmod 400 "${target}"
	    [[ -v VERBOSE ]] && set -x
	fi
    fi
fi
