#!/bin/bash -

# this needs sudo or root execution
# add this to root crontab with this line:
#@reboot sh /home/robert/cpu-start.sh

# Intel® Core™ Ultra 7 Processor 155H core layout (HT disabled in BIOS!)
#  0 -  5 performance cores          base 1.4 GHz max 4.8 GHz
#  6 - 13 efficiency cores           base 0.9 GHz max 3.8 GHz
# 14 - 15 low power efficiency cores base 0.7 GHz max 2.5 GHz

# shut off the 8 efficiency cores
#echo 0 > /sys/devices/system/cpu/cpu6/online
#echo 0 > /sys/devices/system/cpu/cpu7/online
#echo 0 > /sys/devices/system/cpu/cpu8/online
#echo 0 > /sys/devices/system/cpu/cpu9/online
#echo 0 > /sys/devices/system/cpu/cpu10/online
#echo 0 > /sys/devices/system/cpu/cpu11/online
#echo 0 > /sys/devices/system/cpu/cpu12/online
#echo 0 > /sys/devices/system/cpu/cpu13/online

# shut off the 2 low power efficiency cores
echo 0 > /sys/devices/system/cpu/cpu14/online
echo 0 > /sys/devices/system/cpu/cpu15/online

# no parameter, using "safe" value (common max turbo across all cores)
if [ -z "$1" ]
then
    echo "No value for frequency given, using 2.5GHz"
    cpupower frequency-set -u 2.5GHz
    exit 1
fi

# parameter should only be used when between 1.4 and 4.8
if [[ 1 -eq "$(echo "$1 >= 1.4" | bc)" ]] && [[ 1 -eq "$(echo "$1 <= 4.8" | bc)" ]]
then
    echo "Valid value for frequency given, using $1GHz"
    cpupower frequency-set -u "$1"GHz
    exit 1
else
    echo "No valid value (1.4GHz - 4.8GHz) for frequency given, using 2.5GHz"
    cpupower frequency-set -u 2.5GHz
    exit 1
fi
