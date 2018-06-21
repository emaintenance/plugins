#!/bin/bash
# THIS PLUGIN IS PROVIDED "AS IS", WITHOUT ANY WARRANTY, AND WITHOUT ANY SUPPORT. 
# Matthieu PERRIN - 2017

howto()
{
   echo "This plugin check if free memory is less than warning and critical"
   echo -e "Usage : $0 [-w warning] [-c critical] [-m]\n\t-w\t warning \n\t-c\t critical\n\t-m\t disable metrics\n"
   echo "Usage : $0 [-w warning] [-c critical] [-m]"
   echo "Example : $0 -w 20 -c 10"
   exit 3
}

metric=1

getopt()
{
        while [[ $1 ]]
        do
          case "$1" in
            -h)
                howto
                shift
                ;;
            -w)
                shift
                WARNING=$1
                shift
                ;;
            -c)
                shift
                CRITICAL=$1
                shift
                ;;
            -m)
                metric=0
                shift
                ;;
            *)
                echo "Parametre inconnu $1"
                howto
                shift
          esac

        done

        
}

getopt "$@"



MemTotal=$(cat /proc/meminfo | grep MemTotal | tr -d -c 0-9)
MemFree=$(cat /proc/meminfo | grep MemFree | tr -d -c 0-9)
prctfree=$(( 100 * MemFree / MemTotal))
prctused=$(( 100 - prctfree ))
warnused=$(( 100 - WARNING ))
critused=$(( 100 - CRITICAL ))

perfdata=""
[ $metric -eq 1 ] && perfdata=$(echo " | 'memory'=${prctused}%;$warnused;$critused;0;100")

if [ "$(echo $prctfree | grep "^[[:digit:]]*$")" ]; then

        if [ "$prctfree" -le "$CRITICAL" ]; then
                echo "Free memory : $prctfree %  (< $CRITICAL) $perfdata"
                  exit 2
        elif [ "$prctfree" -le "$WARNING" ]; then
                echo "Free memory : $prctfree % (< $WARNING) $perfdata"
                  exit 1
        elif [ "$prctfree" -gt "$WARNING" ]; then
                echo " Free memory : $prctfree % $perfdata "
                  exit 0
        else
                howto
                exit 3
        fi
fi

echo "Erreur : $prctfree "
exit 3
