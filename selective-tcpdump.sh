#!/bin/bash
#
# 2015-09-25 yourimatthys@gmail.com

NOW=$(date +"%Y_%m_%d_%H_%M_%S")
DIRECTORY="/var/log/pcap"
FILENAME="aioffice.pcap"
INTERFACE="em1"
OPTIONS="src host 192.168.1.10 and port 5001"
ROTPERIOD="3600" 

# Make sure only root can run our script
	if [ "$(id -u)" != "0" ]; then
		echo "This script must be run as root" 1>&2
		exit 1
	fi

# Make sure $DIRECTORY exists, if not then create directory!
	if [ -d $DIRECTORY ]
	then
		echo "Directory $DIRECTORY exists."
	else
		mkdir $DIRECTORY
	fi

# Check if tcpdump is running and if it's not, run it!
	if pgrep "tcpdump" > /dev/null
	then
		echo "Running" && pgrep "tcpdump"
	else
		/usr/sbin/tcpdump -i $INTERFACE -n $OPTIONS -w $DIRECTORY/$NOW-$FILENAME -U -G $ROTPERIOD
	fi
