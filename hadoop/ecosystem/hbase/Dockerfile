FROM hjben/hadoop:3.3.0-jdk1.8.0
MAINTAINER hjben <hj.ben.kim@gmail.com>

ENV HBASE_HOME /usr/local/hbase
ENV HBASE_VERSION 2.4.2
ENV HBASE_PID_DIR $HBASE_HOME/pid
ENV HBASE_REGIONSERVERS $HBASE_HOME/conf/regionservers
ENV HBASE_MANAGES_ZK false
ENV PATH $PATH:$HBASE_HOME/bin

RUN wget https://archive.apache.org/dist/hbase/$HBASE_VERSION/hbase-$HBASE_VERSION-bin.tar.gz
RUN tar -xzf /hbase-$HBASE_VERSION-bin.tar.gz -C /usr/local && \
    rm -f /hbase-$HBASE_VERSION-bin.tar.gz
RUN ln -s /usr/local/hbase-$HBASE_VERSION $HBASE_HOME

ADD conf/regionservers $HBASE_HOME/conf
ADD conf/hbase-site.xml $HBASE_HOME/conf

RUN echo export JAVA_HOME=$(echo $JAVA_HOME) >> $HBASE_HOME/conf/hbase-env.sh
RUN mkdir $HBASE_HOME/logs

EXPOSE 16010 60010 60030

