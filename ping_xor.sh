#!/bin/bash
# THIS PLUGIN IS PROVIDED "AS IS", WITHOUT ANY WARRANTY, AND WITHOUT ANY SUPPORT. 
# Matthieu PERRIN https://fr.linkedin.com/in/perrinmatthieu - 2014


[ -z $2 ] && echo -e "Return OK only if a host is up and the other down.\nUsage : $0 IP1 IP2" && exit 3

device1=$1
device2=$2
msg=""

check_ip()
{
	ping $1 -w 2 -n -c 2 -q > /dev/null
	res=$?

	[ $res -eq 0 ] && status=UP || status=DOWN
	msg=$( echo "$msg $1:$status ") 
}


check_ip $1
resultat1=$res

check_ip $2
resultat2=$res

echo $msg

# Si une des deux ip est ok (resultat1 XOR resultat2)
[ $(( $resultat1 ^ $resultat2 )) -eq 1 ] && exit 0 || exit 1

