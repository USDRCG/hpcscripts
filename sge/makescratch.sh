#!/bin/bash

# Create $SCRATCH dir

mode="$1"
username="$2"
jobid="$3"


[ $# -ne 3 ] && exit 1

SCRATCH="/scratch/$username/$jobid"

if [ "$SGE_TASK_ID" != "undefined" ]; then
        SCRATCH=$SCRATCH.$SGE_TASK_ID
fi

if [ "$mode" == "make" ]; then
	cmd="/bin/mkdir -p $SCRATCH"
elif [ "$mode" == "clean" ]; then
	cmd="/bin/rm -Rf $SCRATCH"
else
	exit 2
fi

if [ -z "$PE_HOSTFILE" ]; then
	$cmd
else
	for hst in `grep -E '^compute-[0-9]+-[0-9]+' $PE_HOSTFILE | cut -d' ' -f1`; do
		ssh $hst "$cmd"
	done
fi

exit 0
