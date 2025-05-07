#!/bin/bash

set -e

DOCKER_IMAGE_NAME="aos_rpi_yocto:latest"
WORKSPACE="$(pwd)"
INTERACTIVE="1"

function usage() {
    cat <<EOF

Run Aos Yocto docker container

Usage: $(basename "$0") [OPTIONS]

Options:
    -d, --docker_image      Docker image that should be used for building Yocto (default: ${DOCKER_IMAGE_NAME})
    -w, --workspace         Path to the workspace directory (default: current directory)
    -n, --non-interactive   Run in non-interactive mode
    -h, --help              Display this help message and exit
EOF
}

options=$(getopt -o hd:w:n \
    --long docker_image:,workspace:,non-interactive \
    --long help \
    -- "$@")

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

    -w | --workspace)
        WORKSPACE="$(readlink -f "$2")"
        shift 2
        ;;

    -n | --non-interactive)
        INTERACTIVE=
        shift
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

echo "Docker image name: $DOCKER_IMAGE_NAME"
echo "Workspace:         $WORKSPACE"

mkdir -p "$WORKSPACE"

# Run docker image
docker run \
    -v "${WORKSPACE}":/home/yocto/workspace \
    -u "$(id -u):$(id -g)" \
    ${INTERACTIVE:+-it} \
    --rm "$DOCKER_IMAGE_NAME" "$@"
