#!/bin/bash
clear
echo -e "
\033[36m#################################################
#						#
# NMap by Draconus				#
# I developed this to make using nmap against	#
# a network easier to utilize it's full 	#
# potential and more convienient as well.	#
#						#
#################################################\033[m"
version="0.0.2"
sleep 5
clear
echo -e "\033[32mChecking for root....please wait.....\033[m"
sleep 3
if [ $UID -ne 0 ]; then
        echo -e "\033[31mThis program will run better as root.\033[m"
        sleep 3
        fi
if [ $UID == 0 ]; then
        echo -e "\033[31mHello root, I hope you enjoy this script.\033[m"
        sleep 3
        fi
#some variables
function interface(){
echo -e "\033[32mWhat interface do you want to use for scanning purposes?\033[m "
read IFACE
MYIP=$(ifconfig $IFACE | awk '(NR == 2) {print $2}' |cut -d ":" -f2)
echo -e "\033[32mYour ip address is $MYIP\033[m"
sleep 5
}
interface
#### Target address
function target(){
echo -e "\033[32mWhat is the target ip or ip range you will be scanning?\033[m \033[31m(example 192.168.1.201 OR 192.168.1.201-252)\033[m"
read target
}
#### Determin Distro
function distro(){
echo -e "\033[32mPlease wait while I determine your distro....\033[m"
distro=$(cat /etc/lsb-release |grep -i "distrib_id"|cut -d"=" -f2)
echo -e "\033[32mYour Distro is $distro, right?\033[m"
read dist
if [[ $dist = Y || $dist = y ]] ; then
	echo -e "\e[32m[-] Thank you for confirming.\e[0m"
else
	distro=$(lsb_release -i |awk '{ID}; {print $3}')
	echo -e "\033[32mYour Distro is $distro\033[m"
fi
sleep 5
}
distro
##### Install nmap if not installed
echo "Checking if Nmap is already installed"
sleep 5
if [ ! -e "/usr/bin/nmap" ];then
	echo "Nmap not installed. Do you want to install it? (Y/N)"
	read install
	if [[ $install = Y || $install = y ]] ; then
		apt-get install --reinstall nmap -y
		echo "Nmap should now be installed."
	else
		echo -e "\e[32m[-] Cannot proceed without nmap. Exiting.\e[0m"
	fi
else
	echo "Nmap is already installed"
	sleep 1
fi
#### End of install process
#### Nmap options definition
function define(){
echo -e "\033[32mTARGET SPECIFICATION:
  Can pass hostnames, IP addresses, networks, etc.
  Ex: scanme.nmap.org, microsoft.com/24, 192.168.0.1; 10.0.0-255.1-254
  -iL <inputfilename>: Input from list of hosts/networks
  -iR <num hosts>: Choose random targets
  --exclude <host1[,host2][,host3],...>: Exclude hosts/networks
  --excludefile <exclude_file>: Exclude list from file"
pause
"HOST DISCOVERY:
  -sL: List Scan - simply list targets to scan
  -sn: Ping Scan - disable port scan
  -Pn: Treat all hosts as online -- skip host discovery
  -PS/PA/PU/PY[portlist]: TCP SYN/ACK, UDP or SCTP discovery to given ports
  -PE/PP/PM: ICMP echo, timestamp, and netmask request discovery probes
  -PO[protocol list]: IP Protocol Ping
  -n/-R: Never do DNS resolution/Always resolve [default: sometimes]
  --dns-servers <serv1[,serv2],...>: Specify custom DNS servers
  --system-dns: Use OS's DNS resolver
  --traceroute: Trace hop path to each host"
pause
"SCAN TECHNIQUES:
  -sS/sT/sA/sW/sM: TCP SYN/Connect()/ACK/Window/Maimon scans
  -sU: UDP Scan
  -sN/sF/sX: TCP Null, FIN, and Xmas scans
  --scanflags <flags>: Customize TCP scan flags
  -sI <zombie host[:probeport]>: Idle scan
  -sY/sZ: SCTP INIT/COOKIE-ECHO scans
  -sO: IP protocol scan
  -b <FTP relay host>: FTP bounce scan"
pause
"PORT SPECIFICATION AND SCAN ORDER:
  -p <port ranges>: Only scan specified ports
    Ex: -p22; -p1-65535; -p U:53,111,137,T:21-25,80,139,8080,S:9
  -F: Fast mode - Scan fewer ports than the default scan
  -r: Scan ports consecutively - don't randomize
  --top-ports <number>: Scan <number> most common ports
  --port-ratio <ratio>: Scan ports more common than <ratio>"
pause
"SERVICE/VERSION DETECTION:
  -sV: Probe open ports to determine service/version info
  --version-intensity <level>: Set from 0 (light) to 9 (try all probes)
  --version-light: Limit to most likely probes (intensity 2)
  --version-all: Try every single probe (intensity 9)
  --version-trace: Show detailed version scan activity (for debugging)"
pause
"SCRIPT SCAN:
  -sC: equivalent to --script=default
  --script=<Lua scripts>: <Lua scripts> is a comma separated list of 
           directories, script-files or script-categories
  --script-args=<n1=v1,[n2=v2,...]>: provide arguments to scripts
  --script-args-file=filename: provide NSE script args in a file
  --script-trace: Show all data sent and received
  --script-updatedb: Update the script database.
  --script-help=<Lua scripts>: Show help about scripts.
           <Lua scripts> is a comma-separated list of script-files or
           script-categories."
pause
"OS DETECTION:
  -O: Enable OS detection
  --osscan-limit: Limit OS detection to promising targets
  --osscan-guess: Guess OS more aggressively"
pause
"TIMING AND PERFORMANCE:
  Options which take <time> are in seconds, or append 'ms' (milliseconds),
  's' (seconds), 'm' (minutes), or 'h' (hours) to the value (e.g. 30m).
  -T<0-5>: Set timing template (higher is faster)
  --min-hostgroup/max-hostgroup <size>: Parallel host scan group sizes
  --min-parallelism/max-parallelism <numprobes>: Probe parallelization
  --min-rtt-timeout/max-rtt-timeout/initial-rtt-timeout <time>: Specifies
      probe round trip time.
  --max-retries <tries>: Caps number of port scan probe retransmissions.
  --host-timeout <time>: Give up on target after this long
  --scan-delay/--max-scan-delay <time>: Adjust delay between probes
  --min-rate <number>: Send packets no slower than <number> per second
  --max-rate <number>: Send packets no faster than <number> per second"
pause
"FIREWALL/IDS EVASION AND SPOOFING:
  -f; --mtu <val>: fragment packets (optionally w/given MTU)
  -D <decoy1,decoy2[,ME],...>: Cloak a scan with decoys
  -S <IP_Address>: Spoof source address
  -e <iface>: Use specified interface
  -g/--source-port <portnum>: Use given port number
  --proxies <url1,[url2],...>: Relay connections through HTTP/SOCKS4 proxies
  --data-length <num>: Append random data to sent packets
  --ip-options <options>: Send packets with specified ip options
  --ttl <val>: Set IP time-to-live field
  --spoof-mac <mac address/prefix/vendor name>: Spoof your MAC address
  --badsum: Send packets with a bogus TCP/UDP/SCTP checksum"
pause
"OUTPUT:
  -oN/-oX/-oS/-oG <file>: Output scan in normal, XML, s|<rIpt kIddi3,
     and Grepable format, respectively, to the given filename.
  -oA <basename>: Output in the three major formats at once
  -v: Increase verbosity level (use -vv or more for greater effect)
  -d: Increase debugging level (use -dd or more for greater effect)
  --reason: Display the reason a port is in a particular state
  --open: Only show open (or possibly open) ports
  --packet-trace: Show all packets sent and received
  --iflist: Print host interfaces and routes (for debugging)
  --log-errors: Log errors/warnings to the normal-format output file
  --append-output: Append to rather than clobber specified output files
  --resume <filename>: Resume an aborted scan
  --stylesheet <path/URL>: XSL stylesheet to transform XML output to HTML
  --webxml: Reference stylesheet from Nmap.Org for more portable XML
  --no-stylesheet: Prevent associating of XSL stylesheet w/XML output"
pause
"MISC:
  -6: Enable IPv6 scanning
  -A: Enable OS detection, version detection, script scanning, and traceroute
  --datadir <dirname>: Specify custom Nmap data file location
  --send-eth/--send-ip: Send using raw ethernet frames or IP packets
  --privileged: Assume that the user is fully privileged
  --unprivileged: Assume the user lacks raw socket privileges
  -V: Print version number
  -h: Print this help summary page."
pause
"EXAMPLES:
  nmap -v -A scanme.nmap.org
  nmap -v -sn 192.168.0.0/16 10.0.0.0/8
  nmap -v -iR 10000 -Pn -p 80\033[m"
}
#### Pause function
function pause(){
	read -sn 1 -p "Press any key to continue..."
}

#### Screwed up
function screwedup {
	echo "You screwed things up somehow, try again."
	pause
	clear
}

######## Update $distro
function update {
clear
echo -e "
\033[31m########################################################\033[m
		Let's make sure $distro is up to date
\033[31m########################################################\033[m"
select menusel in "Update $distro" "Update and Clean $distro" "Back to Main"; do
case $menusel in
	"Update $distro")
		clear
		echo -e "\033[32mUpdaiting $distro\033[m"
		apt-get update && apt-get upgrade -y && apt-get dist-upgrade -y
		echo -e "\033[32mDone updaiting $distro\033[m"
		pause
		clear ;;

 	"Update and Clean $distro")
		clear
		echo -e "\033[32mUpdating and Cleaning $distro\033[m"
		apt-get update && apt-get -y upgrade && apt-get -y dist-upgrade && apt-get autoremove -y && apt-get -y autoclean
		echo -e "\033[32Done updating and cleaning $distro\033[m" 
		pause
		clear ;;
		
	"Back to Main")
		clear
		mainmenu ;;
	*)
		screwedup
		update ;;

esac

break

done
}

