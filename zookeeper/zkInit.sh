#!/bin/bash

ZK=$1

if [ -n "$ZK" ]
then
  rm -f $ZOOKEEPER_HOME/conf/zoo.cfg.dynamic
  echo "`zkCli.sh -server $ZK:2181 get /zookeeper/config | grep ^server`" >> $ZOOKEEPER_HOME/conf/zoo.cfg.dynamic
  echo "server.$MYID=$HOSTNAME:2888:3888:participant;2181" >> $ZOOKEEPER_HOME/conf/zoo.cfg.dynamic
  zkServer-initialize.sh --force --myid=$MYID
  zkServer.sh start
  zkCli.sh -server $ZK:2181 reconfig -file $ZOOKEEPER_HOME/conf/zoo.cfg.dynamic
  zkServer.sh stop

else
  echo "server.$MYID=$HOSTNAME:2888:3888:participant;2181" >> $ZOOKEEPER_HOME/conf/zoo.cfg.dynamic
  zkServer-initialize.sh --force --myid=$MYID
fi