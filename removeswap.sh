#!/bin/bash

cat /proc/swaps
cat /proc/meminfo |grep Swap

printf "Which swapfile number is it you wish to remove?  "
read count

if [ $? -eq 0 ]; then
	echo 'swapfile'$count' found. Removing swapfile'$count' .'
	sed -i '/swapfile'$count'/d' /etc/fstab
	echo "3" > /proc/sys/vm/drop_caches
	swapoff /swapfile$count 
	rm -f /swapfile$count
else
	echo 'No swapfile found. No changes made.'
fi

cat /proc/swaps
cat /proc/meminfo |grep Swaps
free -mt
