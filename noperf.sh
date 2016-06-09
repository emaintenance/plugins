#!/bin/bash
# THIS PLUGIN IS PROVIDED "AS IS", WITHOUT ANY WARRANTY, AND WITHOUT ANY SUPPORT. 
# Matthieu PERRIN https://fr.linkedin.com/in/perrinmatthieu - 2015


if [ -z "$1" ]
then
    echo -e "Run plugin without perfdata "
    echo "Usage : $0 plugin arguments1 arguments2"
    exit 3
fi

PATH=$PATH:/usr/local/nagios/libexec

cmd=""

#shift
while test ${#} -gt 0
do
   cmd+=" $1"
   shift
done



res=3

text=""
text=`eval $cmd`
res=$(echo $?)

sortie=$(echo "$text" | cut -d"|" -f1)
echo "$sortie"

exit $res
