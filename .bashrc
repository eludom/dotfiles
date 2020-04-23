#
# GMJ .bashrc
#
# Tue Mar 26 20:07:29 2013
#
#
# Don't do this unless you are testing.
#
#    set -e
#
#

# Helper functions
PROG=`basename "$0" | tr -d '\n'`

function info()  { echo ${PROG}\: info: "$@" 1>&2; }
function warn()  { echo ${PROG}\: warning: "$@" 1>&2; }
function error() { echo ${PROG}\: error: "$@" 1>&2; }
function debug() { [[ -v DEBUG ]] && echo ${PROG}\: debug: "$@" 1>&2 || true ; }
function die()   { echo ${PROG}\: fatal: "$@" 1>&2 && exit 1; }

#
# Generic things
#


export PS1="\# [\t] \u@\h \W/ $ "

alias  cd='	pushd'
#bind -x '"\C-l": clear;'
alias rm='	rm -i'
alias ag='	alias | grep -i'
alias eg='	printenv | grep -i'
alias hg='	history | grep -i'
alias ht='	history | tail'
alias fegi='	find . -print | egrep -i'
alias egi='	egrep -i'
alias oi='      offlineimap'
alias psg='	/bin/ps -auxww | grep'
alias p8='	ping -c 3 8.8.8.8'

# aliases (functions) that take srgs

function hgt() {
    # hgt == "history grep (for arg) tail"
    #echo "Histroy Grep tail"

    if [ -z ${1+x} ]; then
        echo 'hgt needs an argument' 1>&2
        return 1
    fi

    history | grep -i "$1" | tail
    return 0
}


# Set HOSTNAME if ~/etc/hostname exists

if [ -e ${HOME}/etc/hostname ]; then
    export HOSTNAME=`cat ${HOME}/etc/hostname`
elif [ -e /etc/hostname ]; then
    export HOSTNAME=`cat /etc/hostname`
else
    export HOSTNAME="unknown"
fi



# Set timezone if ~/bin/tz.sh exists

if [ -e ~/bin/tz.sh ]; then
  echo Setting timezone.
  source ~/bin/tz.sh
fi

# Set local for numeric output
LOCAL=`locale -a | grep -i en_us | head -1`
if [[ "$LOCAL" != "" ]]; then export LC_NUMERIC="$LOCAL"; fi

# set up ssh agent
#
# Add keys by hand if needed via
#
#   ssh-add ~/.ssh/id_*

if [ -e ~/bin/sshagent ]; then
  #echo Starting SSH agent
  source ~/bin/sshagent
fi

# git stuff

alias glm='git ls-files -m'
alias gam='git add `git ls-files -m`'
alias gcm='git commit -m'
alias gs='git status'

# Add git stuff to prompt

# http://thelucid.com/2008/12/02/git-setting-up-a-remote-repository-and-doing-an-initial-push/
function git-branch-name {
  git symbolic-ref HEAD 2>/dev/null | cut -d"/" -f 3
}
function git-branch-prompt {
  local branch=`git-branch-name`
  if [ $branch ]; then printf " [%s]" $branch; fi
}

# because hosnames assigned by IT deperments like abc123456789ef are not meaningful
function prompt-hostname {
  local branch=`git-branch-name`
  if [ -f ~/etc/hostname ]; then head -1 ~/etc/hostname; elif [ -f /etc/hostname ]; then head -1 /etc/hostname; else echo STUPIDMAC; fi
}

export PS1="\# [\t] \u@\h \W/\$(git-branch-prompt) $ "
PS1="\u@\$(prompt-hostname) \[\033[0;36m\]\W\[\033[0m\]\[\033[0;32m\]\$(git-branch-prompt)\[\033[0m\] \$ "

# Preserve history across sesssions
#
# http://unix.stackexchange.com/questions/1288/preserve-bash-history-in-multiple-terminal-windows
#
export HISTCONTROL=ignoredups:erasedups  # no duplicate entries
export HISTSIZE=100000                   # big big history
export HISTFILESIZE=100000               # big big history
shopt -s histappend                      # append to history, don't overwrite it

