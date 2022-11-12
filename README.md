# Docker Scripts

We provide scripts for build and run docker conveniently.

## Docker tag
The docker repository(`$DOCKER_REPO`) and tag(`$DOCKER_TAG`) are set in `env.sh`.

## Build the docker
```
./docker_scripts/build_docker.sh [path to your dockerfile]
```

To set docker tag, you can run the command like:
```
DOCKER_REPO=ubuntu DOCKER_TAG=latest ./docker_scripts/build_docker.sh [path to your dockerfile]
```

## Start the docker container

We can start the docker container with following script:
```
./docker_scripts/docker_start.sh
```

By default, we mount some host directories to the docker container, like the `$HOME` directory. You can add more directories to the docker by modify the function `local_volumes()` in `docker_start.sh`. The default workspace is `$HOME`.

## Enter into the docker container

We can run this script to enter into the container.
```
./docker_scripts/docker_into.sh
```
This will create a new bash session in the container. 