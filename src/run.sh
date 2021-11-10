#!/bin/bash

set_env () {
    local ENV_NAME=$(echo ${TUNNEL_ENV_PREFIX}_${1})
    eval $(echo "export ${1}=${!ENV_NAME}")
}

if [ ! -z $TUNNEL_ENV_PREFIX ]; then
  set_env "TUNNEL_EXPOSE_PORT"
  set_env "TUNNEL_DESTINATION_HOST"
  set_env "TUNNEL_DESTINATION_PORT"
  set_env "TUNNEL_SERVER_HOST_NAME"
fi

/usr/bin/autossh \
  -M0 -T -N \
  -oStrictHostKeyChecking=no \
  -oServerAliveInterval=180 \
  -oUserKnownHostsFile=/dev/null \
  -L *:$TUNNEL_EXPOSE_PORT:$TUNNEL_DESTINATION_HOST:$TUNNEL_DESTINATION_PORT $TUNNEL_SERVER_HOST_NAME
