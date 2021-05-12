FROM hjben/jupyter-lab:latest
MAINTAINER hjben <hj.ben.kim@gmail.com>

ENV HADOOP_CONF_DIR /root/hadoop-conf/
ENV HADOOP_USER_NAME root

RUN pip install pyspark
RUN pip install numpy
RUN pip install pandas

RUN dnf install -y git

RUN git clone https://github.com/hjben/hadoop.git
RUN mv hadoop/ $HADOOP_CONF_DIR
