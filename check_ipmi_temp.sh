#!/bin/bash
# THIS PLUGIN IS PROVIDED "AS IS", WITHOUT ANY WARRANTY, AND WITHOUT ANY SUPPORT. 
# Matthieu PERRIN https://fr.linkedin.com/in/perrinmatthieu - 2016


#-------------Calcul de code de sortie---------------------------
calc_status()
{
        # SI vlaue compris entre warning low et warning high : OK
        if [ $VALUE -gt $LOW_TRESHOLD_WARNING ] && [ $VALUE -lt $HIGH_TRESHOLD_WARNING ]
        then
                OUTPUT=$STATUS_OK
        # SI value compris entre critail low et critical high : warning
        elif [ $VALUE -gt $LOW_TRESHOLD_CRITICAL ] && [ $VALUE -lt $HIGH_TRESHOLD_CRITICAL ]
        then
                OUTPUT=$STATUS_WARNING
        # SI value n'est pas compris entre critail low et critical high : critical
        elif [ $VALUE -le $LOW_TRESHOLD_CRITICAL ] || [ $VALUE -ge $HIGH_TRESHOLD_CRITICAL ]
        then
                OUTPUT=$STATUS_CRITICAL
        else
                OUTPUT=$STATUS_UNKNOWN
        fi
}


#-------------Calcul de code de sortie---------------------------
get_status()
{

STATUS_OK=0
STATUS_WARNING=1
STATUS_CRITICAL=2
STATUS_UNKNOWN=3

if [ "$3" = "" ]; then
        echo -e "Utilisation : $0 valeur high_warning high_critical [low_warning] [low_critical]\nEx. set_status.sh 20 25 30 10 5\n"
        exit $STATUS_UNKNOWN
fi

VALUE=$1
HIGH_TRESHOLD_WARNING=$2
HIGH_TRESHOLD_CRITICAL=$3

# Si le seuil bas n'est pas defini : seuil bas = valeur - 1
if [ "$4" = "" ]; then
        LOW_TRESHOLD_WARNING=$(($VALUE-1))
else
        LOW_TRESHOLD_WARNING=$4
fi
if [ "$5" = "" ]; then
        LOW_TRESHOLD_CRITICAL=$(($VALUE-1))
else
        LOW_TRESHOLD_CRITICAL=$5
fi


OUTPUT=$STATUS_UNKNOWN

calc_status
#exit $OUTPUT
#return $OUTPUT
}


#-------------------------------------------------------
#-------------   PROGRAMME   ---------------------------

#Localisation des programmes
GREP="/bin/grep"
CUT="/bin/cut"
HEAD="/usr/bin/head"

#-------------Recuperation parametre---------------------------
HOSTNAME=$1
SERVICE=$2
ALERT=$3
MAX=$4

#Localisation du programme IPMIMonitoring
if [ -f /usr/sbin/ipmimonitoring ]; then
        IPMIMONITOR="/usr/sbin/ipmimonitoring"
                BMCINFO="/usr/sbin/bmc-info"
elif [ -f /usr/local/sbin/ipmimonitoring ]; then
        IPMIMONITOR="/usr/local/sbin/ipmimonitoring"
                BMCINFO="/usr/local/sbin/bmc-info"
else
        DEFAUTIPMI="IpmiMonitoring introuvable"
        echo "erreur $DEFAUTIPMI"
                exit 3
fi

#---------Fichier d'aide---------------------------------------
if [ "$1" = "help" ]; then
    clear
    echo -----------------------------------------------------------------------
    echo "  "$0 "'"HOSTNAME"'" "'"SERVICE"'"  "'"ALERT_HAUT"'" "'"MAX_HAUT"'" "'"ALERT_BAS"'" "'"MAX_BAS"'"
    echo -----------------------------------------------------------------------
    echo "  "Ex mode passif: $0 PA2_TEST Temp_Systeme 30 33 10 7
        echo "  "Ex mode actif: $0 actif Temp_Systeme 30 33 10 7
    echo -----------------------------------------------------------------------
    exit 1
fi

#---------------------Variable vide----------------------------
[[ "$1" = "" ]] && HOSTNAME=`/bin/hostname`
[[ "$2" = "" ]] && SERVICE=Temp_Systeme
[[ "$3" = "" ]] && ALERT=30
[[ "$4" = "" ]] && MAX=33
[[ "$5" = "" ]] && ALERT_LOW=10
[[ "$6" = "" ]] && MAX_LOW=7


#---------------------Recupere temperature----------------------------
TMPIPMIMONITOR=$($IPMIMONITOR -h 127.0.0.1)
TEMP_AMB=$(echo "$TMPIPMIMONITOR" |$GREP "Temperature" | $HEAD -1 |$CUT -d"|" -f5| $CUT -b 2-3 | sed 's/[^0-9]//g')

get_status $TEMP_AMB $ALERT $MAX $ALERT_LOW $MAX_LOW

if [ "$1" != "actif" ]; then
echo -n "$HOSTNAME;$SERVICE;$OUTPUT;"
fi

echo -n "$TEMP_AMB °C|Temperature_Systeme=$TEMP_AMB"
echo ""



exit $OUTPUT
