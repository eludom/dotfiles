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
alias psg='	/bin/ps -auxww | grep'
alias p8='	ping -c 3 8.8.8.8'



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
#    	export VISUAL="emacsclient -t"
#	export EDITOR="emacsclient -t"
#    	alias e='[ "$DISPLAY" == ""] && emacsclient -t || emacsclient -c'
#    elif hash emacs 2>/dev/null; then
#        export ALTERNATE_EDITOR="" # Because I should never have to start emacs
#    	export VISUAL="emacs"
#	export EDITOR="emacs"
#    	alias e='[ "$DISPLAY" == ""] && emacsclient -t || emacsclient -c'
#    else
#        2>& echo BOO no emacs here
#        export ALTERNATE_EDITOR="" # Because I should never have to start emacs
#    	export VISUAL=""
#	export EDITOR=""
#    	unalias e 2>/dev/null || true
#	
#    fi


#
# Do OS-specific setup
#

#if [[ "$OSTYPE" == "linux-gnu" ]]; then
#    color="--color";
#else
#    color=""
#fi

alias ls='	ls '$color' -a'
alias llr=' 	ls -ltr '$color' -a'
alias llrt=' 	ls -ltr '$color' -a | tail'
alias llt=' 	ls -lt '$color' -a'
alias lltm='	ls '$color' -a -lt | more'
alias llth='	ls '$color' -a -lt | head'
alias lss='	ls '$color' -a -1s | sort -n'
alias lssr='	ls '$color' -a -1s | sort -nr'


# See https://github.com/rafmagana/mush
alias bitly='bitly -l `cat ~/creds/bitly.username` -k `cat ~/creds/bitly.key` -u'

complete -C aws_completer aws

# Let somebody know we finished running

touch $HOME/.bashrc-ran
