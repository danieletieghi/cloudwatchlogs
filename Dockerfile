FROM debian:jessie
MAINTAINER Brian Whigham <oobx@itmonger.com>

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get -q update && \
  apt-get -y -q install rsyslog python-setuptools python-pip curl

RUN curl https://s3.amazonaws.com/aws-cloudwatch/downloads/latest/awslogs-agent-setup.py -o awslogs-agent-setup.py

RUN pip install supervisor
COPY supervisord.conf /usr/local/etc/supervisord.conf
COPY startup.sh startup.sh

EXPOSE 514/tcp 514/udp
CMD startup.sh
