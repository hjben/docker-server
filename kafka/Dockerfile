FROM hjben/centos-openjdk:11
MAINTAINER hjben <hj.ben.kim@gmail.com>

ENV SCALA_HOME /usr/local/scala
ENV SCALA_VERSION 2.13
ENV SCALA_SUB_VERSION 0
ENV KAFKA_HOME /usr/local/kafka
ENV KAFKA_VERSION 2.7.0
ENV PATH $PATH:$SCALA_HOME/bin:$KAFKA_HOME/bin

RUN wget http://www.scala-lang.org/files/archive/scala-$SCALA_VERSION.$SCALA_SUB_VERSION.tgz
RUN tar -xvf scala-$SCALA_VERSION.$SCALA_SUB_VERSION.tgz -C /usr/local && \
    rm -f scala-$SCALA_VERSION.$SCALA_SUB_VERSION.tgz
RUN ln -s /usr/local/scala-$SCALA_VERSION.$SCALA_SUB_VERSION $SCALA_HOME

RUN wget https://archive.apache.org/dist/kafka/$KAFKA_VERSION/kafka_$SCALA_VERSION-$KAFKA_VERSION.tgz
RUN tar -xvf kafka_$SCALA_VERSION-$KAFKA_VERSION.tgz -C /usr/local && \
    rm -f kafka_$SCALA_VERSION-$KAFKA_VERSION.tgz
RUN ln -s /usr/local/kafka_$SCALA_VERSION-$KAFKA_VERSION/ $KAFKA_HOME  

ADD server.properties $KAFKA_HOME/config/server.properties
ADD start-kafka.sh /
RUN chmod 755 start-kafka.sh

EXPOSE 9092-9099
EXPOSE 9999

