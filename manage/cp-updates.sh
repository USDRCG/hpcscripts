#!/bin/bash

# 64 bit and no arch
find /var/cache/yum -name "*.x86_64.rpm" -exec cp {} /export/rocks/install/contrib/6.2/x86_64/RPMS \;
find /var/cache/yum -name "*.noarch.rpm" -exec cp {} /export/rocks/install/contrib/6.2/x86_64/RPMS \;

mkdir -p /export/rocks/install/contrib/6.2/i686/RPMS/
find /var/cache/yum -name "*.i686.rpm" -exec cp {} /export/rocks/install/contrib/6.2/i686/RPMS \;

cd /export/rocks/install
rocks create distro
