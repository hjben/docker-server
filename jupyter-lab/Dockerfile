FROM hjben/centos-openjdk:latest
MAINTAINER hjben <hj.ben.kim@gmail.com>

RUN dnf install -y python38

WORKDIR /usr/bin
RUN ln -s python3 python && ln -s pip3 pip

WORKDIR /
RUN pip install jupyterlab

RUN jupyter lab --generate-config
RUN mkdir /root/workspace
ADD conf/jupyter_notebook_config.py /root/.jupyter/jupyter_notebook_config.py

EXPOSE 8888