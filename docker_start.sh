#!/usr/bin/env bash

SHELL_PATH="$( cd "$( dirname "$0"  )" && pwd  )"
source $SHELL_PATH/env.sh

function local_volumes() {
  volumes="-v /dev/null:/dev/raw1394\
           -v /private:/private\
           -v /tmp/core:/tmp/core"

  case "$(uname -s)" in
    Linux)
      volumes="${volumes} -v /tmp/.X11-unix:/tmp/.X11-unix:rw \
                          -v /media:/media \
                          -v /mnt/:/mnt \
                          -v $HOME:$HOME \
                          -v /etc/localtime:/etc/localtime:ro \
                          -v $LOCAL_DIR:/workspace"
      ;;
  esac

  echo "${volumes}"
}

function add_user(){
  scripts="addgroup --gid '$GRP_ID' '$GRP' && \
  adduser --disabled-password --gecos '' '$USER' \
      --uid '$USER_ID' --gid '$GRP_ID' 2>/dev/null && \
  usermod -aG sudo '$USER' && \
  echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers"
  echo $scripts
}


function main(){
    docker pull ${DOCKER_REPO}:${DOCKER_TAG}
    docker ps -a --format "{{.Names}}" | grep "${DOCKER_NAME}" 1>/dev/null
    if [ $? == 0 ]; then
        docker stop ${DOCKER_NAME} 1>/dev/null
        docker rm -f ${DOCKER_NAME} 1>/dev/null
    fi

    USER_ID=$(id -u)
    GRP=$(id -g -n)
    GRP_ID=$(id -g)
    if [ ! -d "$HOME/.cache" ];then
        mkdir "$HOME/.cache"
    fi
    if [ -z "$(command -v nvidia-smi)" ]; then
        echo "Nvidia gpu can not be used in the docker!"
        CMD="docker"
    else
        CMD="nvidia-docker"
    fi

    eval ${CMD} run -it \
        -d \
        --name ${DOCKER_NAME}\
        -e DOCKER_USER=$USER \
        -e USER=$USER \
        -e DOCKER_USER_ID=$USER_ID \
        -e DOCKER_GRP=$GRP \
        -e DOCKER_GRP_ID=$GRP_ID \
        -e DOCKER_HOME=$DOCKER_HOME \
        $(local_volumes) \
        -w $DOCKER_HOME \
        --net=host \
        --shm-size 2G \
        --security-opt seccomp=unconfined \
        $IMG

    if [ "${USER}" != "root" ]; then
        docker exec ${DOCKER_NAME} bash -c "$(add_user)"
    fi
 }

main
