#!/bin/bash
trigger=$(/usr/bin/grep pro /proc/cpuinfo -c)
load=`cat /proc/loadavg | awk '{print $1}'`
response=`echo | awk -v T=$trigger -v L=$load 'BEGIN{if ( L > T){ print "greater"}}'`
if [[ $response = "greater" ]]
then
	printf "High load on $HOSTNAME - [ $load ]\n"
fi
