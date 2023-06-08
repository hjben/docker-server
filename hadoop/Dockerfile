FROM hjben/rockylinux-openjdk:11
MAINTAINER hjben <hj.ben.kim@gmail.com>

ENV HADOOP_HOME /usr/local/hadoop
ENV HADOOP_VERSION 3.3.5
ENV PATH=$PATH:$HADOOP_HOME/bin

RUN if [ ! -e /usr/bin/python ]; then ln -s /usr/bin/python2.7 /usr/bin/python; fi

RUN wget https://archive.apache.org/dist/hadoop/core/hadoop-$HADOOP_VERSION/hadoop-$HADOOP_VERSION.tar.gz
RUN tar -xzf hadoop-$HADOOP_VERSION.tar.gz -C /usr/local && \
    rm -f hadoop-$HADOOP_VERSION.tar.gz
RUN ln -s /usr/local/hadoop-$HADOOP_VERSION $HADOOP_HOME

RUN mkdir -p $HADOOP_HOME/logs
RUN mkdir -p /data/hadoop/dfs
RUN mkdir -p /sh

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
    echo "export YARN_NODEMANAGER_USER=root" >> $HADOOP_HOME/etc/hadoop/yarn-env.sh

RUN ssh-keygen -t rsa -P '' -f ~/.ssh/id_rsa && \
    cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys && \
    chmod 0600 ~/.ssh/authorized_keys

ADD conf/*xml $HADOOP_HOME/etc/hadoop/
ADD conf/hadoop-functions.sh $HADOOP_HOME/libexec/

ADD conf/ssh_config /root/.ssh/config
ADD sh/*start-all.sh /sh/
RUN chmod 755 /sh/*start-all.sh

EXPOSE 9864 9866 9867 9868 9870  
EXPOSE 8020 8042 8050 8088 8888 9000 10020 19888
