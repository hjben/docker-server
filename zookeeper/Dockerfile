FROM hjben/centos-openjdk:11
MAINTAINER hjben <hj.ben.kim@gmail.com>

ENV ZOOKEEPER_HOME /usr/local/zookeeper
ENV ZOOKEEPER_VERSION 3.6.2
ENV ZOOKEEPER_DATA_DIR /data
ENV PATH $PATH:$ZOOKEEPER_HOME/bin

RUN wget https://downloads.apache.org/zookeeper/zookeeper-$ZOOKEEPER_VERSION/apache-zookeeper-$ZOOKEEPER_VERSION-bin.tar.gz
RUN tar -xvzf apache-zookeeper-$ZOOKEEPER_VERSION-bin.tar.gz -C /usr/local && \
    rm -f /apache-zookeeper-$ZOOKEEPER_VERSION-bin.tar.gz
RUN ln -s /usr/local/apache-zookeeper-$ZOOKEEPER_VERSION-bin $ZOOKEEPER_HOME

ADD conf/zoo.cfg $ZOOKEEPER_HOME/conf/zoo.cfg
ADD sh/zkInit.sh $ZOOKEEPER_HOME/bin/zkInit.sh
RUN chmod 755 $ZOOKEEPER_HOME/bin/zkInit.sh

RUN mkdir -p $ZOOKEEPER_DATA_DIR
RUN echo dataDir=$(echo $ZOOKEEPER_DATA_DIR) >> $ZOOKEEPER_HOME/conf/zoo.cfg
RUN echo dynamicConfigFile=$(echo $ZOOKEEPER_HOME)/conf/zoo.cfg.dynamic >> $ZOOKEEPER_HOME/conf/zoo.cfg

EXPOSE 2181 2888 3888 8080
