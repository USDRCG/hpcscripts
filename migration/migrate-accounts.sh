#!/bin/bash
# Ugly hacky mess

TS=$(date +"%Y%m%d%H%M%S")
die () { echo; echo "Bailing!"; echo; exit 1;}

for file in /etc/passwd /etc/group /etc/shadow; do
  echo "backing up $file as $file.$TS"
  cp $file $file.$TS || die
  #ssh rio.usd.edu "awk -F: '{if (\$3 >= 500) { print } }' $file" >>$file
  ssh rio.usd.edu "awk -F: '{if (\$3 >= 41803) { print } }' $file" >>$file
done


# /etc/gshadow and /etc/auto.hoem have different formats 
# Get account names for UID >= 500
for file in /etc/gshadow /etc/auto.home; do
  echo "backing up $file as $file.$TS"
  cp $file $file.$TS || die
done

#ssh rio.usd.edu "awk -F: '{if (\$3 >= 500) { print \$1} }' /etc/passwd" 2>/dev/null | \
ssh rio.usd.edu "awk -F: '{if (\$3 >= 41803) { print \$1} }' /etc/passwd" 2>/dev/null | \
while read username; do
  ssh rio.usd.edu "awk -F: '{if (\$1 ~ /$username/) {print} }' /etc/gshadow"  < /dev/null 2>/dev/null >>/etc/gshadow
  ssh rio.usd.edu "grep $username /etc/auto.home" < /dev/null 2>/dev/null >>/etc/auto.home
done
