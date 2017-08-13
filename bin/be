#! /bin/bash
# change aws, ssh and gpg credentials
#
# Usage
#
#   be [options] NAME
#   be [options] --whoami
#   be [options] --list
#
#  e.g.
#
#   If  ~/.gnupg.$1 exists, link to ~/.gnupg
#   If  ~/.ssh/id_{dsa,rsa}.$1 exists, link to ~/.ssh/id_{dsa,rsa} and add to ssh agent
#   If  ~/.aws/credentials.$1 exists, link to ~/.aws/credentials
#
# TODO
#  - Add gpg identities
#  - Switch pass(1) databases/identities
#  - Deal with .pem files

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

     -a|--aws		change/list aws credentials ONLY
     -d|--debug         debug output
     -g|--gnupg		change/list gnupgcredentials ONLY
     -l|--list		list availabe credentials.
     -s|--ssh		change/list ssh credentials ONLY
     -v|--verbose       verbose output
     -w|--whoami        list current identities

END
    exit 1
}

function gpg_list() {
    # list available gpg credentail sets (diretories)
    info available GPG credentials sets
    ls -ld ~/.gnupg.*
}

function gpg_whoami() {
    # list current gpg identity
    info Current gpg credential set
    ls -ld ~/.gnupg
}

function gpg_become() {
    # change gpg identity
    rm -f ~/.gnupg || true
    ln -s ~/.gnupg."${who}" ~/.gnupg
}

function aws_list() {
    # list available aws credentials
    cd ~/.aws || die "Error connecting to ~/.aws"

    info available AWS credentials and configs
    ls -1 credentials.* config.*
}

function aws_whoami() {
    # list current aws identity
    cd ~/.aws || die "Error connecting to ~/.aws"

    info Current aws credentials
    ls -l credentials config
}

function aws_become() {
    # change aws identity
    cd ~/.aws || die "Error connecting to ~/.aws"

    aws_creds="credentials.""${who}"
    if [ ! -f "${aws_creds}"  ]; then
	warn file "${aws_creds}" does not exist.  Not changing aws identity.
    else
	[[ -v VERBOSE ]] && set -x
	rm -f credentials || true
	ln -s "${aws_creds}" credentials
	[[ -v VERBOSE ]] && set +x
    fi

    aws_config="config.""${who}"
    if [ ! -f "${aws_config}"  ]; then
	warn file "${aws_config}" does not exist.  Not installing.
    else
	[[ -v VERBOSE ]] && set -x
	rm -f config || true
	ln -s "${aws_config}" config
	[[ -v VERBOSE ]] && set +x
    fi
}


function ssh_list() {
    # list available ssh credentials
    cd ~/.ssh || die "Error connecting to ~/.ssh"

    info available SSH credentials
    ls -1 id_rsa.* id_dsa.*
}

function ssh_whoami() {
    # list current ssh identity
    cd ~/.ssh || die "Error connecting to ~/.ssh"

    info Current SSH identities
    ls -l id_???  || warn "no ~/.ssh/id_{rsa,dsa} file"
    info SSH Agent Identities
    ssh-add -l
}

function ssh_become() {
    # change ssh identity
    cd ~/.ssh || die "Error connecting to ~/.ssh"

    rsa_creds="id_rsa.""${who}"
    dsa_creds="id_dsa.""${who}"

    if [ -f "${dsa_creds}" ]; then
	ssh_creds="${dsa_creds}"
    elif [ -f "${rsa_creds}" ]; then
	ssh_creds="${rsa_creds}"
    else
	echo "No ssh creds found. "${rsa_creds}" and "${dsa_creds}" do not exis."
	exit 1
    fi

    target=`basename $ssh_creds ".""${who}"`

    if [ -f "${ssh_creds}"  ]; then
	[[ -v VERBOSE ]] && set +x
	rm -f "${target}" || true
	ln -s "${ssh_creds}" "${target}"
	chmod 400 "${target}"
	ssh-add "${ssh_creds}"
	[[ -v VERBOSE ]] && set -x
    fi
}


#
# "main()" begins here
#

# Defaults
SSH=1
AWS=1
GPG=1



# parse global options

for i in "$@"
do
    case $i in
	-a|--aws)
	    AWS=1
	    unset SSH
	    unset GPG
	    d_flag="-d"
	    shift # past argument with no value
	    ;;
	-d|--debug)
	    DEBUG=1
	    d_flag="-d"
	    shift # past argument with no value
	    ;;
	-g|--gnupg)
	    GNUPG=1
	    unset AWS
	    unset SSH
	    g_flag="-g"
	    shift # past argument with no value
	    ;;
	-l|--list)
	    LIST=1
	    d_flag="-d"
	    shift # past argument with no value
	    ;;
	-s|--ssh)
	    SSH=1
	    unset AWS
	    unset GPG
	    d_flag="-d"
	    shift # past argument with no value
	    ;;
	-v|--verbose)
	    VERBOSE=1
	    v_flag="-v"
	    shift # past argument with no value
	    ;;

	-w|--whoami)
	    WHOAMI=1
	    v_flag="-v"
	    shift # past argument with no value
	    ;;
	-*|--*)
	    usage "Unknown state option: $i"
	    ;;
    esac
done

# Pull off command line args

if [[ !  -v LIST  && ! -v WHOAMI ]]; then
    if [ "$#" -ne 1 ]; then
	usage need a username
    fi

    who="${1}"
fi

if [[ ! -v SSH && ! -v AWS && ! -v GPG ]]; then
    die "Must specify at least one of '--aws' and '--ssh' and '--gnupg'"
fi

# Change aws credentials

if [ -v AWS ]; then

    if [[ -v LIST ]]; then
	aws_list
    elif [[ -v WHOAMI ]]; then
	aws_whoami
    else
	aws_become
    fi
fi

# Change ssh credentials

if [ -v SSH ]; then

    if [[ -v LIST ]]; then
	ssh_list
    elif [[ -v WHOAMI ]]; then
	ssh_whoami
    else
	ssh_become
    fi
fi

# Change ssh credentials

if [ -v GPG ]; then

    if [[ -v LIST ]]; then
	gpg_list
    elif [[ -v WHOAMI ]]; then
	gpg_whoami
    else
	gpg_become
    fi
fi
