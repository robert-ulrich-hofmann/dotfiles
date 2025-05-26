#!/bin/bash -

# this script needs sudo or root execution

# add this to root crontab with this line:
#@reboot sh /home/robert/cpu-setup.sh i j k X.XX

# Intel® Core™ Ultra 7 Processor 155H core layout (HT disabled in BIOS!)
#  0 -  5 performance cores          base 1.4 GHz max 4.8 GHz
#  6 - 13 efficiency cores           base 0.9 GHz max 3.8 GHz
# 14 - 15 low power efficiency cores base 0.7 GHz max 2.5 GHz

# reset cores
# performance
# touching cpu0 always results in a "permission denied" error
echo 1 > /sys/devices/system/cpu/cpu1/online
echo 1 > /sys/devices/system/cpu/cpu2/online
echo 1 > /sys/devices/system/cpu/cpu3/online
echo 1 > /sys/devices/system/cpu/cpu4/online
echo 1 > /sys/devices/system/cpu/cpu5/online
# efficiency
echo 1 > /sys/devices/system/cpu/cpu6/online
echo 1 > /sys/devices/system/cpu/cpu7/online
echo 1 > /sys/devices/system/cpu/cpu8/online
echo 1 > /sys/devices/system/cpu/cpu9/online
echo 1 > /sys/devices/system/cpu/cpu10/online
echo 1 > /sys/devices/system/cpu/cpu11/online
echo 1 > /sys/devices/system/cpu/cpu12/online
echo 1 > /sys/devices/system/cpu/cpu13/online
# low power efficiency
echo 1 > /sys/devices/system/cpu/cpu14/online
echo 1 > /sys/devices/system/cpu/cpu15/online

# guards:
# non existing parameter
# parameter no natural number
# number not in range of respective core count
if ! [[ $1 =~ ^[0-9]+$ ]] ||
   ! [[ $1 -ge 1 && $1 -le 6 ]]
then
    echo "No valid value for number of performance cores,"\
         "must be between 1 and 6"
    exit 1
fi
if ! [[ $2 =~ ^[0-9]+$ ]] ||
   ! [[ $2 -ge 0 && $2 -le 8 ]]
then
    echo "No valid value for number of efficiency cores,"\
         "must be between 0 and 8"
    exit 1
fi
if ! [[ $3 =~ ^[0-9]+$ ]] ||
   ! [[ $3 -ge 0 && $3 -le 2 ]]
then
    echo "No valid value for number of low power efficiency cores,"\
         "must be between 0 and 2"
    exit 1
fi

# guard:
# non existing parameter
if ! [[ $4 ]]
then
    echo "No value for frequency given,"\
         "must be between 1.4 and 4.8"
    exit 1
fi

# choose cores
# shut off unwanted performance cores
i=$1

while [ "$i" -lt 6 ]
do
    echo "Shutting off core cpu$i"
    echo 0 > /sys/devices/system/cpu/cpu"$i"/online

    i=$(( i+1 ))
done

# shut off unwanted efficiency cores
i=$(( 6 + $2 ))

while [ "$i" -lt 14 ]
do
    echo "Shutting off core cpu$i"
    echo 0 > /sys/devices/system/cpu/cpu"$i"/online

    i=$(( i+1 ))
done

# shut off unwanted low power efficiency cores
i=$(( 14 + $3 ))

while [ "$i" -lt 16 ]
do
    echo "Shutting off core cpu$i"
    echo 0 > /sys/devices/system/cpu/cpu"$i"/online

    i=$(( i+1 ))
done

# configure cores: governor
# available governors are performance and powersave
# performance: slight boost but way worse thermals and battery life in x11
# performance: slight boost and smoother software cursor in wayland
echo "Setting cpu governor powersave"
cpupower frequency-set --governor performance

# configures cores: frequency
# parameter should only be used when between 1.4 and 4.8
if [[ 1 -eq "$(echo "$4 >= 1.4" | bc)" ]] &&
   [[ 1 -eq "$(echo "$4 <= 4.8" | bc)" ]]
then
    echo "Valid value for frequency given, using $4GHz"
    cpupower frequency-set -u "$4"GHz
else
    echo "No valid value (1.4GHz - 4.8GHz) for frequency given, using 2.5GHz"
    cpupower frequency-set -u 2.5GHz
fi

exit 0
