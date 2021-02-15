FROM hjben/centos-openjdk:11
MAINTAINER hjben <hj.ben.kim@gmail.com>

ENV HADOOP_HOME /usr/local/hadoop
ENV HADOOP_VERSION 3.2.2

RUN if [ ! -e /usr/bin/python ]; then ln -s /usr/bin/python2.7 /usr/bin/python; fi

RUN wget https://archive.apache.org/dist/hadoop/core/hadoop-$HADOOP_VERSION/hadoop-$HADOOP_VERSION.tar.gz
RUN tar -xzf hadoop-$HADOOP_VERSION.tar.gz
RUN rm -f hadoop-$HADOOP_VERSION.tar.gz
RUN mv hadoop-$HADOOP_VERSION $HADOOP_HOME

RUN for user in hadoop hdfs yarn mapred; do \
         useradd -U -M -d $HADOOP_HOME --shell /bin/bash ${user}; \
    done

RUN for user in root hdfs yarn mapred; do \
         usermod -G hadoop ${user}; \
    done

RUN echo "export JAVA_HOME=$JAVA_HOME" >> $HADOOP_HOME/etc/hadoop/hadoop-env.sh && \
    echo "export HDFS_DATANODE_USER=root" >> $HADOOP_HOME/etc/hadoop/hadoop-env.sh && \
    echo "export HDFS_NAMENODE_USER=root" >> $HADOOP_HOME/etc/hadoop/hadoop-env.sh && \
    echo "export HDFS_SECONDARYNAMENODE_USER=root" >> $HADOOP_HOME/etc/hadoop/hadoop-env.sh && \
    echo "export YARN_RESOURCEMANAGER_USER=root" >> $HADOOP_HOME/etc/hadoop/yarn-env.sh && \
    echo "export YARN_NODEMANAGER_USER=root" >> $HADOOP_HOME/etc/hadoop/yarn-env.sh && \
    echo "PATH=$PATH:$HADOOP_HOME/bin" >> ~/.bashrc

RUN ssh-keygen -t rsa -P '' -f ~/.ssh/id_rsa && \
    cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys && \
    chmod 0600 ~/.ssh/authorized_keys

ADD *xml $HADOOP_HOME/etc/hadoop/
ADD workers $HADOOP_HOME/etc/hadoop/workers

ADD ssh_config /root/.ssh/config
ADD *start-all.sh /
RUN chmod 755 *start-all.sh
RUN mkdir -p $HADOOP_HOME/logs
RUN mkdir -p /data/hadoop/dfs

EXPOSE 50010 50020 50070 50075 50090 8020 9000
EXPOSE 10020 19888
EXPOSE 8088 9870 9864 19888 8042 8888

ENTRYPOINT ["/usr/sbin/init"]
