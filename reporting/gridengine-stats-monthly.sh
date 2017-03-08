#!/bin/bash

#YEARS="09 10 11 12 13"
#YEARS="09 10"
YEARS="14"
#MONTHS="01 02 03 04 05 06 07 08 09 10 11 12"
MONTHS="01 02 03 04 05 06 07 08 09 10"
BEGIN_T="0000"
END_T="2359"



for y in $YEARS; do
	echo "20${y}";
for m in $MONTHS; do
	echo -n -e "$m"
	END_M=31
	if [ "$m" == "02" ]; then
		END_M="28"
	elif [ "$m" == "04" ] || [ "$m" == "06" ] || [ "$m" == "09" ] || [ "$m" == "11" ]; then
		EMD_M="30"
	fi

	BEGIN="${m}01${BEGIN_T}"
	END="${m}${END_M}${END_T}"

#	echo -n -e "Total jobs:\t\t"
#	tj=`qacct -j -b ${y}$BEGIN -e ${y}$END 2>/dev/null | \
#	    grep jobnumber | awk '{print $2}' |\
#	    sort | uniq | wc -l`
#	echo "$tj"
#
#	echo -n "Avg jobs per day: "
#	echo $(($tj/365)) 
#
#	echo "CPU-hr allocation by job size (cores):"
#	echo -e "\tCores\tCPU-hrs"
#	qacct -b ${y}$BEGIN -e ${y}$END -slots 2>/dev/null\
#	| grep -v "SLOTS" | grep -v "=" |\
#	awk '{print "\t",$1,"\t", $5}' | sort -r -n -k2
#
#	# Average job times
#	qacct -j -b ${y}$BEGIN -e ${y}$END 2>/dev/null\
#	| ./avgjobstats.pl
#
	alloc=`qacct -j -b ${y}$BEGIN -e ${y}$END 2>/dev/null \
	| tail -n1 \
	| awk '{print $4/3600}'`

	cap=$((296*$END_M*24))


#	echo -n -e "CPU-hours Allocated:\t"
#	echo -e "Actual CPU-hour capacity:\t$cap"
	echo -e ",$alloc,$cap"

#	echo "CPU-hour Allocation by User:"
#	nUsers=0
#	for u in `qacct -j -b ${y}$BEGIN -e ${y}$END 2>/dev/null | grep owner | sort | uniq | awk '{print $2}'`; do
#			  qacct -o $u -b ${y}$BEGIN -e ${y}$END 2>/dev/null \
#			  | tail -n1 | awk '{print "\t",$1,"\t",$5/3600}'; 
#			  nUsers=$(($nUsers+1))
##	done
#
#	echo "Total users: $nUsers"
#
done
	echo
done

