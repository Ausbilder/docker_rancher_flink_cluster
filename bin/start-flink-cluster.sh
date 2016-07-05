#!/bin/bash

CONF=/usr/local/flink-1.0.3/conf
EXEC=/usr/local/flink-1.0.3/bin

#override hosts file
$EXEC/rancher-config.sh

#run ssh server
service sshd start


#set up config
sed -i -e "s/tm_slots/$FLINK_TM_SLOTS/g" $CONF/flink-conf.yaml
sed -i -e "s/tm_heap/$FLINK_TM_RAM/g" $CONF/flink-conf.yaml
sed -i -e "s/jm_heap/$FLINK_JM_RAM/g" $CONF/flink-conf.yaml

#start master
if [ "$1" == "master" ]; then
	echo "Setting up Jobmanager on this Node!"

	sed -i -e "s/jm_hostname/$(hostname)/g" $CONF/flink-conf.yaml	

	echo "Getting Container List for Service Taskmanager"
	source /usr/local/flink-1.0.3/bin/getContainerListForService.sh taskmanager
	
	echo "Saving Taskmanagers to slaves File"
	for host_name in "${!CONTAINER[@]}";
	do
		echo "Adding Taskmanager $host_name"
		echo "$host_name" >> "$CONF"/slaves	
	done

	$EXEC/start-cluster.sh streaming     

#start client
else
	stack=$(curl http://rancher-metadata/latest/self/stack/name)
	jobmanager_hostname="$stack"_jobmanager_1
	echo "Setting Jobmanager Hostname: $jobmanager_hostname"		
	sed -i -e "s/jm_hostname/$jobmanager_hostname/g" $CONF/flink-conf.yaml	

	echo "Setting up Taskmanager"
	echo "I am a worker Node, waiting for ssh connection of Master"
fi

#print out config - debug
echo "flink-conf.yaml: " && cat $CONF/flink-conf.yaml
echo "slaves file: " && cat $CONF/slaves

#run supervisor to keep container running.
supervisord -c /etc/supervisord.conf
