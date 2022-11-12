#!/usr/bin/env bash
SHELL_PATH="$( cd "$( dirname "$0"  )" && pwd  )"
source $SHELL_PATH/env.sh

DOCKERFILE=$1

CONTEXT="$( dirname "${BASH_SOURCE[0]}" )"

echo ${DOCKER_REPO}
docker build -t "${DOCKER_REPO}:${DOCKER_TAG}" \
    -f $DOCKERFILE \
    --network host \
    $CONTEXT
