#!/bin/bash

rocks add network admin subnet=192.168.10.0 netmask=255.255.255.0 mtu=1500

# Sun X4100 Nodes use Channel 1

rocks add host interface login-0-0 ipmi ip=192.168.10.140 name=ipmi-login-0-0 subnet=admin
rocks set host interface channel login-0-0 ipmi 1

rocks add host interface compute-0-17 ipmi ip=192.168.10.141 name=ipmi-compute-0-17 subnet=admin
rocks set host interface channel compute-0-17 ipmi 1

# HP DL165 Nodes use Channel 2
rocks add host interface compute-0-24 ipmi ip=192.168.10.200 name=ipmi-compute-0-24 subnet=admin
rocks set host interface channel compute-0-24 ipmi 2

rocks add host interface compute-0-31 ipmi ip=192.168.10.247 name=ipmi-compute-0-31 subnet=admin
rocks set host interface channel compute-0-31 ipmi 2

echo -n "Syncing host network config..."
rocks sync host network
echo "done"

echo "Finalizing IPMI config"
for host in 17 24 31; do
 ssh compute-0-$host bash /etc/sysconfig/ipmi
done
ssh login-0-0 bash /etc/sysconfig/ipmi

echo "Done!"
 
