#!bin/bash -

# this needs sudo or root execution

# Intel® Core™ Ultra 7 Processor 155H core layout (HT disabled in BIOS!)
#  0 -  5 performance cores          base 1.4 GHz max 4.8 GHz
#  6 - 13 efficiency cores           base 0.9 GHz max 3.8 GHz
# 14 - 15 low power efficiency cores base 0.7 GHz max 2.5 GHz

# shut off the 8 efficiency cores
echo 0 > /sys/devices/system/cpu/cpu6/online
echo 0 > /sys/devices/system/cpu/cpu7/online
echo 0 > /sys/devices/system/cpu/cpu8/online
echo 0 > /sys/devices/system/cpu/cpu9/online
echo 0 > /sys/devices/system/cpu/cpu10/online
echo 0 > /sys/devices/system/cpu/cpu11/online
echo 0 > /sys/devices/system/cpu/cpu12/online
echo 0 > /sys/devices/system/cpu/cpu13/online

# shut off the 2 low power efficiency cores
echo 0 > /sys/devices/system/cpu/cpu14/online
echo 0 > /sys/devices/system/cpu/cpu15/online

# no parameter
if [ -z $1 ]
then
    echo "No value for frequency given, using 2.4GHz"
    cpupower frequency-set -u 2.4GHz
    watch -n 1 cpupower monitor
    exit 1
fi

# parameter should only be used when between 1.4 and 4.8
if [[ 1 -eq "$(echo "$1 >= 1.4" | bc)" ]] && [[ 1 -eq "$(echo "$1 <= 4.8" | bc)" ]]
then
    echo "Valid value for frequency given, using $1GHz"
    cpupower frequency-set -u $1GHz
    watch -n 1 cpupower monitor
    exit 1
else
    echo "No valid value (1.4GHz - 4.8GHz) for frequency given, using 2.4GHz"
    cpupower frequency-set -u 2.4GHz
    watch -n 1 cpupower monitor
    exit 1
fi
