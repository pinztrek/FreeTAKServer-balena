#!/bin/bash

# Source the file with default args
. /fts_args.env

# Now assign the default if it's not already set
if [ -z "$FTS_COT_PORT" ]; then
    export FTS_COT_PORT=$DEF_FTS_COT_PORT
fi

if [ -z "$FTS_SSLCOT_PORT" ]; then
    export FTS_SSLCOT_PORT=$DEF_FTS_SSLCOT_PORT
fi
if [ -z "$FTS_DP_ADDRESS" ]; then
    export FTS_DP_ADDRESS=$DEF_FTS_DP_ADDRESS
fi

if [ -z "$FTS_USER_ADDRESS" ]; then
    export FTS_USER_ADDRESS=$DEF_FTS_USER_ADDRESS
fi

if [ -z "$FTS_API_PORT" ]; then
    export FTS_API_PORT=$DEF_FTS_API_PORT
fi

if [ -z "$FTS_API_ADDRESS" ]; then
    export FTS_API_ADDRESS=$DEF_FTS_API_ADDRESS
fi

# If no connect string override, and we have one defined, use it. 
# Otherwise use default in FTS code
# Note: This depends on FTS pull request to set this as var
if [ -z "$FTS_CONNECT_STRING" ] && [ -n "$DEF_FTS_CONNECT_STRING" ]
then
    export FTS_CONNECT_STRING=$DEF_FTS_CONNECT_STRING
fi

if [ -z "$FTS_COT_TO_DB" ]; then
    export FTS_COT_TO_DB=$DEF_FTS_COT_TO_DB
fi

if [ -z "$FTS_DATA_PATH" ]; then
    export FTS_DATA_PATH=$DEF_FTS_DATA_PATH
fi

if [ -z "$FTS_CERTS_PATH" ]; then
    export FTS_CERTS_PATH=$DEF_FTS_CERTS_PATH
fi

if [ -z "$FTS_FED_PORT" ]; then
    export FTS_FED_PORT=$DEF_FTS_FED_PORT
fi

if [ -z "$FTS_FED_PASSWORD" ]; then
    export FTS_FED_PASSWORD=$DEF_FTS_FED_PASSWORD
fi

if [ -z "$FTS_PASSWORD" ]; then
    export FTS_PASSWORD=$DEF_FTS_PASSWORD
fi

if [ -z "$FTS_WEBSOCKET_KEY" ]; then
    export FTS_WEBSOCKET_KEY=$DEF_FTS_WEBSOCKET_KEY
fi

#if [ -z "$FTS_NODE_ID" ]; then
#    export FTS_NODE_ID=$DEF_FTS_NODE_ID
#fi

echo params ----------------------------------------------
set | grep FTS | grep -v DEF

#verify if we have access to datadir
if ! touch /data/.verify_access; then
  log "ERROR: /data doesn't seem to be writable. Please make sure attached directory is writable by uid=$(id -u)"
  exit 2
fi

#echo /libdirs ----------------------------------------------
#ls -l /usr/local/lib/python3.8/dist-packages/FreeTAKServer/

# create cert dirs
mkdir -p -m 775 /data/certs
chown --quiet fts:fts /data/certs
mkdir -p -m 775 /data/certs/ClientPackages
chown --quiet fts:fts /data/certs/ClientPackages

#FTS doesn't pre-create logs directory
mkdir -pv -m 775 /data/log
chown --quiet fts:fts /data/log

echo /data ----------------------------------------------
ls -l /data

python3 -m FreeTAKServer.controllers.services.FTS ${FTS_ARGS} -AutoStart True
# Sleep for a bit in case it exits unexpectedly
sleep 30
