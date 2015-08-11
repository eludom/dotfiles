#! /bin/bash
# Fix control keys on X or linux console

set -e; set -u; echo "$0: `date;`" 

# Fix in X

if [ -x /usr/bin/setxkbmap ]; then

    set +e
    /usr/bin/setxkbmap 2> /dev/null

    if [ $? -eq 0 ]; then
      set -e

      echo "$0: found display.  Setting ctrl:nocaps"
      setxkbmap -option 'ctrl:nocaps'
    fi
fi

# Fix on Linux console

if [ -x /usr/bin/dumpkeys ]; then

    set +e
    /usr/bin/dumpkeys &> /dev/null
    if [ $? -eq 0 ]; then
        set -e
	cd ~
	dumpkeys | head -1 > fixctl.map

	if [ $? -eq 0 ]; then 
	    echo "$0: found console.  loadkeys keycode 58 = Control"
	    echo "keycode 58 = Control" >> fixctl.map
            sudo loadkeys < fixctl.map
	else
	    echo $0: not on console >&2
	fi    
    fi
fi





