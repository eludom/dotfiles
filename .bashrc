#
# GMJ .bashrc
#
# Tue Mar 26 20:07:29 2013 
#

#
# Before anything else, fix the CTRL key !!!
#

if [ -x $HOME/bin/fixctrl.sh ]; then
  $HOME/bin/fixctrl.sh
fi

#
# Generic things
#

export PS1="\# [\t] \u@\h \W/ $ " 

alias  cd='	pushd'
#bind -x '"\C-l": clear;'
alias rm='	rm -i'
alias eg='	printenv | grep -i' 
alias fegi='	find . -print | egrep -i'
alias egi='	egrep -i' 
alias psg='	/bin/ps -auxww | grep'

# Useful functions 

pathadd() {
    if [ -d "$1" ] && [[ ":$PATH:" != *":$1:"* ]]; then
        PATH="${PATH:+"$PATH:"}$1"
    fi
}

# Generic path


pathadd $HOME/bin

#
# Determine location, OS etc.
#

export myOS=
export myLocation=
export myPublicIP=
export myPublicDomainName=

# try to determine location, first by wireless SSIDs, then by reverse DNS

if [ -x $HOME/bin/whatsMyLocation.sh ]; then
  export myLocation=`$HOME/bin/whatsMyLocation.sh`
fi

if [ -x $HOME/bin/whatsMyOS.sh ]; then
  export myOS=`$HOME/bin/whatsMyOS.sh`
fi

if [ -x $HOME/bin/whatsMyPublicIP.sh ]; then
  export myPublicIP=`$HOME/bin/whatsMyPublicIP.sh`
fi

if [ "$myPublicIP" != "" ]; then
  if [ -x $HOME/bin/rdns.sh ]; then
    export myPublicDomainName=`$HOME/bin/rdns.sh $myPublicIP`
  fi
fi

if [ "$myLocation" == "" ]; then
  if [[ "$myPublicDomainName" == *comcast.net* ]]; then
      export myLocation="home"
  fi
fi

if [ "$myLocation" == "work" ]; then
  if [ -f $HOME/.bashrc.atWork ]; then
    . $HOME/.bashrc.atWork
  fi
elif [ "$myLocation" == "home" ]; then
    echo at home
    unset http_proxy
    unset https_proxy
fi


#
# Do location-specific setup
#

if [ `which emacs 2>/dev/null` ]; then
    export VISUAL=emacs
    export EDITOR=emacs
fi

alias emacs='		emacs-snapshot'





#
# Do OS-specific setup
#

if [ "$TERM" == "dumb" ]; then
  color="";
elif [ "$myOS" == "mac" ]; then
  pathadd /opt/local/bin;
  color="-G";
elif [ "$myOS" == "linux" ]; then
  color="--color";
fi

alias ls='	ls '$color' -a'
alias llt=' 	ls -lt '$color' -a'
alias lltm='	ls '$color' -a -lt | more'
alias llth='	ls '$color' -a -lt | head'
alias lss='	ls '$color' -a -1s | sort -n'
alias lssr='	ls '$color' -a -1s | sort -nr'

#
# Set up silk repositories if they exist
#

if [ -f /data/sensors.conf ]; then
    export SILK_DATA_ROOTDIR=/data
    export SILK_IPV6_POLICY=asv4
fi



# Let somebody know we finished running

touch $HOME/.bashrc-ran
