WORK_ROOT=$HOME
if [ -z "${DOCKER_REPO}" ]; then
    DOCKER_REPO=turoad/clrnet
fi

if [ -z "${DOCKER_TAG}" ]; then
    DOCKER_TAG=torch1.13-tensorrt8.5
fi

IMG=${DOCKER_REPO}:${DOCKER_TAG}

DOCKER_HOME="/home/$USER"
if [ "$USER" == "root" ];then
    DOCKER_HOME="/root"
fi

if [ -z $DOCKER_NAME ];then
    DOCKER_NAME="${USER}_${DOCKER_TAG}_container"
fi

DATE=$(date +%F)
LOCAL_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )/.." && pwd )"
