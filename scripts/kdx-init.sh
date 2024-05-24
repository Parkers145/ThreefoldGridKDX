#!/bin/bash

# Path to the log file
LOGFILE=/var/log/kdx-init.log

# Ensure necessary environment variables are set
export nwjsVersion=v0.75.0
export DISPLAY=:99
export CARGO_HOME=/root/.cargo
export PATH=/root/bin/nwjs-sdk-${nwjsVersion}-linux-x64:/root/bin/nwjs:/root/bin:/usr/local/go/bin:/root/.cargo/bin:/sbin:/usr/bin:/bin:$PATH

# Log environment setup
echo "Setting up environment variables..." | tee -a $LOGFILE

# Start Xvfb to set up virtual display
echo "Starting Xvfb on display $DISPLAY..." | tee -a $LOGFILE
Xvfb $DISPLAY -screen 0 1024x768x16 &

# Ensure Xvfb is running
sleep 2

# Log D-Bus environment variables
echo "Setting up D-Bus environment variables..." | tee -a $LOGFILE
export $(dbus-launch)
echo "DBUS_SESSION_BUS_ADDRESS=$DBUS_SESSION_BUS_ADDRESS" | tee -a $LOGFILE
echo "DBUS_SESSION_BUS_PID=$DBUS_SESSION_BUS_PID" | tee -a $LOGFILE

# Start KDX
echo "Starting KDX on display $DISPLAY..." | tee -a $LOGFILE
cd ~/kdx
dbus-launch nw . --disable-features=ChromeBrowserCloudManagement &

# Log the KDX start
echo "KDX initialized and running on display $DISPLAY." | tee -a $LOGFILE

# Keep the script running
tail -f /var/log/kdx-init.log
