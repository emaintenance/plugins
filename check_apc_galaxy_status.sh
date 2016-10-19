#!/bin/bash
# THIS PLUGIN IS PROVIDED "AS IS", WITHOUT ANY WARRANTY, AND WITHOUT ANY SUPPORT. 
# Matthieu PERRIN (eMaintenance) - Oct 2016

#. check_apc_status.txt
msg[1]="Abnormal Condition Present"
msg[2]="On Battery"
msg[3]="Low Battery"
msg[4]="On Line"

msg[5]="Replace Battery"
msg[6]="Serial Communication Established"
msg[7]="AVR Boost Active"
msg[8]="AVR Trim Active"

msg[9]="Overload"
msg[10]="Runtime Calibration"
msg[11]="Batteries Discharged"
msg[12]="Manual Bypass"

msg[13]="Software Bypass"
msg[14]="In Bypass due to Internal Fault"
msg[15]="In Bypass due to Supply Failure"
msg[16]="In Bypass due to Fan Failure"

msg[17]="Sleeping on a Timer"
msg[18]="Sleeping until Utility Power Returns"
msg[19]="On"
msg[20]="Rebooting"

msg[21]="Battery Communication Lost"
msg[22]="Graceful Shutdown Initiated"
msg[23]="Smart Boost or Smart Trim Fault"
msg[24]="Bad Output Voltage"

msg[25]="Battery Charger Failure"
msg[26]="High Battery Temperature"
msg[27]="Warning Battery Temperature"
msg[28]="Critical Battery Temperature"

msg[29]="Self Test In Progress"
msg[30]="Low Battery / On Battery"
msg[31]="Graceful Shutdown Issued by Upstream Device"
msg[32]="Graceful Shutdown Issued by Downstream Device"

msg[33]="No Batteries Attached"
msg[34]="Synchronized Command is in Progress"
msg[35]="Synchronized Sleeping Command is in Progress"
msg[36]="Synchronized Rebooting Command is in Progress"

msg[37]="Inverter DC Imbalance"
msg[38]="Transfer Relay Failure"
msg[39]="Shutdown or Unable to Transfer"
msg[40]="Low Battery Shutdown"

msg[41]="Electronic Unit Fan Failure"
msg[42]="Main Relay Failure"
msg[43]="Bypass Relay Failure"
msg[44]="Temporary Bypass"

msg[45]="High Internal Temperature"
msg[46]="Battery Temperature Sensor Fault"
msg[47]="Input Out of Range for Bypass"
msg[48]="DC Bus Overvoltage"

msg[49]="PFC Failure"
msg[50]="Critical Hardware Fault"
msg[51]="Green Mode/ECO Mode"
msg[52]="Hot Standby"

msg[53]="Emergency Power Off (EPO) Activated"
msg[54]="Load Alarm Violation"
msg[55]="Bypass Phase Fault"
msg[56]="UPS Internal Communication Failure"



[ -z $2 ] && echo "Usage : $0 community IP" && exit 3


status=$(snmpwalk -Oqv -v2c -c "$1" "$2" .1.3.6.1.4.1.318.1.1.1.11.1.1)
[ -z $status ] && exit 3

for i in {1..56}
do

if [ ${status:$i:1} -eq 1 ] ; then
        echo -n "${msg[$i]}. "

fi

done

echo ""

if [ "$status" == "\"0001010000000000001000000000000000000000000000000000000000000000\"" ]
then
        exit 0
else
        exit 1
fi

exit 3
