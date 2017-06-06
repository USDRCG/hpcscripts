#!/bin/bash

# Compute nodes 24-30

[ $# -ne 1 ] && exit 1

num="$1"

storage_ip=$((249-$num))

echo
echo "First, run insert-ethers as follows:"
echo "insert-ethers --cabinet 0 --rank $num --membership compute"
echo
echo "Once the node is installed, run:"
echo "rocks set host sec_attr compute-0-$num attr=root_pw"
echo "rocks sync host sec_attr compute-0-$num"
echo
#echo "rocks list host interface compute-0-$num | grep private | awk '{ print \$4}'"
#echo
#echo "rocks set host interface ip compute-0-$num iface=eth0 ip=XXX"
#echo "rocks set host interface subnet compute-0-$num iface=eth0 subnet=private"
echo
echo "rocks set host interface ip compute-0-$num iface=eth1 ip=172.20.151.$storage_ip"
echo "rocks set host interface subnet compute-0-$num iface=eth1 subnet=storage"
echo "rocks sync host network compute-0-$num"
echo "sleep 60"
echo
echo "ssh compute-0-$num ls /share/apps/"
echo "ssh compute-0-$num /share/apps/hpcscripts/migration/enable-serial-console.sh"
echo "rocks set host bootflags compute-0-$num flags=\"console=tty0 console=ttyS0,115200\""
echo "rocks set host installaction compute-0-$num action=\"install remcons\""
echo
echo "ssh compute-0-$num \"/boot/kickstart/cluster-kickstart\""
echo
