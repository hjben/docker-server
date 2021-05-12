FROM hjben/centos-openjdk:11
MAINTAINER hjben <hj.ben.kim@gmail.com>

ENV CMAK_HOME /usr/local/cmak
ENV CMAK_VERSION 3.0.0.5
ENV PATH $PATH:$CMAK_HOME/bin

RUN dnf install -y zip unzip

RUN wget https://github.com/yahoo/CMAK/archive/$CMAK_VERSION.tar.gz
RUN tar -xvf $CMAK_VERSION.tar.gz && \
    rm -f $CMAK_VERSION.tar.gz

WORKDIR /CMAK-$CMAK_VERSION 
RUN ./sbt clean dist
RUN mv ./target/universal/cmak-$CMAK_VERSION.zip /usr/local

WORKDIR /usr/local
RUN unzip cmak-$CMAK_VERSION.zip &&\
    rm -f cmak-$CMAK_VERSION.zip
RUN ln -s cmak-$CMAK_VERSION $CMAK_HOME

WORKDIR /
# ADD application.conf $CMAK_HOME/conf/application.conf

EXPOSE 9000



