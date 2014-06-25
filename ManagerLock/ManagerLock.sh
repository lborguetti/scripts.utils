#!/bin/bash

#
# create/remove or check lock file
# Usage: ManagerLock add|del|check lock_file
# Ex   : ManagerLock add /var/run/test

function check_lock(){

	if [ ! -e "$LOCK_FILE" ] ; then
		if [ "$ACTION"x = "checkx" ]; then
			exit 1
		fi
		RETURN=1
	else
		if [ "$ACTION"x = "checkx" ]; then
			exit 0
		fi
		RETURN=0
	fi

}

function create_lock(){

	check_lock 
	if [ "$RETURN"x = "1x" ] ; then
		touch $LOCK_FILE
		exit 0
	else
		exit 1
	fi

}

function remove_lock(){

	check_lock 
	if [ "$RETURN"x = "0x" ] ; then
		rm -f $LOCK_FILE
		exit 0
	else
		exit 1
	fi

}

# start

if [ -n "$1" -a -n "$2" ]; then 
	ACTION=$1
	LOCK_FILE=$2
else
	echo "Usage: ManagerLock [add|del|check] lock_file"
	exit 9
fi

echo "$LOCK_FILE"|grep "var/run" > /dev/null 2>&1
if [ "$?"x != "0x" ] ; then
	echo "Not allowed create or remove $LOCK_FILE"
	exit 666
fi

case $ACTION in 
	add)
		create_lock	;;
	del)
		remove_lock	;;
	check)
		check_lock ;;
	*)
		echo "Usage: ManagerLock [add|del|check] lock_file" ;;
esac
