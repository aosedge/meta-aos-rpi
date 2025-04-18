FROM ubuntu:22.04

ARG ZEPHYR_SDK_VERSION=0.17.0

ENV LANG=en_US.UTF-8
ENV LANGUAGE=en_US:en
ENV LC_ALL=en_US.UTF-8
ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y \
    chrpath \
    cmake \
    cpio \
    curl \
    diffstat \
    dosfstools \
    file \
    gawk \
    git \
    git-lfs \
    gperf \
    liblz4-tool \
    locales \
    locales-all \
    mtools \
    ninja-build \
    python3 \
    python3-pip \ 
    unzip \
    wget \
    zstd

RUN locale-gen en_US.UTF-8 && \
    update-locale LANG=en_US.UTF-8

# Install moulin

RUN pip3 install git+https://github.com/xen-troops/moulin 

# Install protoc

RUN pip3 install google google-api-core pyelftools
RUN curl -OL https://github.com/protocolbuffers/protobuf/releases/download/v25.6/protoc-25.6-linux-x86_64.zip
RUN unzip protoc-25.6-linux-x86_64.zip -d /usr/local
RUN rm -f protoc3 protoc-25.6-linux-x86_64.zip

# Install Zephyr SDK

RUN pip3 install west
RUN wget https://github.com/zephyrproject-rtos/sdk-ng/releases/download/v${ZEPHYR_SDK_VERSION}/zephyr-sdk-${ZEPHYR_SDK_VERSION}_linux-x86_64_minimal.tar.xz
RUN wget -O - https://github.com/zephyrproject-rtos/sdk-ng/releases/download/v${ZEPHYR_SDK_VERSION}/sha256.sum | shasum --check --ignore-missing
RUN tar xvf zephyr-sdk-${ZEPHYR_SDK_VERSION}_linux-x86_64_minimal.tar.xz -C /opt
RUN rm -f zephyr-sdk-${ZEPHYR_SDK_VERSION}_linux-x86_64_minimal.tar.xz
RUN cd /opt/zephyr-sdk-${ZEPHYR_SDK_VERSION} && ./setup.sh -t aarch64-zephyr-elf -h -c

# Define name for user and uid/gid
ENV USER_NAME=yocto
ARG USER_ID=1000
ARG USER_GID=1000

# Creating the user
RUN groupadd --gid "${USER_GID}" "${USER_NAME}" && \
    useradd \
    --uid ${USER_ID} \
    --gid ${USER_GID} \
    --create-home \
    --shell /bin/bash \
    ${USER_NAME}

USER ${USER_NAME}

WORKDIR /home/yocto/workspace
