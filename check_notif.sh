#!/bin/bash
# THIS PLUGIN IS PROVIDED "AS IS", WITHOUT ANY WARRANTY, AND WITHOUT ANY SUPPORT. 
# Matthieu PERRIN - 2017


STATE_OK=0
STATE_WARNING=1
STATE_CRITICAL=2
STATE_UNKNOWN=3

RETOUR=$STATE_UNKNOWN
TEXT="no data"

# PRINT HELP
if [ "$1" == "--help" ]; then
   echo "Usage : $0 [warning] [critical] [periode]"
   exit 3
fi

[ -z "$1" ] && WARNING=$((100)) || WARNING=$1
[ -z "$2" ] && CRITICAL=$((150)) || CRITICAL=$2
[ -z "$3" ] && PERIODE=$((24)) || PERIODE=$3

. /etc/db_info.conf
db=centstorage

t=$(date  +%s --date "${PERIODE} hours ago")
query="SELECT  count(host_name)  FROM logs where msg_type = 2 and ctime > $t;"
email=$( /usr/bin/mysql -u ${db_user} -h ${db_host} -p${db_passwd} -D ${db} -s -N -e "${query}")

TEXT="${email} notifications (dernieres ${PERIODE} heures) | emails=${email}"

gethost()
{
        query="SELECT  host_name  FROM logs where msg_type = 2 and ctime > $t;"
        /usr/bin/mysql -u ${db_user} -h ${db_host} -p${db_passwd} -D ${db} -e "${query}" > /tmp/email_count_day.txt
        hote=$(cat /tmp/email_count_day.txt | sort | uniq -c |  sort --numeric-sort | tail -n 1)
}

if [ "$(echo $email | grep "^[[:digit:]]*$")" ]; then

        if [ "$email" -ge "$CRITICAL" ]; then
                gethost
                TEXT="${email} notifications (dernieres ${PERIODE} heures) > $CRITICAL (CRITICAL) [ ${hote} ] | emails=${email}"
                RETOUR=$STATE_CRITICAL
        elif [ "$email" -ge "$WARNING" ]; then
                gethost
                TEXT="${email} notifications (dernieres ${PERIODE} heures) > $WARNING (WARNING) [ ${hote} ] | emails=${email}"
                RETOUR=$STATE_WARNING
        elif [ "$email" -lt "$WARNING"  ]; then
                TEXT="${email} notifications (dernieres ${PERIODE} heures) | emails=${email}"
                RETOUR=$STATE_OK
        else
                RETOUR=$STATE_UNKNOWN
        fi

fi

echo $TEXT
exit $RETOUR
