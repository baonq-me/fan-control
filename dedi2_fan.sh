#!/bin/bash

# I use this on my DL380p Gen8 running Proxmox VE 7.2.
# The server has two of its eight SFF bays populated and is otherwise stock.
# I consider this a safer solution than explicitly disabling sensors or
# throttling fans because it reduces the minimum fan speed for an overreactive
# sensor while keeping all other fan curves. I wouldn't say this silences the
# server, but it does make it magnitudes quieter. Referenced from
# https://www.reddit.com/r/homelab/comments/di3vrk/silence_of_the_fans_controlling_hp_server_fans/firx6op/

# Replace these values with those relevant to your iLO. Alternatively,
# consider defining them with environment variables.

IP=192.168.1.9
USER='Administrator'
PWD='xxxxxx'
OPT='-oKexAlgorithms=+diffie-hellman-group14-sha1 -o StrictHostKeyChecking=no'
#SPEED='70'

ssh-keygen -f "/root/.ssh/known_hosts" -R "192.168.1.9"

# 50
#sshpass -p ${PWD} ssh ${OPT} $USER@$IP 'fan p 0 lock 70' # 50
#sshpass -p ${PWD} ssh ${OPT} $USER@$IP 'fan p 1 lock 70' # 50
#sshpass -p ${PWD} ssh ${OPT} $USER@$IP 'fan p 2 lock 70' # 50
#sshpass -p ${PWD} ssh ${OPT} $USER@$IP 'fan p 3 lock 70' # 50
#sshpass -p ${PWD} ssh ${OPT} $USER@$IP 'fan p 4 lock 70' # 60
#sshpass -p ${PWD} ssh ${OPT} $USER@$IP 'fan p 5 lock 70' # 60

for i in {0..5}
do
  fan_speed=70
  #if [ $i -gt 3 ]
  #then
  #  fan_speed=80
  #fi
  until sshpass -p ${PWD} ssh ${OPT} $USER@$IP "fan p $i lock $fan_speed"; do
     echo "Sleeping for 3 seconds";
     sleep 3
  done
done

# The script can be triggered on startup with a crontab.
# While writing the cron job, a one liner can be used instead:
# @reboot sshpass -p password ssh -oKexAlgorithms=+diffie-hellman-group14-sha1 Administrator@x.x.x.x 'fan pid 47 lo 1600'
