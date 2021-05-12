FROM hjben/centos-systemd:latest
MAINTAINER hjben <hj.ben.kim@gmail.com>

ENV AIRFLOW_VERSION 2.0.2
ENV AIRFLOW_HOME /usr/local/airflow
ENV PYTHON_VERSION 3.8
ENV PIP_VERSION 20.2.4

RUN dnf install -y python38

WORKDIR /usr/bin
RUN ln -s python3 python && ln -s pip3 pip

WORKDIR /
RUN pip install --upgrade pip==$PIP_VERSION
RUN pip install apache-airflow==$AIRFLOW_VERSION \
    --constraint "https://raw.githubusercontent.com/apache/airflow/constraints-$AIRFLOW_VERSION/constraints-$PYTHON_VERSION.txt"
RUN pip install apache-airflow[redis,celery]
RUN pip install mysql-connector-python

RUN airflow --help
RUN mkdir $AIRFLOW_HOME/dags
ADD airflow.cfg $AIRFLOW_HOME/

EXPOSE 5555 8080 8793

