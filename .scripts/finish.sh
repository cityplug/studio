#!/bin/bash

echo
sudo docker-compose up -d
docker ps -a

echo "
net.ipv4.ip_forward = 1
net.ipv6.conf.all.forwarding = 1" >> /etc/sysctl.conf
sysctl -p

# --- Aliases
echo "# --- Creating bash_aliases --- #"

echo "
alias start-busybox='docker run -it ubuntu'
" >> /home/shay/.bash_aliases

#docker exec -it ubuntu

echo "#  ---  COMPLETED | REBOOT SYSTEM  ---  #"
reboot



