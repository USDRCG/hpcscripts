#!/bin/bash

# Compute nodes 17-23
# 17 was done manually already, so this script migrates 18-23

#insert-ethers --cabinet 0 --rank 18 --membership compute

#rocks set host interface ip compute-0-X iface=eth2 ip=172.20.151.233
#rocks set host interface subnet compute-0-X iface=eth2 subnet=storage
#rocks set host interface ip compute-0-X iface=eth0 ip=10.0.255.253
#rocks set host interface subnet compute-0-X iface=eth0 subnet=private
#rocks sync host network compute-0-X

#rocks set host bootflags compute-0-X flags="console=tty0 console=ttyS0,115200"
#rocks set host installaction compute-0-X action="install remcons"
#ssh compute-0-X "/boot/kickstart/cluster-kickstart"

[ $# -ne 1 ] && exit 1

num="$1"

storage_ip=$((251-$num))
compute_ip=$(())


echo
echo "First, run insert-ethers as follows:"
echo "insert-ethers --cabinet 0 --rank $num --membership compute"
echo
echo "Once the node is installed, run:"
echo "rocks set host sec_attr compute-0-$num attr=root_pw"
echo "rocks sync host sec_attr compute-0-$num"
echo
echo "ssh compute-0-$num /share/apps/hpcscripts/migration/enable-serial-console.sh"
echo
echo "rocks set host interface ip compute-0-$num iface=eth2 ip=172.20.151.$storage_ip"
echo "rocks set host interface subnet compute-0-$num iface=eth2 subnet=storage"
echo "rocks list host interface compute-0-$num | grep private | awk '{ print \$4}'"
echo "rocks set host interface ip compute-0-$num iface=eth0 ip=XXX"
echo "rocks set host interface subnet compute-0-$num iface=eth0 subnet=private"

echo
echo "rocks set host bootflags compute-0-$num flags=\"console=tty0 console=ttyS0,115200\""
echo "rocks set host installaction compute-0-$num action=\"install remcons\""
echo

echo
echo "NOTE: Arrange compute and storage network cables."
echo
echo "rocks sync host network compute-0-$num"
echo "ssh compute-0-$num \"/boot/kickstart/cluster-kickstart\""

