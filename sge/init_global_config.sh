#!/bin/bash
# Modified from:
# https://docs.oracle.com/cd/E19957-01/820-0698/6ncdvjcmm/index.html

#load_sensor                  /share/apps/hpcscripts/sge/scratch_free.sh
#prolog                       /share/apps/hpcscripts/sge/doscratch.sh make $job_owner
#epilog                       /share/apps/hpcscripts/sge/doscratch.sh clean $job_owner


TMPFILE=/tmp/sched_int.$$
if [ $MOD_SGE ]; then
    grep -Ev "load_sensor|prolog|epilog" $1 >$TMPFILE
    echo "load_sensor                  /share/apps/hpcscripts/sge/scratch_free.sh" >> $TMPFILE
    echo "prolog                       /share/apps/hpcscripts/sge/doscratch.sh make $job_owner" >> $TMPFILE
    echo "epilog                       /share/apps/hpcscripts/sge/doscratch.sh clean $job_owner" >> $TMPFILE
# sleep to ensure modification time changes
    sleep 1
    mv $TMPFILE $1
else
    export EDITOR=$0
    export MOD_SGE=1
    qconf -mconf
fi
