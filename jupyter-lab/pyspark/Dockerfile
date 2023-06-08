FROM hjben/jupyter-lab:latest
MAINTAINER hjben <hj.ben.kim@gmail.com>

ENV SPARK_VERSION 3.4.0
ENV HADOOP_CONF_DIR /root/hadoop-conf/hadoop/conf
ENV HADOOP_USER_NAME root

RUN pip install pyspark==$SPARK_VERSION
RUN pip install numpy
RUN pip install pandas

RUN git clone https://github.com/hjben/docker.git
RUN mv docker/ /root/hadoop-conf/
