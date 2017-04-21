#!/bin/bash

cat << EOF >>/boot/grub/grub.conf
console=ttyS0,115200n8 console=tty0
serial --unit=0 --speed=115200 --word=8 --parity=no --stop=1
terminal --timeout=0 console serial
EOF

echo ttyS0 >>/etc/securetty

sed /boot/grub/grub.conf  -i -e '/^kernel/ s|$| console=tty0 console=ttyS0,115200|'
