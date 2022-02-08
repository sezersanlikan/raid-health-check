#!/bin/bash
if [[ `/opt/MegaRAID/MegaCli/MegaCli64 -AdpAllInfo -aAll | grep "Critical Disk" | awk {'print $4'}` -ne 0 ]];
then
    echo "You have `/opt/MegaRAID/MegaCli/MegaCli64 -AdpAllInfo -aAll | grep "Critical Disk" | awk {'print $4'}` disk in Critical Condition" >> /var/log/raid-health-check.log ;
fi
if [[ `/opt/MegaRAID/MegaCli/MegaCli64 -AdpAllInfo -aAll | grep "Failed Disk" | awk {'print $4'}` -ne 0 ]];
then
    echo "You have `/opt/MegaRAID/MegaCli/MegaCli64 -AdpAllInfo -aAll | grep "Critical Disk" | awk {'print $4'}` disk in Failed Condition" >> /var/log/raid-health-check.log ;
fi
if [ `/opt/MegaRAID/MegaCli/MegaCli64 -AdpAllInfo -aAll | grep "Critical Disk" | awk {'print $4'}` -ne 0 ] && [ `/opt/MegaRAID/MegaCli/MegaCli64 -AdpAllInfo -aAll | grep "Failed Disk" | awk {'print $4'}` -ne 0 ] ;
then
    #SEND MAIL
    echo "===> [`date`] <===" >> /var/log/raid-health-check.log ;
    echo "--------------- DISK STATUS ---------------" >> /var/log/raid-health-check.log ;
    echo `/opt/MegaRAID/MegaCli/MegaCli64 -PDList -aALL | awk -f analysis.awk` | sed "s/\,/\n/g"  >> /var/log/raid-health-check.log ;
    echo "\n" >> /var/log/raid-health-check.log ;
    echo "--------------- SYSTEM INFO ---------------" >> /var/log/raid-health-check.log ;
    echo "`cat /etc/hosts`" >> /var/log/raid-health-check.log ;
    swaks --to sezer@sezer.test -from alert@sezer.test -s mail.sezer.test:587 -au alert@sezer.test -ap mailpassword --body /var/log/raid-health-check.log --header "Subject: Raid Disk Alarm"
fi

rm -rf /var/log/raid-health-check.log
rm -rf CmdTool.log
rm -rf MegaSAS.log
