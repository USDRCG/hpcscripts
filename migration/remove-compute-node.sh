#!/bin/bash


[ $# -ne 1 ] && exit 1

node="$1"
if [ $(qstat -u '*' -g t | grep $node | wc -l) -gt 0 ]; then
	echo "$node is still in use"
	exit 1
fi

echo "Removing $node"

for hgrp in `qconf -shgrpl`; do
	qconf -shgrp $hgrp | sed -e "s/$node.local//" >tmp.$$
	qconf -Mhgrp tmp.$$
done

insert-ethers --remove $node

rm -f tmp.$$
