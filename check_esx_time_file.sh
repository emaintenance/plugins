#!/bin/bash
# THIS PLUGIN IS PROVIDED "AS IS", WITHOUT ANY WARRANTY, AND WITHOUT ANY SUPPORT. 
# Matthieu PERRIN - 2015


howto()
{
   echo "This plugin check if ESX time gap with poller is less than warning and critical"
   echo "Usage : $0 [adresse] [file] [warning] [critical]"
}

if [ "$1" == "--help" ]||[ -z "$2" ]; then
   howto
   exit 3
fi

file=/usr/local/nagios/bin/$2
user=$(cat $file | grep user | cut -d'=' -f2)
pass=$(cat $file | grep pass | cut -d'=' -f2)
ip=$1
[ -z "$3" ] && WARNING=$((10)) || WARNING=$3
[ -z "$4" ] && CRITICAL=$((30)) || CRITICAL=$4


utc=$(date -d "$(date -u +"%m/%d/%Y %H:%M:%S")" +"%s")
serverClock=$(wget -qO- https://$user:$pass@$ip/mob/ --no-check-certificate | grep serverClock | tr '>' '\n' | tr '<' '\n' |grep '[0-9]\{4\}-[0-9]\{2\}-[0-9]\{2\}T[0-9]\{2\}:[0-9]\{2\}:[0-9]\{2\}' | tail -n 1)

if [ -z "$serverClock" ]; then
   echo "Impossible de recuperer l'heure"
   exit 3
fi

scYear=$(echo $serverClock | cut -d '-' -f 1)
scMon=$(echo $serverClock | cut -d '-' -f 2)
scDay=$(echo $serverClock | cut -d '-' -f 3 | cut -d 'T' -f 1)
scHour=$(echo $serverClock | cut -d 'T' -f 2 | cut -d ':' -f 1)
scMin=$(echo $serverClock | cut -d 'T' -f 2 | cut -d ':' -f 2)
scSec=$(echo $serverClock | cut -d 'T' -f 2 | cut -d ':' -f 3  | cut -d '.' -f 1)

sc=$(date -d "$scMon/$scDay/$scYear $scHour:$scMin:$scSec" +"%s")
d=$(($sc-$utc))
dif=${d#-}
hesx=$(echo "Heure ESX : $scDay/$scMon/$scYear $scHour:$scMin:$scSec")


if [ "$(echo $dif | grep "^[[:digit:]]*$")" ]; then

        if [ "$dif" -ge "$CRITICAL" ]; then
                echo " Ecart: $dif sec (> $CRITICAL). $hesx "
                  exit 2
        elif [ "$dif" -ge "$WARNING" ]; then
                echo " Ecart: $dif sec (> $WARNING). $hesx "
                  exit 1
        elif [ "$dif" -lt "$WARNING" ]; then
                echo " Ecart: $dif sec. $hesx  "
                  exit 0
        else
                howto
                exit 3
        fi
fi

echo "Sortie esx : $serverClock , Difference : $dif "
exit 3
