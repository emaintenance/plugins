#!/bin/bash
# THIS PLUGIN IS PROVIDED "AS IS", WITHOUT ANY WARRANTY, AND WITHOUT ANY SUPPORT. 
# Matthieu PERRIN - 2015


if [ -z "$3" ]
then
    echo "Usage : $0 plugin hostname service [arguments1] [arguments]"
    exit 3
fi

PATH=$PATH:/usr/local/nagios/libexec

check=$1
shift
hostname=$1
shift
service=$1
shift

arg=""

while test ${#} -gt 0
do
   arg+=" $1"
   shift
done

res=3

text=$($check $arg)
res=$(echo $?)

echo "$hostname;$service;$res;$text"

