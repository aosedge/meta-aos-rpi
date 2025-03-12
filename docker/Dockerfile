FROM zephyrprojectrtos/ci:v0.27.4

RUN apt-get update && apt-get install -y \
    curl \
    git \
    unzip \
    python3 \
    python3-pip \ 
    ninja-build \
    locales \
    locales-all \
    chrpath \
    cpio \
    diffstat \
    file \
    gawk \
    wget \
    zstd \
    liblz4-tool \
    git-lfs \
    cmake \
    dosfstools \
    mtools 

RUN locale-gen en_US.UTF-8 && \
    update-locale LANG=en_US.UTF-8

ENV LANG=en_US.UTF-8
ENV LANGUAGE=en_US:en
ENV LC_ALL=en_US.UTF-8
ENV PATH="/home/user/.local/bin:/root/.local/bin:${PATH}"

RUN echo "export PATH=$PATH" >> /etc/environment
RUN pip3 install git+https://github.com/xen-troops/moulin 
RUN pip3 install west google google-api-core pyelftools
RUN cd /tmp/ && curl -OL https://github.com/protocolbuffers/protobuf/releases/download/v25.6/protoc-25.6-linux-x86_64.zip && \
    unzip protoc-25.6-linux-x86_64.zip -d protoc3 && \
    cp -r protoc3/bin/* /usr/local/bin/ && \
    cp -r protoc3/include/* /usr/local/include/ && \
    rm -rf protoc3 protoc-25.6-linux-x86_64.zip
RUN chown -R user:user /usr/local/include/google

USER user
