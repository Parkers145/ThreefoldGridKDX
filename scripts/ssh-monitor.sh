#!/bin/bash

# Path to the log file
LOGFILE=/var/log/ssh-monitor.log

# Function to handle display transfer
transfer_display() {
    local action=$1
    local ip=$2
    if [ "$action" == "connect" ]; then
        echo "Transferring display to $ip:10.0" | tee -a $LOGFILE
        export DISPLAY=$ip:10.0
    elif [ "$action" == "disconnect" ]; then
        echo "Restoring display to :99" | tee -a $LOGFILE
        export DISPLAY=:99
    fi
}

# Monitor for SSH connections
while true; do
    new_conn=$(ss -tnp | grep sshd | grep ESTAB | awk '{print $5}' | cut -d: -f1)
    if [ ! -z "$new_conn" ]; then
        if [ -z "$SSH_CONNECTED" ]; then
            SSH_CONNECTED=1
            CLIENT_IP=$new_conn
            transfer_display connect $CLIENT_IP
        fi
    else
        if [ ! -z "$SSH_CONNECTED" ]; then
            SSH_CONNECTED=
            transfer_display disconnect
        fi
    fi
    sleep 1
done