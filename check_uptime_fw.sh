#!/bin/bash
# THIS PLUGIN IS PROVIDED "AS IS", WITHOUT ANY WARRANTY, AND WITHOUT ANY SUPPORT. 
# Matthieu PERRIN (eMaintenance) - Nov 2017


howto()
{
   echo "This plugin check if the uptime is less than warning and critical"
   echo "Usage : $0 host communaute [Warning] [Critical]"

}

if [ "$1" == "--help" ]; then
   howto
   exit 3
fi

host=$1
com=$2
        [ -z "$3" ] && WARNING=490 || WARNING=$3
        [ -z "$4" ] && CRITICAL=495 || CRITICAL=$4

day=$(/usr/local/nagios/libexec/check_centreon_snmp_uptime  -H $host -C $com -v 2 -d  | cut -d":" -f2 | cut -d"|" -f1| tr -dc '0-9')
if [ "$day" -eq 0 ]; then
        sortie=0
else
        sortie=$day
fi

if [ "$(echo $sortie | grep "^[[:digit:]]*$")" ]; then


        if [ "$sortie" -ge "$CRITICAL" ]; then
                echo " Uptime: $sortie jours (> $CRITICAL) "
                  exit 2
        elif [ "$sortie" -ge "$WARNING" ]; then
                echo " Uptime: $sortie jours (> $WARNING) "
                  exit 1
        elif [ "$sortie" -lt "$WARNING" ]; then
                echo " Uptime: $sortie jours "
                  exit 0
        else
                howto
                  exit 3
        fi
fi

echo $sortie | tr "\n" "\t"
exit 3
