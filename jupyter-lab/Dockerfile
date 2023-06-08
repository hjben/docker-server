FROM hjben/rockylinux-openjdk:latest
MAINTAINER hjben <hj.ben.kim@gmail.com>

RUN dnf install -y python3.11
RUN dnf install -y python3.11-pip
RUN dnf install -y git

WORKDIR /usr/bin
RUN ln -s python3.11 python && ln -s pip3.11 pip

WORKDIR /
RUN pip install jupyterlab

RUN jupyter lab --generate-config
RUN mkdir /root/workspace
ADD conf/jupyter_lab_config.py /root/.jupyter/jupyter_lab_config.py

EXPOSE 8888