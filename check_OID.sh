#!/bin/bash
# THIS PLUGIN IS PROVIDED "AS IS", WITHOUT ANY WARRANTY, AND WITHOUT ANY SUPPORT. 
# Matthieu PERRIN - 2015

if [ "$1" == "--help" ]||[ -z "$5" ]; then
   echo "This plugin check if the current OID is less than warning and critical"
   echo "Usage : $0 SNMPcomunity IPaddress OID Warning Critical [name] [unite]"
   exit 3
fi

unit=""
name=$3
val="value"
if [ ! -z "$6" ]
then
	name=$6
	val=$6
fi

if [ ! -z "$7" ]
then
	unit=$7
fi

sortie=$(/usr/bin/snmpget -Ov -v2c -c $1 $2 $3 | cut -d " " -f2)

if [ "$(echo $sortie | grep "^[[:digit:]]*$")" ]; then

	echo " $name: $sortie $unit | $val=$sortie"

	if [ "$sortie" -ge "$5" ]; then
		  exit 2 
	elif [ "$sortie" -ge "$4" ]; then	
		  exit 1   
	elif [ "$sortie" -lt "$4" ]; then
		  exit 0	  
	else
		  exit 3
	fi

fi

echo $sortie | tr "\n" "\t"	  
exit 3 
