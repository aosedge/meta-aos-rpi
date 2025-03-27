# Build with docker

You can build install images inside a docker container by simply running the following command:

```sh
cd ./docker
./build.sh
```

You can also pass the following arguments:

| Argument             | Description |Mandatory|
|----------------------|-------------|---------|
| `--ARTIFACTS_DIR`       | Path to the directory where the build results will be stored. |NO|
| `--VIS_DATA_PROVIDER`   | Same value as described in the [Build](build.md#build) section. |NO|
| `--DOMD_NODE_TYPE`      | Same value as described in the [Build](build.md#build) section. |NO|
| `--MACHINE`             | Same value as described in the [Build](build.md#build) section. |NO|
| `--DOMD_ROOT`           | Same value as described in the [Build](build.md#build) section. |NO|
| `--SELINUX`             | Same value as described in the [Build](build.md#build) section. |NO|

Example command:

```sh
cd ./docker
./build.sh --DOMD_ROOT usb
```

or

```sh
cd ./docker
./build.sh --DOMD_ROOT nvme
```
