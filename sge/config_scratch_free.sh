#!/bin/bash

for host in `qhost | awk 'NR>3 {print $1}'`; do
	echo $host
	total=`ssh $host "df -h /scratch" | awk 'NR>1{print $2}'`
	qconf -aattr exechost complex_values scratch_free=$total $host
done
