#!/bin/bash

YEARS="09 10 11 12 13 14"
YEARS="15"
BEGIN="01010000"
END="12312359"

for y in $YEARS; do
	echo "20${y}";

	echo -n -e "Total jobs:\t\t"
	tj=`qacct -j -b ${y}$BEGIN -e ${y}$END 2>/dev/null | \
	    grep jobnumber | awk '{print $2}' |\
	    sort | uniq | wc -l`
	echo "$tj"

	echo -n "Avg jobs per day: "
	echo $(($tj/365)) 

	echo "CPU-hr allocation by job size (cores):"
	echo -e "\tCores\tCPU-hrs"
	qacct -b ${y}$BEGIN -e ${y}$END -slots 2>/dev/null\
	| grep -v "SLOTS" | grep -v "=" |\
	awk '{print "\t",$1,"\t", $5}' | sort -r -n -k2

	# Average job times
	qacct -j -b ${y}$BEGIN -e ${y}$END 2>/dev/null\
	| ./avgjobstats.pl

	echo -n -e "CPU-hours Allocated:\t"
	qacct -j -b ${y}$BEGIN -e ${y}$END 2>/dev/null \
	| tail -n1 \
	| awk '{print $4/3600}'

	echo "CPU-hour Allocation by User:"
	nUsers=0
	for u in `qacct -j -b ${y}$BEGIN -e ${y}$END 2>/dev/null | grep owner | sort | uniq | awk '{print $2}'`; do
			  qacct -o $u -b ${y}$BEGIN -e ${y}$END 2>/dev/null \
			  | tail -n1 | awk '{print "\t",$1,"\t",$5/3600}'; 
			  nUsers=$(($nUsers+1))
	done

	echo "Total users: $nUsers"

	echo
done