##### Nmap Services
function nmapservices {
clear
echo -e "
\033[31m##########################################################\033[m
			Nmap NSE Libraries
\033[31m##########################################################\033[m"
select menusel in "Auth" "Broadcast" "Brute" "Default" "Discovery" "Dos" "Exploit" "External" "Fuzzer" "Intrusive" "Malware" "Safe" "Version" "Vuln" "Back to Main"; do case $menusel in
	"Auth")
		echo -e "\033[32mUsing Nmaps Auth NSE\033[m"
		target
		nmap \-e $IFACE \--script=auth $target
		pause 
		nmapservices ;;
	"Broadcast")
		echo -e "\033[32mUsing Nmaps Broadcast NSE\033[m"
		target
		nmap \-e $IFACE \--script=broadcast $target
		pause 
		nmapservices ;;
	"Brute")
		echo -e "\033[32mUsing Nmaps Brute NSE\033[m"
		target
		nmap \-e $IFACE \--script=brute $target
		pause 
		nmapservices ;;
	"Default")
		echo -e "\033[32mUsing Nmaps Default NSE\033[m"
		target
		nmap \-e $IFACE \--script=default $target
		pause 
		nmapservices ;;
	"Discovery")
		echo -e "\033[32mUsing Nmaps Discovery NSE\033[m"
		target
		nmap \-e $IFACE \--script=discovery $target
		pause 
		nmapservices ;;
	"Dos")
		echo -e "\033[32mUsing Nmaps Dos NSE\033[m"
		target
		nmap \-e $IFACE \--script=dos $target
		pause 
		nmapservices ;;
	"Exploit")
		echo -e "\033[32mUsing Nmaps Exploit NSE\033[m"
		target
		nmap \-e $IFACE \--script=exploit $target
		pause 
		nmapservices ;;
	"External")
		echo -e "\033[32mUsing Nmaps External NSE\033[m"
		target
		nmap \-e $IFACE \--script=external $target
		pause 
		nmapservices ;;
	"Fuzzer")
		echo -e "\033[32mUsing Nmaps Fuzzer NSE\033[m"
		target
		nmap \-e $IFACE \--script=fuzzer $target
		pause
		nmapservices ;;
	"Intrusive")
		echo -e "\033[32mUsing Nmaps Intrusive NSE\033[m"
		target
		nmap \-e $IFACE \--script=intrusive $target
		pause 
		nmapservices ;;
	"Malware")
		echo -e "\033[32mUsing Nmaps Malware NSE\033[m"
		target
		nmap \-e $IFACE \--script=instrusive $target
		pause 
		nmapservices ;;
	"Safe")
		echo -e "\033[32mUsing Nmaps Safe NSE\033[m"
		target
		nmap \-e $IFACE \--script=safe $target
		pause 
		nmapservices ;;
	"Version")
		echo -e "\033[32mUsing Nmaps Version NSE\033[m"
		target
		nmap \-e $IFACE \--script=safe $target
		pause 
		nmapservices ;;
	"Vuln")
		echo -e "\033[32mUsing Nmaps Vuln NSE\033[m"
		target
		nmap \-e $IFACE \--script=vuln $target
		pause 
		nmapservices ;;
	"Back to Main")
		clear
		mainmenu ;;
	*)
		screwedup
		nmapservices ;;

