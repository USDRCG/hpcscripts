#!/bin/bash

mode="$1"
username="$2"
jobid="$3"


[ $# -ne 3 ] && exit 1

SCRATCH="/scratch/$username/$jobid"

if [ "$SGE_TASK_ID" != "undefined" ]; then
        SCRATCH=$SCRATCH.$SGE_TASK_ID
fi

echo "SCRATCH=$SCRATCH" >> $SGE_JOB_SPOOL_DIR/environment

exit 0
