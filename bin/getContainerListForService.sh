#!/bin/bash
#declare a dictionary Hostname:IP
declare -A CONTAINER
container_map=$(curl http://rancher-metadata/latest/services/$1/containers)	
for host in $container_map;
do
	index=`expr index "$host" =`
	container_name=${host:index+1}
	container_ip=$(curl http://rancher-metadata/latest/containers/$container_name/primary_ip)
	CONTAINER+=(["$container_name"]="$container_ip")
done

for key in "${!CONTAINER[@]}";
do
echo "$key - ${CONTAINER["$key"]}"
done