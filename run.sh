#!/bin/bash
/usr/sbin/postfix start
/usr/sbin/saslauthd -m /run/saslauthd -a pam

while true; do
    sleep 10
done
