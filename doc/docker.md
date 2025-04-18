# Build with docker

You can build Aos RPI image inside a docker container with all required packages installed.

First, the docker image should be build:

```console
docker/build_docker.sh -f docker/Dockerfile
```

Then use the same commands as for native build as position arguments for run cocker script. Docker build doesn't
support outside cache location. Though, `CACHE_LOCATION` parameter should be set to `inside`. See
[Manual build](build.md#build) for details.

## Build install image for usb

```console
moulin aos-rpi.yaml --DOMD_ROOT=usb
ninja install-usb.img
```

## Build install image for NVMe

```console
moulin aos-rpi.yaml --DOMD_ROOT=nvme
ninja install-nvme.img
```
