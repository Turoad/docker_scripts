#!/usr/bin/env bash
SHELL_PATH="$( cd "$( dirname "$0"  )" && pwd  )"
source $SHELL_PATH/env.sh

SHELL=bash

xhost +local:root 1>/dev/null 2>&1
docker exec \
    -u $USER \
    -it $DOCKER_NAME \
    /bin/$SHELL
xhost -local:root 1>/dev/null 2>&1
