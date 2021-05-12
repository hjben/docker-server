FROM hjben/hadoop:3.3.0-jdk1.8.0
MAINTAINER hjben <hj.ben.kim@gmail.com>

ENV HADOOP_CONF_DIR $HADOOP_HOME/etc/hadoop
ENV SQOOP_HOME /usr/local/sqoop
ENV SQOOP_VERSION 1.4.7
ENV SQOOP_HADOOP_VERSION 2.6.0
ENV MARIADB_CONNECTOR_VERSION 2.7.2
ENV PATH $PATH:$SQOOP_HOME/bin

RUN wget https://downloads.apache.org/sqoop/$SQOOP_VERSION/sqoop-$SQOOP_VERSION.bin__hadoop-$SQOOP_HADOOP_VERSION.tar.gz
RUN tar -xzf sqoop-$SQOOP_VERSION.bin__hadoop-$SQOOP_HADOOP_VERSION.tar.gz -C /usr/local && \
    rm -f sqoop-$SQOOP_VERSION.bin__hadoop-$SQOOP_HADOOP_VERSION.tar.gz
RUN ln -s /usr/local/sqoop-$SQOOP_VERSION.bin__hadoop-$SQOOP_HADOOP_VERSION $SQOOP_HOME

RUN wget https://downloads.mariadb.com/Connectors/java/connector-java-$MARIADB_CONNECTOR_VERSION/mariadb-java-client-$MARIADB_CONNECTOR_VERSION.jar
RUN mv mariadb-java-client-$MARIADB_CONNECTOR_VERSION.jar $SQOOP_HOME/lib/

RUN rm -f $SQOOP_HOME/lib/guava-*.jar && cp $HADOOP_HOME/share/hadoop/hdfs/lib/guava-*.jar $SQOOP_HOME/lib/
ADD lib/*.jar $SQOOP_HOME/lib/

