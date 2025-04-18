#!/bin/bash

set -e

DOCKER_IMAGE_NAME="aos_rpi_yocto:latest"
DOCKER_FILE_NAME="Dockerfile"

function usage() {
    cat <<EOF

Build Aos Yocto docker image

Usage: $(basename "$0") [OPTIONS]

Options:
    -d, --docker_image    Docker image that should be used for building Yocto (default: ${DOCKER_IMAGE_NAME})
    -f, --docker_file     Path to the docker file (default: ${DOCKER_FILE_NAME})
    -h, --help            Display this help message and exit
EOF
}

options=$(getopt -o hd:f: \
    --long docker_image:,docker_file: \
    --long help \
    -- "$@")

# Map option variable to positional arguments (i.e. $1, $2 ...)
eval set -- "$options"

while true; do
    case "$1" in
    -h | --help)
        usage
        exit 0
        ;;

    -d | --docker_image)
        DOCKER_IMAGE_NAME="$2"
        shift 2
        ;;

    -f | --docker_file)
        DOCKER_FILE_NAME="$2"
        shift 2
        ;;

    --)
        shift
        break
        ;;

    *)
        echo "Unexpected option: $1"
        usage
        exit 1
        ;;
    esac
done

if [ $# -gt 0 ]; then
    echo "Unexpected argument(s): $*"
    exit 1
fi

echo "Docker image name: $DOCKER_IMAGE_NAME"
echo "Docker file name:  $DOCKER_FILE_NAME"

docker build . -f "$DOCKER_FILE_NAME" --build-arg "USER_ID=$(id -u)" --build-arg "USER_GID=$(id -g)" -t "$DOCKER_IMAGE_NAME"
