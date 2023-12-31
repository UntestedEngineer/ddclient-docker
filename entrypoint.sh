#!/bin/sh
set -e
mkdir -p /var/cache/ddclient/

: "${DDNS_DAEMON_OR_ONESHOT?Need to set DDNS_DAEMON_OR_ONESHOT env var}"

# Set the daemon refresh interval to the value of the DDNS_DAEMON_REFRESH_INTERVAL
# environment variable if it's present; default to 30 seconds if it's not.
DAEMON_REFRESH_INTERVAL=${DDNS_DAEMON_REFRESH_INTERVAL:-30}

if  [ "$DDNS_DAEMON_OR_ONESHOT" = "daemon" ]
then
    ddclient -foreground -verbose -daemon=$DAEMON_REFRESH_INTERVAL
elif [ "$DDNS_DAEMON_OR_ONESHOT" = "oneshot" ]
then
    ddclient -foreground -verbose -daemon=0
else
    echo "DDNS_DAEMON_OR_ONESHOT should be set to daemon or to oneshot"
fi