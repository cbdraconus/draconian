#!/bin/bash
echo "Flushing iptables rules... please wait"
sleep 1
iptables -F
iptables -X
iptables -t nat -F
iptables -t nat -X
iptables -t mangle -F
iptables -t mangle -X
iptables -P INPUT ACCEPT
iptables -P FORWARD ACCEPT
iptables -P OUTPUT ACCEPT
sleep 5
echo "Iptables are now clean... pwn responsibly."
