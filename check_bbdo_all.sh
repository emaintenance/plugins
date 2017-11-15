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
LIBEXEC=/usr/local/nagios/libexec/

message=""
retour=0

 mysql -h ${db_host} -u${db_user} -p${db_passwd} -D centstorage -s -N -e "SELECT name FROM instances where instance_id < 400" > /tmp/instance_id


while read instance; do


  msg=$(${LIBEXEC}/check_bbdo.sh ${instance})
  resultat=$?
  [ $resultat -gt 0 ] && message="${message}${instance}=${msg}. "
  retour=$((retour + resultat))

done < /tmp/instance_id

# Si un ou plusieur poller en erreur alors exit 1
[ $retour -gt 2 ] && retour=2



[ $retour -eq 0 ] && message="Les pollers sont en ligne"


echo $message
exit $retour
