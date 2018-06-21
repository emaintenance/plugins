#!/bin/bash
# THIS PLUGIN IS PROVIDED "AS IS", WITHOUT ANY WARRANTY, AND WITHOUT ANY SUPPORT. 
# Matthieu PERRIN - 2015


howto()
{
   echo "This plugin check if the uptime is less than warning and critical"
   echo "Usage : $0 [Warning] [Critical]"

}

if [ "$1" == "--help" ]; then
   howto
   exit 3
fi


day=$( uptime | grep day | wc -l)
if [ "$day" -eq 0 ]; then
        sortie=0
else
        sortie=$(uptime | awk '{print $3}')
fi

if [ "$(echo $sortie | grep "^[[:digit:]]*$")" ]; then

        [ -z "$1" ] && WARNING=$(($sortie+1)) || WARNING=$1
        [ -z "$2" ] && CRITICAL=$(($sortie+2)) || CRITICAL=$2

        if [ "$sortie" -ge "$CRITICAL" ]; then
                echo " Uptime: $sortie days (> $CRITICAL) "
                  exit 2
        elif [ "$sortie" -ge "$WARNING" ]; then
                echo " Uptime: $sortie days (> $WARNING) "
                  exit 1
        elif [ "$sortie" -lt "$WARNING" ]; then
                echo " Uptime: $sortie days "
                  exit 0
        else
                howto
                  exit 3
        fi
fi

echo $sortie | tr "\n" "\t"
exit 3
