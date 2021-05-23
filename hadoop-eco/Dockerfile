FROM hjben/hbase:1.6.0-hadoop3.3.0
MAINTAINER hjben <hj.ben.kim@gmail.com>

ENV HADOOP_CONF_DIR $HADOOP_HOME/etc/hadoop
ENV HIVE_HOME /usr/local/hive
ENV HIVE_VERSION 3.1.2
ENV HIVE_CONF_DIR $HIVE_HOME/conf
ENV SQOOP_HOME /usr/local/sqoop
ENV SQOOP_VERSION 1.4.7
ENV SQOOP_HADOOP_VERSION 2.6.0
ENV MARIADB_CONNECTOR_VERSION 2.7.2
ENV PATH $PATH:$HIVE_HOME/bin:$SQOOP_HOME/bin

RUN wget https://archive.apache.org/dist/hive/hive-$HIVE_VERSION/apache-hive-$HIVE_VERSION-bin.tar.gz
RUN tar -xzf apache-hive-$HIVE_VERSION-bin.tar.gz -C /usr/local && \
    rm -f apache-hive-$HIVE_VERSION-bin.tar.gz
RUN ln -s /usr/local/apache-hive-$HIVE_VERSION-bin $HIVE_HOME

ADD hive/conf/hive-site.xml $HIVE_HOME/conf/
ADD hive/sh/*sh $HIVE_HOME/bin/
RUN chmod 755 $HIVE_HOME/bin/init-hive-dfs.sh
RUN chmod 755 $HIVE_HOME/bin/stop-server.sh
RUN mkdir $HIVE_HOME/logs

RUN wget https://downloads.apache.org/sqoop/$SQOOP_VERSION/sqoop-$SQOOP_VERSION.bin__hadoop-$SQOOP_HADOOP_VERSION.tar.gz
RUN tar -xzf sqoop-$SQOOP_VERSION.bin__hadoop-$SQOOP_HADOOP_VERSION.tar.gz -C /usr/local && \
    rm -f sqoop-$SQOOP_VERSION.bin__hadoop-$SQOOP_HADOOP_VERSION.tar.gz
RUN ln -s /usr/local/sqoop-$SQOOP_VERSION.bin__hadoop-$SQOOP_HADOOP_VERSION $SQOOP_HOME

ADD sqoop/lib/*.jar $SQOOP_HOME/lib/
ADD hbase/lib/*.jar $SQOOP_HOME/lib/

RUN for lib in client common protocol server; do \
	cp $HBASE_HOME/lib/hbase-${lib}-$HBASE_VERSION.jar $SQOOP_HOME/lib/; \
    done

RUN rm -f $HIVE_HOME/lib/guava-*.jar && cp $HADOOP_HOME/share/hadoop/hdfs/lib/guava-*.jar $HIVE_HOME/lib/
RUN rm -f $SQOOP_HOME/lib/guava-*.jar && cp $HADOOP_HOME/share/hadoop/hdfs/lib/guava-*.jar $SQOOP_HOME/lib/

RUN wget https://downloads.mariadb.com/Connectors/java/connector-java-$MARIADB_CONNECTOR_VERSION/mariadb-java-client-$MARIADB_CONNECTOR_VERSION.jar
RUN cp mariadb-java-client-$MARIADB_CONNECTOR_VERSION.jar $HIVE_HOME/lib/
RUN mv mariadb-java-client-$MARIADB_CONNECTOR_VERSION.jar $SQOOP_HOME/lib/

EXPOSE 9083 10000 10002

