#FLINK STANDALONE

FROM svenahlfeld/flinklocal:1.0.3

ENV FLINK_HOME /usr/local/flink-1.0.3
ENV PATH $PATH:$FLINK_HOME/bin

#config files
#remove defaults
ADD conf/flink-conf.yaml $FLINK_HOME/conf/
ADD conf/slaves $FLINK_HOME/conf/

#remove old startup script
RUN rm $FLINK_HOME/bin/bootstrap.sh

#add cluster startup script
ADD bin/start-flink-cluster.sh $FLINK_HOME/bin/
RUN chmod +x $FLINK_HOME/bin/start-flink-cluster.sh

#add rancher networking script
ADD bin/rancher-config.sh $FLINK_HOME/bin
RUN chmod +x $FLINK_HOME/bin/rancher-config.sh

#add rancher container script
ADD bin/getContainerListForService.sh $FLINK_HOME/bin
RUN chmod +x $FLINK_HOME/bin/getContainerListForService.sh

#PORTS
EXPOSE 22 3306 6121 6122 6123 8080 8081

CMD ["/usr/local/flink-1.0.3/bin/start-flink-cluster.sh"]
