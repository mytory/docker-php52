#!/bin/bash

echo -e $(/sbin/ip route|awk '/default/ { print $3 }')'\t'host-computer >> /etc/hosts

# Apache gets grumpy about PID files pre-existing
rm -f /var/run/apache2/apache2.pid && \
/usr/sbin/apache2ctl -D FOREGROUND