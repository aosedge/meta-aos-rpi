#!/bin/bash

IMAGE_NAME="meta-aos-rpi"
CONTAINER_NAME="meta-aos-rpi_container"
ARTIFACTS_DIR="$(pwd)/artifacts"

# List aos-rpi.yaml parameters.
DOMD_NODE_TYPE="main"
MACHINE="rpi5"
DOMD_ROOT="usb"
SELINUX="disabled"
BUILD_ENVIRONMENT="local"

error_and_exit() {
    echo "$1">&2
    
    exit 1
}

while [[ "$#" -gt 0 ]]; do
    case "$1" in
        --ARTIFACTS_DIR)
            ARTIFACTS_DIR="$2"
            shift 2
            ;;
        --VIS_DATA_PROVIDER)
            VIS_DATA_PROVIDER="$2"
            shift 2
            ;;
        --DOMD_NODE_TYPE)
            DOMD_NODE_TYPE="$2"
            shift 2
            ;;
        --MACHINE)
            MACHINE="$2"
            shift 2
            ;;
        --DOMD_ROOT)
            DOMD_ROOT="$2"
            shift 2
            ;;
        --SELINUX)
            SELINUX="$2"
            shift 2
            ;;
        --BUILD_ENVIRONMENT)
            BUILD_ENVIRONMENT="$2"
            shift 2
            ;;
        *)
            shift 
            ;;
    esac
done


if ! command -v docker &> /dev/null; then
    error_and_exit "Docker is not installed. Please install Docker and try again."
fi

if ! docker info &> /dev/null; then
    error_and_exit "Docker daemon is not running. Please start Docker daemon and try again."
fi

mkdir -p "$ARTIFACTS_DIR"
chmod 777 "$ARTIFACTS_DIR"

echo "Building Docker image: $IMAGE_NAME"

docker build -t "$IMAGE_NAME" .

echo "Starting new container: $CONTAINER_NAME"

docker run --rm -w /meta-aos-rpi -v "$(realpath ./../):/meta-aos-rpi" -v "$ARTIFACTS_DIR:/tmp/artifacts" --name "$CONTAINER_NAME" "$IMAGE_NAME" tail -f /dev/null
if ! docker ps --format '{{.Names}}' | grep -q "^$CONTAINER_NAME$"; then
    error_and_exit "Container $CONTAINER_NAME failed to start."
fi

echo "Building install.img"

CMD="cd /tmp/artifacts && moulin aos-rpi.yaml"
[[ -n "$VIS_DATA_PROVIDER" ]] && CMD+=" --VIS_DATA_PROVIDER \"$VIS_DATA_PROVIDER\""
[[ -n "$DOMD_NODE_TYPE" ]] && CMD+=" --DOMD_NODE_TYPE \"$DOMD_NODE_TYPE\""
[[ -n "$MACHINE" ]] && CMD+=" --MACHINE \"$MACHINE\""
[[ -n "$DOMD_ROOT" ]] && CMD+=" --DOMD_ROOT \"$DOMD_ROOT\""
[[ -n "$SELINUX" ]] && CMD+=" --SELINUX \"$SELINUX\""
[[ -n "$BUILD_PLATFORM" ]] && CMD+=" --BUILD_PLATFORM \"$BUILD_ENVIRONMENT\""
CMD+=" && ninja install.img"

if docker exec "$CONTAINER_NAME" bash -c "
    $CMD
"; then
    echo "Congratulations! Build completed successfully. Artifacts: $ARTIFACTS_DIR"
else
    error_and_exit "Build did not complete successfully! Please look to output for more details."
fi
