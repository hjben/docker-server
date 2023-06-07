FROM hjben/centos-openjdk:11
MAINTAINER hjben <hj.ben.kim@gmail.com>

ENV SPARK_HOME /usr/local/spark
ENV SPARK_CLASSPATH $SPARK_HOME/jars
ENV SPARK_VERSION 3.1.1
ENV SPARK_HADOOP_VERSION 3.2
ENV HADOOP_CONF_DIR $SPARK_HOME/hadoop-conf/hadoop/conf/
ENV HADOOP_USER_NAME root
ENV PATH $PATH:$SPARK_HOME/bin:$SPARK_HOME/sbin

RUN dnf install -y python38
RUN dnf install -y git

WORKDIR /usr/bin
RUN ln -s python3 python && ln -s pip3 pip

WORKDIR /
RUN wget https://archive.apache.org/dist/spark/spark-$SPARK_VERSION/spark-$SPARK_VERSION-bin-hadoop$SPARK_HADOOP_VERSION.tgz
RUN tar -xvzf spark-$SPARK_VERSION-bin-hadoop$SPARK_HADOOP_VERSION.tgz -C /usr/local && \
    rm -f spark-$SPARK_VERSION-bin-hadoop$SPARK_HADOOP_VERSION.tgz
RUN ln -s /usr/local/spark-$SPARK_VERSION-bin-hadoop$SPARK_HADOOP_VERSION $SPARK_HOME

RUN ssh-keygen -t rsa -P '' -f ~/.ssh/id_rsa && \
    cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys && \
    chmod 0600 ~/.ssh/authorized_keys

ADD conf/spark-defaults.conf $SPARK_HOME/conf/

RUN git clone https://github.com/hjben/docker.git
RUN mv docker/ $HADOOP_CONF_DIR

EXPOSE 8080-8099
EXPOSE 4040-4099
EXPOSE 7077
