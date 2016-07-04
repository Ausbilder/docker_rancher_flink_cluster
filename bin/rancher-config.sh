#!/bin/bash

#fix etc/hosts file for working rancher dns
#debug
echo "OLD hosts file: " && cat etc/hosts
echo "-----------------"

#override hostfile with hostname in etc/hosts -> dns lookup over rancher
myIP=$(curl http://rancher-metadata/latest/self/container/primary_ip)

echo "$myIP  $(hostname) " > /etc/hosts
echo "-----------------"

#debug
echo "NEW hosts file: " && cat etc/hosts
echo "-----------------"
