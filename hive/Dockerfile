FROM hjben/hadoop:3.3.0-jdk1.8.0
MAINTAINER hjben <hj.ben.kim@gmail.com>

ENV HADOOP_CONF_DIR $HADOOP_HOME/etc/hadoop
ENV HIVE_HOME /usr/local/hive
ENV HIVE_VERSION 3.1.1
ENV MARIADB_CONNECTOR_VERSION 2.7.2
ENV PATH $PATH:$HIVE_HOME/bin

RUN wget https://archive.apache.org/dist/hive/hive-$HIVE_VERSION/apache-hive-$HIVE_VERSION-bin.tar.gz
RUN tar -xzf apache-hive-$HIVE_VERSION-bin.tar.gz -C /usr/local && \
    rm -f apache-hive-$HIVE_VERSION-bin.tar.gz
RUN ln -s /usr/local/apache-hive-$HIVE_VERSION-bin $HIVE_HOME

RUN wget https://downloads.mariadb.com/Connectors/java/connector-java-$MARIADB_CONNECTOR_VERSION/mariadb-java-client-$MARIADB_CONNECTOR_VERSION.jar
RUN mv mariadb-java-client-$MARIADB_CONNECTOR_VERSION.jar $HIVE_HOME/lib/

ADD hive-site.xml $HIVE_HOME/conf/
ADD *sh $HIVE_HOME/bin/
RUN rm -f $HIVE_HOME/lib/guava-*.jar && cp $HADOOP_HOME/share/hadoop/hdfs/lib/guava-*.jar $HIVE_HOME/lib/
RUN mkdir $HIVE_HOME/logs

EXPOSE 9083 10000 10002

ENTRYPOINT ["/usr/sbin/init"]
