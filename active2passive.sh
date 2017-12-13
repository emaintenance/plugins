#!/bin/bash
# THIS PLUGIN IS PROVIDED "AS IS", WITHOUT ANY WARRANTY, AND WITHOUT ANY SUPPORT. 
# Matthieu PERRIN - 2014


if [ -z "$3" ]
then
    echo "Usage : $0 plugin hostname service 'arguments1 arguments2'"
    exit 3
fi

PATH=$PATH:/usr/local/nagios/libexec

check=$1
hostname=$2
service=$3
arg1=$4

res=3

text=$($check $arg1)
res=$(echo $?)

echo "$hostname;$service;$res;$text"