esac

break

done
}

##### Nmap Services with extra options
function extranmap {
clear
echo -e "
\033[31m##########################################################\033[m
                        Nmap NSE Libraries
\033[31m##########################################################\033[m"
select menusel in "Auth" "Broadcast" "Brute" "Default" "Discovery" "Dos" "Exploit" "External" "Fuzzer" "Intrusive" "Malware" "Safe" "Version" "Vuln" "Nmap options definition" "Back to Main"; do case $menusel in
        "Auth")
                echo -e "\033[32mUsing Nmaps Auth NSE\033[m"
		target
		echo -e "\033[32mWhat additional nmap options do you want to use?\033[m"
		read extra
                nmap \-e $IFACE $extra \--script=auth $target
                pause 
		extranmap ;;
        "Broadcast")
                echo -e "\033[32mUsing Nmaps Broadcast NSE\033[m"
                target
		echo -e "\033[32mWhat additional nmap options do you want to use
?\033[m"
                read extra
		nmap \-e $IFACE $extra \--script=broadcast $target
                pause 
		extranmap ;;
        "Brute")
                echo -e "\033[32mUsing Nmaps Brute NSE\033[m"
                target
		echo -e "\033[32mWhat additional nmap options do you want to use
?\033[m"
                read extra
		nmap \-e $IFACE $extra \--script=brute $target
                pause 
		extranmap ;;
        "Default")
                echo -e "\033[32mUsing Nmaps Default NSE\033[m"
                target
		echo -e "\033[32mWhat additional nmap options do you want to use
?\033[m"
                read extra
		nmap \-e $IFACE $extra \--script=default $target
                pause 
		extranmap ;;
        "Discovery")
                echo -e "\033[32mUsing Nmaps Discovery NSE\033[m"
                target
		echo -e "\033[32mWhat additional nmap options do you want to use
?\033[m"
                read extra
		nmap \-e $IFACE $extra \--script=discovery $target
                pause 
		extranmap ;;
        "Dos")
                echo -e "\033[32mUsing Nmaps Dos NSE\033[m"
                target
		echo -e "\033[32mWhat additional nmap options do you want to use
?\033[m"
                read extra
		nmap \-e $IFACE $extra \--script=dos $target
                pause 
		extranmap ;;
        "Exploit")
                echo -e "\033[32mUsing Nmaps Exploit NSE\033[m"
                target
		echo -e "\033[32mWhat additional nmap options do you want to use
?\033[m"
                read extra
		nmap \-e $IFACE $extra \--script=exploit $target
                pause 
		extranmap ;;
        "External")
                echo -e "\033[32mUsing Nmaps External NSE\033[m"
                target
		echo -e "\033[32mWhat additional nmap options do you want to use
?\033[m"
                read extra
		nmap \-e $IFACE $extra \--script=external $target
                pause 
		extranmap ;;
        "Fuzzer")
                echo -e "\033[32mUsing Nmaps Fuzzer NSE\033[m"
                target
		echo -e "\033[32mWhat additional nmap options do you want to use
?\033[m"
                read extra
		nmap \-e $IFACE $extra \--script=fuzzer $target
                pause
		extranmap ;;
        "Intrusive")
                echo -e "\033[32mUsing Nmaps Intrusive NSE\033[m"
                target
		echo -e "\033[32mWhat additional nmap options do you want to use
?\033[m"
                read extra
		nmap \-e $IFACE $extra \--script=intrusive $target
                pause 
		extranmap ;;
        "Malware")
                echo -e "\033[32mUsing Nmaps Malware NSE\033[m"
                target
		echo -e "\033[32mWhat additional nmap options do you want to use
?\033[m"
                read extra
		nmap \-e $IFACE $extra \--script=instrusive $target
                pause 
		extranmap ;;
        "Safe")
                echo -e "\033[32mUsing Nmaps Safe NSE\033[m"
                target
		echo -e "\033[32mWhat additional nmap options do you want to use?\033[m"
		nmap \-e $IFACE $extra \--script=safe $target
                pause 
		extranmap ;;
        "Version")
                echo -e "\033[32mUsing Nmaps Version NSE\033[m"
                target
		echo -e "\033[32mWhat additional nmap options do you want to use
