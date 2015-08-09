#!/usr/bin/python
import os
ip = raw_input("What is the IP address you want to connect to: ")
port = raw_input("What is the port you want to connect to: ")
os.system("ncat -v %s %s --ssl" % (ip, port))
