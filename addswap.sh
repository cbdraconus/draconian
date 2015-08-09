#!/bin/bash

cat /proc/swaps
cat /proc/meminfo |grep Swap
printf "What is the swap/file number you wish to create?  "
read count

printf "What is the size in Mb that you would like to create?  "
read swapsize

grep -q "swapfile$count" /etc/fstab

if [ $? -ne 0 ]; then
	echo "swapfile"$count" does not exsist. Adding Swapfile."
	fallocate -l ${swapsize}M /swapfile$count
	chmod 600 /swapfile$count
	mkswap /swapfile$count
	swapon /swapfile$count
	echo '/swapfile'$count' none swap defaults 0 0' >> /etc/fstab
fi

cat /proc/swaps
cat /proc/meminfo |grep Swap
free -mt