# Save and reload the history after each command finishes
#export PROMPT_COMMAND="history -a; history -c; history -r; $PROMPT_COMMAND"
export PROMPT_COMMAND="history -a; history -c; history -r;"

# Useful functions

# remove an item from the path
pathrm() {
    if [ -d "$1" ]; then
        #echo 1 $1
        removeThis="`echo $1 | sed -e 's#/#\\\/#'g`"
        newPath=`echo $PATH | awk -v RS=: -v ORS=: "/$removeThis/ {next} {print}" | sed 's/[ :]*$//g'`
        export PATH=$newPath
    fi
}


# add path to the end if not there
pathlast() {
    if [ -d "$1" ] && [[ ":$PATH:" != *":$1:"* ]]; then
        #echo  pathlast $1
        export PATH="${PATH:+"$PATH:"}$1"
    fi
}

# add path to the front if not there
pathfirst() {
    if [ -d "$1" ] && [[ ":$PATH:" != *":$1:"* ]]; then
        #echo  pathfirst $1
        export PATH="$1:${PATH}"
    fi
}

# show path
path() {
    echo $PATH
}

# show path, one entry per line
alias pathcat="echo $PATH | sed 's/:/\n/g'"


# Be sure we have a few specific paths if they exist

pathlast $HOME/bin
pathlast /opt/bin
pathlast /usr/local/bin
pathlast /opt/bin

#
# Execute any .sh files in ~/rc.local/*.sh
#

if [ -d ${HOME}/rc.local ]; then
    for rcfile in $(find ${HOME}/rc.local -name \*.sh); do
        #echo running localrc ${rcfile}
        source ${rcfile}
    done
fi

#
# Invoking emacs
#

alias emacs='setsid emacs'

# from http://stuff-things.net/2014/12/16/working-with-emacsclient/

if [ -z "$SSH_CONNECTION" ]; then
   export EMACSCLIENT=emacsclient
   alias ec="$EMACSCLIENT -c -n"
   export EDITOR="$EMACSCLIENT -c"
   export ALTERNATE_EDITOR=""
else
    export EDITOR=$(type -P emacs || type -P vim || type -P vi)
fi
export VISUAL=$EDITOR

# http://stackoverflow.com/questions/592620/check-if-a-program-exists-from-a-bash-script

#    if hash emacsclient 2>/dev/null; then
#        # http://stackoverflow.com/questions/5570451/how-to-start-emacs-server-only-if-it-is-not-started
#        export ALTERNATE_EDITOR="" # Because I should never have to start emacs
#	export VISUAL="emacsclient -t"
#	export EDITOR="emacsclient -t"
#	alias e='[ "$DISPLAY" == ""] && emacsclient -t || emacsclient -c'
#    elif hash emacs 2>/dev/null; then
#        export ALTERNATE_EDITOR="" # Because I should never have to start emacs
#	export VISUAL="emacs"
#	export EDITOR="emacs"
#	alias e='[ "$DISPLAY" == ""] && emacsclient -t || emacsclient -c'
#    else
#        2>& echo BOO no emacs here
#        export ALTERNATE_EDITOR="" # Because I should never have to start emacs
#	export VISUAL=""
#	export EDITOR=""
#	unalias e 2>/dev/null || true
#
#    fi


#
# Do OS-specific setup
#


#
# ls aliases
#

# coloring for ls functions

if [[ "$OSTYPE" == "linux-gnu" ]]; then
    # This works on terminals, piped to cat, tail etc
    # This fails piped to more, less etc
    # color="--color";
    #
    # Always omits color
    # color="--color=never"
    #
    # This works when piped to less, more
    # color="--color=auto"
    #
    # Probably want different settings of 'color='
    # based on intend output (terminal, more/less).
    #
    # Need to fix/test this gmj <2018-05-18>

     color="--color";
    #color=""
