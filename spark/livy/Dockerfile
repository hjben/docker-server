FROM hjben/spark:3.1.1-jdk1.8.0
MAINTAINER hjben <hj.ben.kim@gmail.com>

ENV LIVY_VERSION 0.7.0
ENV LIVY_HOME /usr/local/livy
ENV PATH $PATH:$LIVY_HOME/bin

RUN dnf install -y unzip
RUN wget https://downloads.apache.org/incubator/livy/$LIVY_VERSION-incubating/apache-livy-$LIVY_VERSION-incubating-bin.zip
RUN unzip apache-livy-$LIVY_VERSION-incubating-bin && \
    mv apache-livy-$LIVY_VERSION-incubating-bin /usr/local && \
    rm -f apache-livy-$LIVY_VERSION-incubating-bin.zip
RUN ln -s /usr/local/apache-livy-$LIVY_VERSION-incubating-bin $LIVY_HOME

# WORKDIR /usr/local
# RUN git clone https://github.com/apache/incubator-livy.git
# RUN ln -s /usr/local/incubator-livy $LIVY_HOME

# WORKDIR /usr/local/incubator-livy
# RUN dnf install -y maven
# RUN mvn package

WORKDIR /

EXPOSE 8998
