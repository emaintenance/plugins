#!/bin/bash
# THIS PLUGIN IS PROVIDED "AS IS", WITHOUT ANY WARRANTY, AND WITHOUT ANY SUPPORT. 
# Matthieu PERRIN - 2014

#Localisation des programmes
GREP="/bin/grep"
CUT="/bin/cut"
HEAD="/usr/bin/head"
SED="/bin/sed"

#-------------Recuperation parametre---------------------------
HOSTNAME=$1
SERVICE=$2

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
    echo "  "$0 "'"HOSTNAME"'" "'"SERVICE"'"
    echo -----------------------------------------------------------------------
    echo "  "Ex: $0 PA2_TEST Materiel
    echo -----------------------------------------------------------------------
    exit 1
fi

#---------------------Variable vide----------------------------
if [ "$1" = "" ]; then
    HOSTNAME=`/bin/hostname`
fi
if [ "$2" = "" ]; then
    SERVICE=Materiel
fi


######################################################################################################
### FONCTION ###

# Status du type de composant passer en parametre
function status()
{
liststat=$(echo "$list" | grep $1)

if [ `echo "$liststat" | grep Critical | wc -l` -gt 0 ]
then
        echo 2

elif [ `echo "$liststat" | grep Warning | wc -l` -gt 0 ]
then
        echo 1

elif [ `echo "$liststat" | grep Nominal | wc -l` -gt 0 ]
then
        echo 0
else
        echo 3
fi
}

# Genere le code retour en fonction des status des composants
function coderetour()
{
for i in `seq 3 -1 0`
do
        [ "$statuspower" -eq $i ] || [ "$statusdrive" -eq $i ] || [ "$statusfan" -eq $i ] && echo $i && return 0
done
}

# Affiche le firmware, modele et la marque
function info()
{

firmware=$($BMCINFO | $GREP "Firmware Revision" | $HEAD -1 | $CUT -d":" -f2)
sys=$($BMCINFO | $GREP "System Name" | $HEAD -1 | $CUT -d":" -f2)
fab=$($BMCINFO | $GREP "Manufacturer ID" | $HEAD -1 | $CUT -d":" -f2 | $SED 's/[^a-zA-Z.-]*//g')

echo -n "$fab $sys Firmware($firmware)"

}

######################################################################################################
### PROGRAMME ###

list=$(ipmimonitoring | cut -d"|" -f 2,3,4 | grep -v "N/A")

# Recupere les status des composants
statuspower=$(status "Power")
statusdrive=$(status "Drive")
statusfan=$(status "Fan")

# Calcul du code retour
retour=$(coderetour)

# Si PASSIF : ajoute l'hote, le service et le code retour
if [ "$1" != "actif" ]; then
        echo -n "$HOSTNAME;$SERVICE;$retour;"
fi

# Si aucune erreur : affiche firmware, modele et marque
[ "$statuspower" -eq 0 ] && [ "$statusdrive" -eq 0 ] && [ "$statusfan" -eq 0 ] && info

# Si erreur : affiche le type de composant en erreur
[ "$statuspower" -ne 0 ] && echo -n "Probleme d'alimentation. "
[ "$statusdrive" -ne 0 ] && echo -n "Probleme de disque. "
[ "$statusfan" -ne 0 ] && echo -n "Probleme de ventilateur. "

echo ""
exit $retour