else
    color=""
fi

BIN_LS=/bin/ls


alias ls='	ls '$color' -a'

#
# NOTE/TODO: <2018-07-10> commented out function versions of ls
# commands were an attempt at allowing different versions of ls
# for directories other than $PWD.  Needs work.  "ls *" fails.
#

# List
# Usage: ls [DIR]
# function ls {
#     DIR=${1:-.};
#     $BIN_LS $color -a $DIR;
# }


alias llrt='	ls -ltr '$color' -a | tail'
# Long List Reverse Tail
# Usage: llrt [DIR]
# function llrt {
#     DIR=${1:-.};
#     $BIN_LS $color -a -ltr $DIR | tail
# }


#alias llt='	ls -lt '$color' -a'
# Long List Time
# Usage: llt [DIR]
# function llt {
#     set -x
#     echo LLT2
#     DIR=${1:-.}
#     $BIN_LS $color -a -lt $DIR
#     set +x
# }
function llt() { ls -lt $color ${1:-} ${2:-}; }

#alias lltm='	ls '$color' -a -lt | more'
# Long List Time, More
# Usage: lltm [DIR]
# function lltm {
#     DIR=${1:-.};
#     $BIN_LS $color -a -lt $DIR | more;
# }
function lltm() { ls -lt $color ${1:-} ${2:-} | more; }

alias lltl='	ls '$color' -a -lt | less'
# Long List Time, Less
# Usage: lltl [DIR]
# function lltl {
#     DIR=${1:-.};
#     $BIN_LS $color -a -lt $DIR | less;
# }

#alias llth='	ls '$color' -a -lt | head'
# Long List Time, Head
# Usage: llth [DIR [LINES]]
# function llth {
#     DIR=${1:-.};
#     LINES=${2:-10};
#     $BIN_LS $color -a -lt $DIR | head -$LINES;
# }
function llth() { ls -lt $color ${1:-} ${2:-} | head; }

alias lltt='	ls '$color' -a -lt | tail'
# Long List Time, Tail
# Usage: lltt [DIR [LINES]]
# function lltt {
#     DIR=${1:-.};
#     LINES=${2:-10};
#     $BIN_LS $color -a -lt $DIR | tail -$LINES;
# }

alias lss='	ls '$color' -a -1s | sort -n'
# List Sort Size
# Usage: lss [DIR]
# function lss {
#     DIR=${1:-.};
#     $BIN_LS $color -a -1s $DIR | sort -n
# }

alias lssr='	ls '$color' -a -1s | sort -nr'
# List Sort Size Reverse
# Usage: lssr [DIR]
# function lssr {
#     DIR=${1:-.};
#     $BIN_LS $color -a -1s $DIR | sort -nr
# }

# Aliases for viewing the newest file in a directoy
# TODO replace ls with find -type f

function nf() { ls -1t `find . -type f` | head -1; } # list newest file


# list the newest file in the current directory
# TODO: need to handle spaces in filenames
function nf() {
    \ls -1t `find . -maxdepth 1 -type f`  | \
        head -1 | \
        sed 's/\.\./\/dev\/null/' ; \
        }

alias nftf='tail -f `nf`' # tail follow newest file
alias nft='tail `nf`'    # tail newest file
alias nfh='head `nf`'    # head newest file
alias nfl='less `nf`'    # less newest file
alias nfc='cat `nf`'     # cat newest file
alias nfls='ls -A1t `nf`'  # ls newest file, excluding .
alias nflsl='ls -Atl `nf`' # ls newest file, long


# alias for viewing files
if [[  ! -z "`which xdg-open`" ]]; then alias open='xdg-open '; fi

# Let somebody know we finished running

touch $HOME/.bashrc-ran

# added by Anaconda3 installer
#export PATH="/home/gmj/anaconda3/bin:$PATH"
