#!/bin/bash
# THIS PLUGIN IS PROVIDED "AS IS", WITHOUT ANY WARRANTY, AND WITHOUT ANY SUPPORT. 
# Matthieu PERRIN (eMaintenance) - Fev 2017

# login information
db_host=localhost
. /etc/db_info.conf
centreon_status=centreon_status
centreon_storage=centreon_storage
centreon_status=ndo
centreon_storage=centstorage

d=$(date  +%s --date="10 minute ago")
poller=$1
retour=3
message=""


# recupere la date du poller
lastalive=$(mysql -h ${db_host} -u${db_user} -p${db_passwd} -D centstorage -s -N -e "SELECT last_alive FROM instances where name like \"${poller}\"; " | tail -n 1)

# test si la valeur est valide
if [ $(echo $lastalive | wc -c) -gt 5 ]
then
	valide=1
else
	valide=0
	retour=3
	message="Le poller ${poller} n'est pas present en base"
fi	

# si la valeur est valide
if [ $valide -eq 1 ]
then

if [ $lastalive -gt $d ]
then
	retour=0
	message="Poller en ligne"
else
	retour=1
	dernier=$(date -d @${lastalive} +"%d-%m-%Y %H:%M")
	message="Poller hors ligne depuis ${dernier}"
fi

fi

echo $message
exit $retour
