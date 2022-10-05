#!/bin/bash

source ./ddns_updater.conf

previous_public_ip=`cat $ip_file`
current_public_ip='192.168.1.1'

if [[ $current_public_ip == $previous_public_ip ]]; then
  echo "equal" >> $run_log
  exit 0
else
  echo "not" >> $run_log
  echo $current_public_ip > $ip_file
fi

echo $previous_public_ip
echo $ip_file
