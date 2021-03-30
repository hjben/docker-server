FROM hjben/centos-systemd:latest
MAINTAINER hjben <hj.ben.kim@gmail.com>

ENV PYTHON_VER python3.8
ENV NODE_VER 14
ENV HUE_HOME /usr/local/hue
ENV PATH=$PATH:$HUE_HOME/build/env/bin

RUN dnf install -y ant
RUN dnf install -y asciidoc
RUN dnf install -y cyrus-sasl-devel cyrus-sasl-gssapi cyrus-sasl-plain
RUN dnf install -y gcc gcc-c++
RUN dnf install -y krb5-devel
RUN dnf install -y libffi-devel libxml2-devel libxslt-devel
RUN dnf install -y make
RUN dnf install -y mysql mysql-devel
RUN dnf install -y openldap-devel
RUN dnf install -y sqlite-devel
RUN dnf install -y gmp-devel

RUN dnf install -y $(echo $PYTHON_VER | sed 's/\.//g') $(echo $PYTHON_VER | sed 's/\.//g')-devel
RUN dnf install -y git

RUN dnf module enable -y nodejs:$(echo $NODE_VER)
RUN dnf install -y nodejs

WORKDIR /usr/bin
RUN ln -s python3 python && ln -s pip3 pip

WORKDIR /usr/local
RUN git clone https://github.com/cloudera/hue.git
RUN cd ./hue && make apps
ADD pseudo-distributed.ini $HUE_HOME/desktop/conf/

WORKDIR /
EXPOSE 8000

ENTRYPOINT ["/usr/sbin/init"]