?\033[m"
                read extra
		nmap \-e $IFACE $extra \--script=safe $target
                pause 
		extranmap ;;
        "Vuln")
                echo -e "\033[32mUsing Nmaps Vuln NSE\033[m"
                target
		echo -e "\033[32mWhat additional nmap options do you want to use
?\033[m"
                read extra
		nmap \-e $IFACE $extra \--script=vuln $target
                pause 
		extranmap ;;
	"Nmap options definition")
		clear
		define 
		extranmap ;;
        "Back to Main")
                clear
                mainmenu ;;
        *)
                screwedup
                extranmap ;;

esac

break

done
}

function mainmenu {
echo -e "
\033[36m################################################
##		Main Menu		      ##
################################################\033[m
	Script by Draconus
		verson: \033[32m$version\033[m
	Script Location: \033[31m`pwd`\033[m
	Connection Info :-------------------------------
	Distro: \033[31m'$distro'\033[m
	Interface: \033[31m$IFACE\033[m
	IP Address: \033[31m$MYIP\033[m
\033[36m#################################################\033[m"

select menusel in "Update $distro" "Nmap Services" "Nmap Services with extra options" "Define your own scan" "Change interface" "EXIT"; do
case $menusel in
	"Update $distro")
		update
		clear ;;
	
	"Nmap Services")
		nmapservices
		clear ;;
	
	"Nmap Services with extra options")
		extranmap
		clear ;;
	
	"Define your own scan")
		echo -e "Please write out your nmap scan :"
		read custom
		$custom
		pause
		mainmenu ;;

	"Change interface")
		interface
		pause
		mainmenu ;;
	"EXIT")
		clear && exit 0 ;;
	
	* )
		screwedup
		clear ;;

esac

break

done
}

while true; do mainmenu; done
