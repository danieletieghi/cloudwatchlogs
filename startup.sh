#!/bin/sh

test -z $FOLLOW_LOG_FILE && FOLLOW_LOG_FILE=/var/log/syslog
test -z $UDP_PORT && UDP_PORT=514
test -z $TCP_PORT && TCP_PORT=514
test -z $LOG_GROUP_NAME && LOG_GROUP_NAME=awslogs
test -z $LOG_STREAM_NAME && LOG_STREAM_NAME=syslog
test -z $AWS_REGION && AWS_REGION="us-east-1"
test -z $BUFFER_DURATION && BUFFER_DURATION="5000"
test -z $INITIAL_POSITION && INITIAL_POSITION="start_of_file"
test -z $DATETIME_FORMAT && DATETIME_FORMAT="%Y-%m-%d %H:%M:%S"

sed -i "s/#\$ModLoad imudp/\$ModLoad imudp/" /etc/rsyslog.conf && \
sed -i "s/#\$UDPServerRun $UDP_PORT/\$UDPServerRun $UDP_PORT/" /etc/rsyslog.conf && \
sed -i "s/#\$ModLoad imtcp/\$ModLoad imtcp/" /etc/rsyslog.conf && \
sed -i "s/#\$InputTCPServerRun $TCP_PORT/\$InputTCPServerRun $TCP_PORT/" /etc/rsyslog.conf

/etc/init.d/rsyslog restart

cat - > /awslogs.conf <<EOF
[general]
state_file = /var/awslogs/state/agent-state

[syslog]
datetime_format = $DATETIME_FORMAT
file = $FOLLOW_LOG_FILE
buffer_duration = $BUFFER_DURATION
log_stream_name = $LOG_STREAM_NAME
initial_position = $INITIAL_POSITION
log_group_name = $LOG_GROUP_NAME
EOF

python ./awslogs-agent-setup.py -n -r $AWS_REGION -c /awslogs.conf

/usr/local/bin/supervisord

