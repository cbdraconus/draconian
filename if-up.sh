#!/bin/bash
for ip in $(seq 1 15);do ping -c 3 192.168.1.$ip > /dev/null; [ $? -eq 0 ] && echo "192.168.1.$ip is UP" || : ; done
/home/draco/if-up.sh
