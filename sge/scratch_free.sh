#!/bin/bash

declare -r HOST=`uname -n`

while [ 1 ]; do
# wait for input
	read input
	result="$?"

	if [ "$result" != "0" ]; then
		exit 1 # read failed
	fi

	if [ "$input" = "quit" ]; then
		exit 0
	fi

# got something other than 'quit'
	sf=`df -h /scratch/ | grep -v Filesystem | awk '{print $4}'`
	echo "begin"
	echo "$HOST:scratch_free:$sf"
	echo "end"
done

#never!
exit 0
